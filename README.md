# TitaniumCoder Skills

Portable, lifecycle-phased Agent Skills for compatible coding agents. Each
skill follows the [Agent Skills specification](https://agentskills.io/specification)
and lives in its own directory under `skills/`.

## Skills

- **`scouting`** (`skills/scouting/SKILL.md`) — Surveys repository documentation
  and code, then produces a scouting report and architecture document.
- **`planning`** (`skills/planning/SKILL.md`) — Collaboratively discovers
  requirements and produces a phased implementation plan.
- **`testing-stubs`** (`skills/testing-stubs/SKILL.md`) — Proposes target-language
  test specifications without modifying existing tests or writing assertions.
- **`implementation`** (`skills/implementation/SKILL.md`) — Implements approved,
  scoped work and curated test stubs, following its implementation rules.
- **`review`** (`skills/review/SKILL.md`) — Reviews changes against the target
  repository's conventions, architecture, and quality requirements.

## Install

Use [`skills`](https://github.com/vercel-labs/skills) to install globally for
one harness at a time. Each command installs all skills in the directory map
below:

### Claude Code

```bash
npx skills add titaniumcoder/titaniumcoder-skills --global --agent claude-code --skill '*'
```

To install only `implementation` and `testing-stubs` for Claude Code:

```bash
npx skills add titaniumcoder/titaniumcoder-skills \
  --global \
  --agent claude-code \
  --skill implementation \
  --skill testing-stubs
```

### Codex

```bash
npx skills add titaniumcoder/titaniumcoder-skills --global --agent codex --skill '*'
```

### GitHub Copilot

```bash
npx skills add titaniumcoder/titaniumcoder-skills --global --agent github-copilot --skill '*'
```

This installs to Copilot's personal skills directory, which is used by the
Copilot app as well as Copilot CLI and supported IDE experiences.

### Pi

```bash
npx skills add titaniumcoder/titaniumcoder-skills --global --agent pi --skill '*'
```

### OpenCode

```bash
npx skills add titaniumcoder/titaniumcoder-skills --global --agent opencode --skill '*'
```

Omit `--global` for project-local installation. To install selected skills
instead of all of them, replace `'*'` with one or more names from this map:

```text
skills/
├── scouting/
├── planning/
├── testing-stubs/
├── implementation/
└── review/
```

## Update

Update globally installed skills from their original sources:

```bash
npx skills update --global
```

Check global installations with `npx skills list --global`. For project-local
installations, use `npx skills update --project` and `npx skills list
--project`. Restart or refresh an agent if it does not discover newly installed
or updated skills immediately.

See the [`skills` CLI documentation](https://github.com/vercel-labs/skills)
for additional installation options and the [GitHub Copilot agent skills
documentation](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
for Copilot-specific details.
