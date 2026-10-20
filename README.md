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

All three support pinning a model in the adapter's frontmatter — but pinning
only makes sense where the provider is fixed:

- **Claude Code**: `model: sonnet` | `opus` | `haiku` — safe to pin; the
  provider is always Anthropic.
- **Copilot**: `model: "Claude Sonnet 4"` — display name; safe to pin; the
  provider is the GitHub models subscription. An array acts as fallback.
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

No. The skill files under `skills/` are the **single source of truth** the
adapters point at — they only cost context when installed as auto-triggering
Agent Skills, which you should not do when using the adapters. Install them
as skills only for agents without a command mechanism (e.g. Codex,
OpenCode), via the skills CLI below.

## Install

### One-command install (Claude Code + Copilot)

On a new machine, clone and run:

```bash
git clone https://github.com/titaniumcoder/titaniumcoder-skills.git
cd titaniumcoder-skills && ./install.sh
```

`install.sh` installs from the checkout you run it in (or clones the GitHub
repo on fresh machines) to the stable path `~/.agents/skills-src`, then
copies `adapters/claude/*.md` → `~/.claude/commands/` (if `~/.claude` exists)
and `adapters/copilot/*.agent.md` → `~/.copilot/agents/` (if `~/.copilot`
exists). Run it again (or `git pull` + rerun) to update everything at once.
Add `--with-skills` to *also* expose `skills/` as auto-triggering Agent
Skills in `~/.agents/skills` (not recommended — adapters are preferred).

### Skills CLI (only for agents without a command mechanism)

Use [`skills`](https://github.com/vercel-labs/skills) to install
auto-triggering Agent Skills for harnesses like Codex or OpenCode. Each
command installs all skills in the directory map below:

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

### Pi (recommended: pi package, no install.sh)

The repository is a [pi package](https://pi.dev) (`pi-package` keyword in
`package.json`) exposing only the prompt templates:

```bash
pi install git:github.com/titaniumcoder/titaniumcoder-skills@main
```

This deploys `/scout` `/plan` `/stubs` `/implement` `/review` as prompt
templates **without** auto-triggering skills, and the adapters resolve
`skills/<name>/SKILL.md` (and its versioned `rules/`) from the installed
package at `~/.pi/agent/git/github.com/titaniumcoder/titaniumcoder-skills/`.
Updates are `pi update` (reconciles the pinned git ref) — no `install.sh`, no
separate clone needed on pi-only machines.
