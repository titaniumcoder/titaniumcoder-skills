# titaniumcoder-skills — Agent Rules

## Project identity

This repository holds titaniumcoder's personal Agent Skills collection. Skills must remain tool-agnostic: a skill is a directory with a `SKILL.md` following the Agent Skills specification <https://agentskills.io/specification>. Do not add Pi-specific package manifests or tool-specific commands inside skill bodies.

## Agent responsibilities

- One skill per directory under `skills/`; the directory name must match the frontmatter `name`.
- Frontmatter must include a `name` (lowercase/hyphens, max 64 chars) and a `description` (max 1024 chars) that states both what the skill does and when to use it.
- Reference bundled files with relative paths (`references/`, `scripts/`, `assets/`).
- Run `npm run validate && npm test && npm run lint` before committing.
- Commit repository changes with concise, descriptive messages.
