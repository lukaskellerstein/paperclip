# Example Company Package

A minimal but complete example of an agent company package.

## Directory Structure

```
lean-dev-shop/
├── COMPANY.md
├── goals/
│   ├── build-ship-products/
│   │   ├── GOAL.md
│   │   └── ship-q2-launch/
│   │       └── GOAL.md
│   └── maintain-code-quality/
│       └── GOAL.md
├── agents/
│   ├── ceo/AGENTS.md
│   ├── cto/AGENTS.md
│   └── engineer/AGENTS.md
├── teams/
│   └── engineering/TEAM.md
├── projects/
│   └── q2-launch/
│       ├── PROJECT.md
│       └── tasks/
│           ├── 01-kickoff-meeting/TASK.md
│           ├── 02-monday-review/TASK.md
│           └── 03-weekly-standup/TASK.md
├── skills/
│   └── code-review/SKILL.md
└── .paperclip.yaml
```

## COMPANY.md

```markdown
---
name: Lean Dev Shop
description: Small engineering-focused AI company that builds and ships software products
slug: lean-dev-shop
schema: agentcompanies/v1
version: 1.0.0
license: MIT
authors:
  - name: Example Org
goals:
  - Build and ship software products
  - Maintain high code quality
---

Lean Dev Shop is a small, focused engineering company. The CEO oversees strategy and coordinates work. The CTO leads the engineering team. Engineers build and ship code.
```

## goals/build-ship-products/GOAL.md

```markdown
---
title: Build and ship software products
level: company
status: active
ownerAgentSlug: cto
projectSlugs: [q2-launch]
---

Deliver high-quality software products on schedule. Success criteria: ship the Q2 launch with all planned features and maintain deployment cadence.
```

## goals/build-ship-products/ship-q2-launch/GOAL.md

```markdown
---
title: Ship Q2 product launch
level: team
ownerAgentSlug: cto
projectSlugs: [q2-launch]
---

Deliver all features planned for the Q2 launch, including the new dashboard and API improvements.
```

## goals/maintain-code-quality/GOAL.md

```markdown
---
title: Maintain high code quality
level: company
status: active
ownerAgentSlug: cto
---

Enforce code review standards, maintain test coverage above 80%, and keep tech debt under control.
```

## agents/ceo/AGENTS.md

```markdown
---
name: CEO
title: Chief Executive Officer
reportsTo: null
skills:
  - paperclip
---

You are the CEO of Lean Dev Shop. You oversee company strategy, coordinate work across the team, and ensure projects ship on time.

Your responsibilities:

- Review and prioritize work across projects
- Coordinate with the CTO on technical decisions
- Ensure the company goals are being met
```

## agents/cto/AGENTS.md

```markdown
---
name: CTO
title: Chief Technology Officer
reportsTo: ceo
skills:
  - code-review
  - paperclip
---

You are the CTO of Lean Dev Shop. You lead the engineering team and make technical decisions.

Your responsibilities:

- Set technical direction and architecture
- Review code and ensure quality standards
- Mentor engineers and unblock technical challenges
```

## agents/engineer/AGENTS.md

```markdown
---
name: Engineer
title: Software Engineer
reportsTo: cto
skills:
  - code-review
  - paperclip
---

You are a software engineer at Lean Dev Shop. You write code, fix bugs, and ship features.

Your responsibilities:

- Implement features and fix bugs
- Write tests and documentation
- Participate in code reviews
```

## teams/engineering/TEAM.md

```markdown
---
name: Engineering
description: Product and platform engineering team
slug: engineering
schema: agentcompanies/v1
manager: ../../agents/cto/AGENTS.md
includes:
  - ../../agents/engineer/AGENTS.md
  - ../../skills/code-review/SKILL.md
tags:
  - engineering
---

The engineering team builds and maintains all software products.
```

## projects/q2-launch/PROJECT.md

```markdown
---
name: Q2 Launch
description: Ship the Q2 product launch
slug: q2-launch
owner: cto
---

Deliver all features planned for the Q2 launch, including the new dashboard and API improvements.
```

## projects/q2-launch/tasks/01-kickoff-meeting/TASK.md

```markdown
---
name: Kickoff Meeting
assignee: cto
project: q2-launch
priority: critical
---

Schedule and run the Q2 launch kickoff meeting. Define goals, assign workstreams, and align the team on milestones.
```

## projects/q2-launch/tasks/02-monday-review/TASK.md

```markdown
---
name: Monday Review
assignee: ceo
project: q2-launch
priority: high
schedule:
  timezone: America/Chicago
  startsAt: 2026-03-16T09:00:00-05:00
  recurrence:
    frequency: weekly
    interval: 1
    weekdays:
      - monday
    time:
      hour: 9
      minute: 0
---

Review the status of Q2 Launch project. Check progress on all open tasks, identify blockers, and update priorities for the week.
```

## projects/q2-launch/tasks/03-weekly-standup/TASK.md

```markdown
---
name: Weekly Standup
assignee: ceo
project: q2-launch
priority: low
recurring: true
---

Run a weekly standup meeting. Each agent reports progress, blockers, and plans for the week.
```

Note how task numbering is globally unique across the entire company. Also note that the recurring task lives inside a project — recurring tasks become Routines and always require a project.

## skills/code-review/SKILL.md (with external reference)

```markdown
---
name: code-review
description: Thorough code review skill for pull requests and diffs
metadata:
  sources:
    - kind: github-file
      repo: anthropics/claude-code
      path: skills/code-review/SKILL.md
      commit: abc123def456
      sha256: 3b7e...9a
      attribution: Anthropic
      license: MIT
      usage: referenced
---

Review code changes for correctness, style, and potential issues.
```
