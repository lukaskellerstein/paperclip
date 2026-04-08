#!/bin/sh
set -e

# Capture runtime UID/GID from environment variables, defaulting to 1000
PUID=${USER_UID:-1000}
PGID=${USER_GID:-1000}

# Adjust the node user's UID/GID if they differ from the runtime request
# and fix volume ownership only when a remap is needed
changed=0

if [ "$(id -u node)" -ne "$PUID" ]; then
    echo "Updating node UID to $PUID"
    usermod -o -u "$PUID" node
    changed=1
fi

if [ "$(id -g node)" -ne "$PGID" ]; then
    echo "Updating node GID to $PGID"
    groupmod -o -g "$PGID" node
    usermod -g "$PGID" node
    changed=1
fi

# Always ensure the volume tree is owned by node, whether UID/GID
# was remapped or the volume was freshly created / written by another process.
chown -R node:node /paperclip 2>/dev/null || true

# ---------------------------------------------------------------------------
# Docker socket access: match node user's group to the socket's GID
# so agents can run docker build/push via the host daemon.
# ---------------------------------------------------------------------------
if [ -S /var/run/docker.sock ]; then
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock)
    if ! getent group "$DOCKER_SOCK_GID" > /dev/null 2>&1; then
        groupadd -g "$DOCKER_SOCK_GID" dockerhost
    fi
    DOCKER_GROUP_NAME=$(getent group "$DOCKER_SOCK_GID" | cut -d: -f1)
    usermod -aG "$DOCKER_GROUP_NAME" node
    echo "[paperclip-init] Docker socket accessible (GID=$DOCKER_SOCK_GID, group=$DOCKER_GROUP_NAME)"
fi

# ---------------------------------------------------------------------------
# Docker Hub login: authenticate with a separate account for agents
# Set DOCKER_HUB_USERNAME and DOCKER_HUB_TOKEN in .env
# ---------------------------------------------------------------------------
if [ -n "${DOCKER_HUB_USERNAME:-}" ] && [ -n "${DOCKER_HUB_TOKEN:-}" ]; then
    mkdir -p /paperclip/.docker
    chown node:node /paperclip/.docker
    echo "$DOCKER_HUB_TOKEN" | gosu node docker login -u "$DOCKER_HUB_USERNAME" --password-stdin 2>&1
    echo "[paperclip-init] Docker Hub login as $DOCKER_HUB_USERNAME"
fi

# Pre-create Claude Code directories so the Bash tool can function
# immediately without hitting "permission denied" on first run.
CLAUDE_HOME="/paperclip/.claude"
mkdir -p "$CLAUDE_HOME/session-env"

chown -R node:node "$CLAUDE_HOME"

# ---------------------------------------------------------------------------
# Claude Code pre-configuration from /docker-init/claude/ (bind-mounted)
# ---------------------------------------------------------------------------
INIT_DIR="/docker-init/claude"

if [ -d "$INIT_DIR" ]; then
    echo "[paperclip-init] Found Claude init directory at $INIT_DIR"

    # --- 1. Copy settings.json -------------------------------------------
    if [ -f "$INIT_DIR/settings.json" ]; then
        echo "[paperclip-init] Installing settings.json"
        cp "$INIT_DIR/settings.json" "$CLAUDE_HOME/settings.json"
        chown node:node "$CLAUDE_HOME/settings.json"
    fi

    # --- 2. Install marketplaces & plugins from plugins.json -------------
    if [ -f "$INIT_DIR/plugins.json" ]; then
        echo "[paperclip-init] Processing plugins.json"

        # Install marketplaces
        gosu node node -e "
            const cfg = JSON.parse(require('fs').readFileSync('$INIT_DIR/plugins.json','utf8'));
            if (cfg.marketplaces) cfg.marketplaces.forEach(m => {
                const scope = m.scope || 'user';
                console.log(m.source + ' ' + scope);
            });
        " 2>/dev/null | while IFS=' ' read -r source scope; do
            if [ -n "$source" ]; then
                echo "[paperclip-init] Adding marketplace: $source (scope: $scope)"
                gosu node claude plugins marketplace add "$source" --scope "$scope" 2>&1 || \
                    echo "[paperclip-init] Warning: marketplace '$source' may already exist or failed to add"
            fi
        done

        # Install plugins
        gosu node node -e "
            const cfg = JSON.parse(require('fs').readFileSync('$INIT_DIR/plugins.json','utf8'));
            if (cfg.plugins) cfg.plugins.forEach(p => {
                const scope = p.scope || 'user';
                console.log(p.name + ' ' + scope);
            });
        " 2>/dev/null | while IFS=' ' read -r name scope; do
            if [ -n "$name" ]; then
                echo "[paperclip-init] Installing plugin: $name (scope: $scope)"
                gosu node claude plugins install "$name" --scope "$scope" 2>&1 || \
                    echo "[paperclip-init] Warning: plugin '$name' may already exist or failed to install"
            fi
        done

        echo "[paperclip-init] Plugin setup complete"
    fi
else
    echo "[paperclip-init] No Claude init directory found at $INIT_DIR, skipping"
fi

exec gosu node "$@"
