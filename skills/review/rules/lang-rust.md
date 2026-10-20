# Rust Rules

**Version scope:** Rust 1.85+ (edition 2024), stable toolchain.

## Idioms & Best Practices

- Prefer borrowing over cloning. `.clone()` requires a comment-worthy reason
  in hot paths; reach for `&T`, `&str`, `&[T]` slices first.
- Use `let-else` for early returns instead of nested `match`:
  `let Some(value) = input else { return Err(...) };`
- Prefer iterators and combinator chains over index loops; reserve `loop` /
  `while` for stateful iteration.
- Generics with trait bounds (`impl Trait`, `T: Trait`) by default; use
  `dyn Trait` only when trait objects are genuinely required.
- Model domain states with enums and newtypes. Make invalid states
  unrepresentable rather than validating at runtime.
- Use `impl Trait` in return position for concrete anonymous types; avoid
  `Box<dyn Error>` in library public APIs.
- Keep `unsafe` blocks minimal, audited, and documented with a SAFETY comment
  (the only comment exemption besides the skills' FIXME adapter rule).
- Edition 2024: use `unsafe extern` blocks where required, and rely on the
  tightened RPIT lifetime capture rules instead of explicit bounds.

## Error Handling

- Libraries: define errors with `thiserror` (`#[derive(Error)]`), implement
  `std::error::Error` properly.
- Applications/binaries: `anyhow::Result` with `.context()` at boundaries.
- Propagate with `?`. Never `.unwrap()` / `.expect()` in non-test code;
  construct a real error or document an invariant with a typed constructor.
- Avoid stringly-typed errors (`String`, `Box<dyn Error>`) inside libraries.

## Linting & Static Checks

- `cargo fmt --check` must pass.
- `cargo clippy --all-targets -- -D warnings` must pass; treat new clippy
  lints as review findings, never `#[allow]` them without justification.
- MSRV must be honored: no method/feature usage newer than the declared
  `rust-version` in `Cargo.toml`.

## Testing

- Unit tests inline under `#[cfg(test)] mod tests`; integration tests in
  `tests/`.
- Table-driven cases with `rstest` or plain loops; property tests with
  `proptest` for parsers and serialization boundaries.
- Doctests are tests: `///` examples must compile and stay current.
