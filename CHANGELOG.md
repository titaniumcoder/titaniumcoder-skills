# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
except that entries are grouped by **date** instead of version numbers — the
project is not versioned for now. Each heading is the date the changes were
committed; details live in the referenced git commits.

## 2026-10-20

### Added

- Prompt adapters for pi and Claude Code: thin `/scout`, `/plan`, `/stubs`,
  `/implement`, `/review` slash commands that delegate to the skills in this
  repository as the single source of truth (`adapters/pi/`,
  `adapters/claude/`)
  ([401c908](https://github.com/titaniumcoder/titaniumcoder-skills/commit/401c908)).
- `install.sh`: deploys the Claude Code command adapters and the stable
  `~/.agents/skills-src` checkout; supports running from a local checkout
  ([401c908](https://github.com/titaniumcoder/titaniumcoder-skills/commit/401c908)).
- Versioned language rules for the `implementation` and `review` skills:
  compact best-practice, error-handling, linting, and testing gates for
  Rust, Go, Python, TypeScript, and Elixir
  (`skills/implementation/rules/lang-*.md`)
  ([fa4557e](https://github.com/titaniumcoder/titaniumcoder-skills/commit/fa4557e)).
- `npm run sync-rules` (`scripts/sync-rules.mjs`): mirrors canonical rules
  from `implementation/rules/` into `review/rules/` to prevent drift
  ([fa4557e](https://github.com/titaniumcoder/titaniumcoder-skills/commit/fa4557e)).
- `skills/rules-convention.md`: naming pattern, content contract, and sync
  workflow for the versioned rules
  ([fa4557e](https://github.com/titaniumcoder/titaniumcoder-skills/commit/fa4557e)).
- `CHANGELOG.md` (this file)
  ([e592085](https://github.com/titaniumcoder/titaniumcoder-skills/commit/e592085)).

### Changed

- Pi installs via its own package now: `pi install git:...` deploys the
  prompt templates (no auto-triggering skills) and `pi update` keeps them
  current; adapters resolve skills and rules from the installed package path
  ([64d2fc4](https://github.com/titaniumcoder/titaniumcoder-skills/commit/64d2fc4)).
- Scoped support to **pi and Claude Code only**. Codex and OpenCode were
  dropped because they lack a slash-command mechanism (supporting them would
  require always-on auto-triggering skills); GitHub Copilot adapter support
  was removed and can be recovered from git history
  ([7980313](https://github.com/titaniumcoder/titaniumcoder-skills/commit/7980313)).
- Skills are no longer installed as auto-triggering Agent Skills anywhere;
  they live in the repository purely as the workflow definitions the
  adapters point at, costing no context until read
  ([7980313](https://github.com/titaniumcoder/titaniumcoder-skills/commit/7980313)).
- README rewritten around the adapter mode: deployment routes (pi package,
  `install.sh`), per-agent model-selection guidance (unpinned on pi's
  multi-provider setups; pinnable on Claude Code), and the runtime rules
  loading mechanism
  ([401c908](https://github.com/titaniumcoder/titaniumcoder-skills/commit/401c908),
  [64d2fc4](https://github.com/titaniumcoder/titaniumcoder-skills/commit/64d2fc4),
  [7980313](https://github.com/titaniumcoder/titaniumcoder-skills/commit/7980313)).

## 2026-10-17

### Added

- Core lifecycle skills: `scouting`, `planning`, `testing-stubs`,
  `implementation`, `review`
  ([66ca1b0](https://github.com/titaniumcoder/titaniumcoder-skills/commit/66ca1b0)).
- Initial repository scaffold: `hello` skill, skill validator, tests,
  markdown lint, and CI
  ([2af806d](https://github.com/titaniumcoder/titaniumcoder-skills/commit/2af806d)).

### Changed

- Reorganized skills under `skills/<name>/SKILL.md` and documented
  cross-agent installation via the `skills` CLI
  ([e91d771](https://github.com/titaniumcoder/titaniumcoder-skills/commit/e91d771)).
- README: documented setup-only status, `npx skills` install/update
  workflow, and tag-based releases with tag-triggered CI
  ([76c5295](https://github.com/titaniumcoder/titaniumcoder-skills/commit/76c5295)).
- Validator hardening from review: enforce skill `name` == directory name,
  CI Node version matrix, `engines` field, pinned markdownlint version, and
  boundary/CRLF frontmatter tests
  ([0523c09](https://github.com/titaniumcoder/titaniumcoder-skills/commit/0523c09)).
- Aligned `package.json` version with the `v0.0.1` release tag
  ([0c47243](https://github.com/titaniumcoder/titaniumcoder-skills/commit/0c47243)).
- README polish
  ([34fc433](https://github.com/titaniumcoder/titaniumcoder-skills/commit/34fc433)).

### Removed

- Scripts removed from the repository ("script remival")
  ([54ee54c](https://github.com/titaniumcoder/titaniumcoder-skills/commit/54ee54c)).
