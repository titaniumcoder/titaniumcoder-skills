# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project does **not** use semantic versioning for now: everything
accumulates under **[Unreleased]**. If a release cut is ever needed, rename
that heading to a version and date. Changes before 2026-10-20 are only in
the git history.

## [Unreleased]

### Added

- Prompt adapters for pi and Claude Code: thin `/scout`, `/plan`, `/stubs`,
  `/implement`, `/review` slash commands that delegate to the skills in this
  repository as the single source of truth (`adapters/pi/`,
  `adapters/claude/`).
- `install.sh`: deploys the Claude Code command adapters and the stable
  `~/.agents/skills-src` checkout; supports running from a local checkout.
- Pi package manifest (`pi-package` keyword): `pi install git:...` deploys
  the prompt templates without auto-triggering skills; `pi update` keeps
  them current.
- Versioned language rules for the `implementation` and `review` skills:
  compact best-practice, error-handling, linting, and testing gates for
  Rust, Go, Python, TypeScript, and Elixir
  (`skills/implementation/rules/lang-*.md`).
- `npm run sync-rules` (`scripts/sync-rules.mjs`): mirrors canonical rules
  from `implementation/rules/` into `review/rules/` to prevent drift.
- `skills/rules-convention.md`: naming pattern, content contract, and sync
  workflow for the versioned rules.

### Changed

- Scoped support to **pi and Claude Code only**. Codex and OpenCode were
  dropped because they lack a slash-command mechanism (supporting them would
  require always-on auto-triggering skills); GitHub Copilot adapter support
  was removed and can be recovered from git history.
- Skills are no longer installed as auto-triggering Agent Skills anywhere;
  they live in the repository purely as the workflow definitions the
  adapters point at, costing no context until read.
- README rewritten around the adapter mode: deployment routes (pi package,
  `install.sh`), per-agent model-selection guidance (unpinned on pi's
  multi-provider setups; pinnable on Claude Code), and the runtime rules
  loading mechanism.
