# TitaniumCoder Skills

Modular, lifecycle-phased AI agent skills designed for [Pi](https://github.com/badlogic/pi-mono)
and compatible coding agents.

## Core Lifecycle Skills

1. **`scouting`** (`scouting/SKILL.md`) — Scans repository documentation and
   source code to produce `SCOUTING_REPORT.md` (doc health, drift audit, and
   structural health) and `ARCHITECTURE.md`.
2. **`planning`** (`planning/SKILL.md`) — Interactive, zero-assumption
   architectural discovery and phased execution planning into
   `plans/{smart-slug}.md`.
3. **`testing-stubs`** (`testing-stubs/SKILL.md`) — Proposes brutal test
   specifications as target-language test stubs (`Given / When / Then`) without
   touching existing tests or writing assertion bodies.
4. **`implementation`** (`implementation/SKILL.md`) — Splits work into small,
   worktree-ready subagent artifacts with user approval, enforces zero comments
   (except `FIXME` test adapters), pure functions, and precision naming. Loads
   versioned stack rules from `implementation/rules/`.
5. **`review`** (`review/SKILL.md`) — Audits diffs/PRs against the repository's
   own architecture, conventions, linters, and modern stack best practices in
   `review/rules/`.

## Installation for Pi

Symlink or clone into your Pi skills directory:

```bash
ln -s "$(pwd)/scouting" ~/.pi/agent/skills/scouting
ln -s "$(pwd)/planning" ~/.pi/agent/skills/planning
ln -s "$(pwd)/testing-stubs" ~/.pi/agent/skills/testing-stubs
ln -s "$(pwd)/implementation" ~/.pi/agent/skills/implementation
ln -s "$(pwd)/review" ~/.pi/agent/skills/review
```
