# titaniumcoder-skills

Personal collection of [Agent Skills](https://agentskills.io/specification) — portable `SKILL.md` directories usable by any spec-compliant agent tool (Pi, Claude Code, and others). No package format, no Pi-specific coupling.

## Layout

```text
skills/
├── hello/           # Dummy skill to verify the setup works
└── <skill-name>/    # One directory per skill, each with SKILL.md
```

## Writing a skill

1. Create `skills/<name>/SKILL.md` (directory name must match the frontmatter `name`).
2. Frontmatter needs `name` (lowercase/hyphens, max 64 chars) and `description` (max 1024 chars; state **what it does** and **when to use it** — that is what routes the model).
3. Bundle supporting files next to `SKILL.md` (`references/`, `scripts/`, `assets/`) and reference them with relative paths.
4. Keep frontmatter values single-line and unquoted — the validator parses frontmatter with a simple line parser, not full YAML (intentional, zero-dependency). Quoted scalars, multi-line values, and inline comments are not interpreted.
5. Keep bodies tool-agnostic: only spec frontmatter fields, no tool-specific commands like `/skill:name`.

## Checks

| Command | What it does |
|---|---|
| `npm run validate` | Validates all skills against the Agent Skills spec (frontmatter, name rules, uniqueness, length limits) |
| `npm test` | Runs the validator's test suite (node:test, zero dependencies) |
| `npm run lint` | Markdown linting via markdownlint-cli2 (fetched through npx) |

All three run in CI (`.github/workflows/ci.yml`) on push and pull requests.

## Installing into a tool

Clone anywhere, then either symlink the repo root or individual skill directories into the spec discovery location:

```bash
mkdir -p ~/.agents/skills
ln -s /path/to/titaniumcoder-skills/skills/hello ~/.agents/skills/hello
```

Or, Pi-specific: add `"skills": ["/path/to/titaniumcoder-skills/skills"]` to `settings.json`.

## Adding a skill — agent checklist

1. Create the directory and `SKILL.md` with valid frontmatter.
2. Run `npm run validate && npm test && npm run lint`.
3. Commit with a concise message.
