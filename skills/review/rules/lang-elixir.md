# Elixir Rules

**Version scope:** Elixir 1.17+ (gradual set-theoretic types groundwork),
OTP 26+.

## Idioms & Best Practices

- Pattern match in function heads; use multiple function clauses instead of
  `if`/`case` ladders inside bodies.
- Use `with` for pipelines of `{:ok, _} / {:error, _}` returns; keep the
  `else` clauses exhaustive and explicit.
- Prefer `{:ok, value} | {:error, reason}` returns for expected failures;
  reserve `raise`/exceptions for truly exceptional, programmer-error cases.
- Use structs with defaults over plain maps for domain data; keep pattern
  matching on structs for compile-time field checking.
- Keep processes purposeful: a `GenServer` only for actual state or
  serialization needs; pure functions everywhere else. Push side effects
  (I/O, Ecto, HTTP) to module boundaries.
- Avoid complex macros; use functions and `defguard` for reusable guards.
- Start pipelines with a plain value or `|>`-friendly first argument; do not
  pipe into `if`/`case`.
- Configure with `runtime.exs` for environment-dependent values; avoid
  `Application.get_env` scattered through business logic (inject deps).

## Error Handling

- Tagged tuples for expected paths; `Exception`-based errors with
  `defexception` for exceptional paths only.
- Let supervisors own crash semantics (`:temporary` / `:transient`
  children); do not rescue exceptions to "handle" them inside `GenServer`s.
- Use `{:exit, reason}`/`{:shutdown, reason}` semantics correctly in
  supervision trees.

## Linting & Static Checks

- `mix format --check-formatted` must pass (formatting is non-negotiable).
- `mix credo --strict` must pass; treat new Credo issues as review findings.
- `mix dialyzer` must pass where the repo maintains a PLT; annotate new
  public functions with `@spec`.
- Compiler warnings must be zero; do not suppress with `@dialyzer :ignore`
  without a documented reason.

## Testing

- ExUnit with `describe`/`test` blocks; `@tag :skip` markers for stubs.
- Async tests by default (`async: true`) with Ecto sandbox or data case;
  no real sleeps — use `Registry`/`Process` synchronization or
  `assert_receive` timeouts.
