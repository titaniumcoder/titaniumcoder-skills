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

Install all five skills globally for the requested agents with
[`skills`](https://github.com/vercel-labs/skills):

```bash
npx skills add titaniumcoder/titaniumcoder-skills \
  --global \
  --skill '*' \
  --agent claude-code \
  --agent codex \
  --agent github-copilot \
  --agent pi \
  --agent opencode
```

The installer creates links in each agent's supported skills directory. Global
installation makes them available across projects. GitHub Copilot skills work
in the Copilot app, Copilot CLI, and supported IDE experiences; the installer
targets GitHub Copilot's personal skills directory.

To install interactively instead, run `npx skills add
titaniumcoder/titaniumcoder-skills` and select the desired agents and skills
when prompted. For project-local installation, omit `--global`.

## Update

Update globally installed skills from their original sources:

```bash
npx skills update --global
```

Check installed skills with `npx skills list --global`. Restart or refresh an
agent if it does not discover newly installed or updated skills immediately.

See the [`skills` CLI documentation](https://github.com/vercel-labs/skills)
for additional installation options and the [GitHub Copilot agent skills
documentation](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
for Copilot-specific details.
