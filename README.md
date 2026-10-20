# Titaniumcoder Skills

Portable, lifecycle-phased Agent Skills for compatible coding agents. Each
skill follows the [Agent Skills specification](https://agentskills.io/specification)
and lives in its own directory under `skills/`.

The skills are the **source of truth**. Prompt adapters under `adapters/`
wrap them as explicit slash commands / custom agents for pi, Claude Code,
and GitHub Copilot; `install.sh` deploys everything on a new machine.

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

## Prompt adapters (recommended)

These workflows are deliberate, gated pipelines (scouting → planning →
testing-stubs → implementation → review) rather than reactive capabilities,
so they work best when **you** invoke them explicitly as commands instead of
letting the model auto-trigger them as skills. Thin adapters (4 lines each)
exist for all three command mechanisms:

| Command | pi | Claude Code | GitHub Copilot |
| --- | --- | --- | --- |
| Scouting | `/scout` | `/scout` | `plan`-style custom agent |
| Planning | `/plan` | `/plan` | custom agent `plan` |
| Test stubs | `/stubs` | `/stubs` | custom agent `stubs` |
| Implementation | `/implement` | `/implement` | custom agent `implement` |
| Review | `/review` | `/review` | custom agent `review` |

Every adapter is a wrapper that tells the agent to read and follow the
`SKILL.md` in the stable clone, so the workflow logic exists in exactly one
place. Copilot custom agents (`.agent.md`) are personas you switch to in the
Copilot app/CLI (`/agent`) rather than argument-taking commands.

### Model selection

All three support pinning a model in the adapter's frontmatter:

- **pi** (with [`pi-prompt-template-model`](https://www.npmjs.com/package/pi-prompt-template-model)):
  `model: claude-opus-4, gpt-5.4` — comma-separated fallback order.
- **Claude Code**: `model: sonnet` | `opus` | `haiku` (default: inherit session).
- **Copilot**: `model: "Claude Sonnet 4"` — display name; an array acts as fallback.

Adapters ship without a `model` key (inherit the session model), which keeps
the skills' Step 0 model-selection gate active. Pin a model to skip that gate.

## Install

### One-command install (prompts, all agents)

On a new machine, clone and run:

```bash
git clone https://github.com/titaniumcoder/titaniumcoder-skills.git
cd titaniumcoder-skills && ./install.sh
```

`install.sh` installs from the checkout you run it in (or clones the GitHub
repo on fresh machines) to the stable path `~/.agents/skills-src`, then
copies `adapters/pi/*.md` → `~/.pi/agent/prompts/`,
`adapters/claude/*.md` → `~/.claude/commands/` (if present), and
`adapters/copilot/*.agent.md` → `~/.copilot/agents/` (if present). Run it
again (or `git pull` + rerun) to update everything at once. Add
`--with-skills` to *also* expose `skills/` as auto-triggering Agent Skills in
`~/.agents/skills`.

### Skills CLI (per-agent, auto-triggering)

Alternatively, use [`skills`](https://github.com/vercel-labs/skills) to install
globally for one harness at a time. Each command installs all skills in the
directory map below:

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

### Project level skills

Omit `--global` for project-local installation. To install selected skills
instead of all of them, replace `'*'` with one or more names from this map:

### Available skill names

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

## Language-specific rules

The `implementation` and `review` skills load versioned best-practice rules
at runtime from their own `rules/` folders (`rules/lang-*.md`,
`rules/fw-*.md`, `rules/tech-*.md`), matched against the target project's
dependency manifest (`Cargo.toml`, `go.mod`, `package.json`, …). This works
identically whether the entry point is a skill or a prompt adapter, because
the agent reads those files itself — the skill/prompt mechanism never loads
them. See `skills/rules-convention.md` for the naming convention and content
contract.

## Pi package

This repository is also a [pi package](https://pi.dev) (`pi-package` keyword
in `package.json`). Installing it as a package exposes the skills
(self-contained, rules included) with auto-triggering enabled:

```bash
pi install git:github.com/titaniumcoder/titaniumcoder-skills@main
```

Use `install.sh` instead if you want the prompt-adapter mode with skill
auto-triggering off.
