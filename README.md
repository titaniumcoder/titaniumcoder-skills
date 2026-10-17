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

## Install for Pi

Clone this repository once, then symlink each skill into Pi's skill directory:

```bash
git clone https://github.com/titaniumcoder/titaniumcoder-skills.git \
  ~/.local/share/titaniumcoder-skills
mkdir -p ~/.pi/agent/skills
for skill in scouting planning testing-stubs implementation review; do
  ln -s "$HOME/.local/share/titaniumcoder-skills/skills/$skill" \
    "$HOME/.pi/agent/skills/$skill"
done
```

To update the installed skills, pull the latest repository changes; the
symlinks will use the updated files:

```bash
git -C ~/.local/share/titaniumcoder-skills pull --ff-only
```

For other Agent Skills-compatible tools, install or link the individual
directories under `skills/` using that tool's skill-directory convention.
