# Titaniumcoder Skills

Portable, lifecycle-phased Agent Skills for compatible coding agents. Each
skill follows the [Agent Skills specification](https://agentskills.io/specification)
and lives in its own directory under `skills/`. See
[CHANGELOG.md](CHANGELOG.md) for recent changes.

The skills are the **source of truth**. Prompt adapters under `adapters/`
wrap them as explicit slash commands for pi and Claude Code — the two
supported agents. `install.sh` deploys the Claude Code commands on a new
machine; pi installs the templates directly as a pi package.

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
exist for both supported command mechanisms:

| Command | pi | Claude Code |
| --- | --- | --- |
| Scouting | `/scout` | `/scout` |
| Planning | `/plan` | `/plan` |
| Test stubs | `/stubs` | `/stubs` |
| Implementation | `/implement` | `/implement` |
| Review | `/review` | `/review` |

Every adapter is a thin wrapper that tells the agent to invoke the matching
skill by name (e.g. "invoke the `planning` skill"), so the workflow logic
exists in exactly one place and nothing depends on install paths.

### Model selection

All three support pinning a model in the adapter's frontmatter — but pinning
only makes sense where the provider is fixed:

- **Claude Code**: `model: sonnet` | `opus` | `haiku` — safe to pin; the
  provider is always Anthropic.
- **pi**: `model:` accepts provider-qualified ids (with
  [`pi-prompt-template-model`](https://www.npmjs.com/package/pi-prompt-template-model)),
  but pi is multi-provider by design (OpenRouter on one machine, a Copilot
  subscription on another). A pinned id would be wrong on some machines, so
  pi adapters ship **unpinned** and use instead:
  - the session model you pick with `/model`, or
  - a per-invocation override: `/plan --model=openrouter/anthropic/claude-sonnet-4.5`.

Unpinned adapters also keep the skills' Step 0 model-selection gate active;
add a `model:` line to pin a model and skip that gate.

### Do you need the skills installed at all?

For **pi**, installing the package loads the five skills as real Agent
Skills: only their one-line `name`/`description` frontmatter stays in
context, and the full `SKILL.md` is read on demand — either when you invoke
an adapter command or when a description matches what you are already doing.
The skills are the **single source of truth** the adapters point at.

## Install

### One-command install (Claude Code)

On a new machine (any OS with git-bash/WSL on Windows), clone and run:

```bash
git clone https://github.com/titaniumcoder/titaniumcoder-skills.git
cd titaniumcoder-skills && ./install.sh
```

`install.sh` installs from the checkout you run it in (or clones the GitHub
repo on fresh machines) to the stable path `~/.agents/skills-src`, then
copies `adapters/claude/*.md` → `~/.claude/commands/`. Run it again (or
`git pull` + rerun) to update. `/scout` `/plan` `/stubs` `/implement`
`/review` become available in Claude Code.

### Pi (pi package, no install.sh)

The repository is a [pi package](https://pi.dev) (`pi-package` keyword in
`package.json`) exposing only the prompt templates:

```bash
pi install git:github.com/titaniumcoder/titaniumcoder-skills@main
```

This deploys `/scout` `/plan` `/stubs` `/implement` `/review` as prompt
templates, and the five `skills/` directories as pi Agent Skills. The
adapters resolve skills **by name**, so pi itself injects each skill's
absolute location — the adapters never hardcode install paths, which keeps
them working across user-scope git installs, project-scope (`--local`)
installs, and any pi version. No `install.sh`, no separate clone needed on
pi-only machines.

### Other agents

Codex and OpenCode have no slash-command mechanism, so supporting them would
require auto-triggering skills (always-on context cost) — this collection is
therefore scoped to **pi and Claude Code only**. The `skills/` directories
still follow the [Agent Skills specification](https://agentskills.io/specification),
so the underlying workflows remain portable if that ever changes.

Historically this repository also documented installs for Codex, OpenCode,
and GitHub Copilot; those sections were removed, and the Copilot custom-agent
adapters can be recovered from git history if needed.

The skill names, for reference:

```text
skills/
├── scouting/
├── planning/
├── testing-stubs/
├── implementation/
└── review/
```

## Updating

- **pi**: `pi update` (reconciles the installed git package).
- **Claude Code**: `git pull` in `~/.agents/skills-src`, then rerun
  `install.sh` (or run it from a fresh checkout).

## Language-specific rules

The `implementation` and `review` skills load versioned best-practice rules
at runtime from their own `rules/` folders (`rules/lang-*.md`,
`rules/fw-*.md`, `rules/tech-*.md`), matched against the target project's
dependency manifest (`Cargo.toml`, `go.mod`, `package.json`, …). This works
identically whether the entry point is a skill or a prompt adapter, because
the agent reads those files itself — the skill/prompt mechanism never loads
them. See `skills/rules-convention.md` for the naming convention and content
contract.
