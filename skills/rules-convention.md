# Versioned Rules Convention (`rules/`)

The `implementation` and `review` skills reference versioned stack rules that
are loaded **at runtime by the agent itself**, not by any skill/prompt
mechanism. That is what makes this portable: the SKILL.md (or the thin prompt
adapter pointing at it) simply instructs the agent to:

1. Read the target project's dependency manifest (`Cargo.toml`, `go.mod`,
   `mix.exs`, `pom.xml`, `package.json`, `pyproject.toml`, `DESIGN.md`, …) to
   detect the exact languages, frameworks, tools, and versions in use.
2. Load only the matching files below, relative to this skill's own directory.

Because the agent resolves these paths relative to the skill directory —
whether that skill lives in this repository checkout, a pi package install, or
a symlinked Agent Skills directory — the same rules apply identically in
skill mode and prompt-adapter mode, on every machine that ran `install.sh`.

## File naming

| Pattern | Matches | Example |
| --- | --- | --- |
| `rules/lang-<name>.md` | Programming language | `rules/lang-rust.md` |
| `rules/fw-<name>.md` | Framework | `rules/fw-axum.md` |
| `rules/tech-<name>.md` | Other technology/tooling | `rules/tech-postgres.md` |

## Content contract

Each rules file must contain:

1. **Version scope:** Which language/framework/tool versions the guidance
   applies to (e.g. "Rust 1.80+, edition 2024").
2. **Idioms & best practices:** Modern, idiomatic patterns and the legacy or
   deprecated patterns to avoid.
3. **Linting & static checks:** The canonical linters/clippy configs and the
   checks that must pass with zero new warnings.
4. **Error handling & typing conventions:** Patterns the stack considers
   correct for error propagation, optionality, and API boundaries.

## Current status

Rules directories may contain `.gitkeep` placeholders. A skill that fails to
find a matching rules file should say so and fall back to general modern best
practices for the detected stack rather than silently skipping the check.
