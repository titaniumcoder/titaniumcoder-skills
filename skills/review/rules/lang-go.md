# Go Rules

**Version scope:** Go 1.22+ (loop variable semantics, enhanced `for` range).

## Idioms & Best Practices

- Accept interfaces, return concrete types. Define interfaces at the
  consumer side, keep them small (one or two methods).
- Use `context.Context` as the first parameter of any I/O-bound or
  long-running function; never store contexts in structs.
- Check and wrap errors immediately; use `errors.Is` / `errors.As` for
  matching, never string comparison.
- Guard goroutines: every `go` statement must have a clear ownership and
  termination story (`errgroup`, worker pools, done channels).
- Use `sync.Once`, `sync.WaitGroup`, and channels correctly; prefer
  `errgroup.Group` for concurrent fan-out with cancellation.
- Use generics where they remove duplication without obscuring types;
  do not build speculative abstractions.
- Prefer standard library `log/slog` (structured logging) over ad-hoc
  loggers; pass levels and attributes consistently.
- Table-driven tests with `t.Run` and `t.Parallel()` where independent;
  use `t.Context()` (1.24+) for test contexts.

## Error Handling

- Sentinel errors (`errors.New`) for expected conditions; custom error types
  (`type LoadError struct{...}`) when callers need to inspect details.
- Always wrap with `%w` so `errors.Is/As` chains survive boundaries.
- Return `(T, error)`, never a bare value plus `nil` error and a separate
  "ok" flag for failure cases. Libraries must not `panic`; return errors.

## Linting & Static Checks

- `gofmt` / `go vet ./...` must pass.
- `golangci-lint run` must pass with the repository's config; key enabled
  lints: `errcheck`, `govet`, `staticcheck`, `revive`, `ineffassign`.
- No unused variables, no shadowed imports of `error`-like identifiers.

## Testing

- `go test ./... -race -count=1` must pass; race detector is mandatory for
  any code with goroutines.
- Use `testing/synctest` or fake clocks (`clock` injection) rather than
  `time.Sleep` in tests.
