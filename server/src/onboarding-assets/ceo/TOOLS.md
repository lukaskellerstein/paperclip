# Tools — CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Git workflows, dead-code analysis, dependency updates, docs generation |
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| mermaid | `mcp__plugin_media-plugin_mermaid` | Diagram generation and validation |
| media-playwright | `mcp__plugin_media-plugin_media-playwright` | Browser automation for media tasks |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var.

**Services:** Gmail (send, read, reply, triage), Calendar (events, agenda, create), Drive, Docs, Sheets, Tasks, Meet.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use **office-plugin** for board decks, strategy documents, and spreadsheets.
- Use **dev-tools-plugin** for repository oversight and documentation generation.
- Use **mermaid** for org charts, flowcharts, and architecture diagrams.
- Use **Google Workspace** for email communication, scheduling, and document collaboration.
- Delegate specialized tool usage (infra, design, code) to your reports.

---
*Add personal tool notes below as you discover and use tools.*
