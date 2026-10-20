# TypeScript Rules

**Version scope:** TypeScript 5.x, ES2023+ target, modern runtimes
(Node 20+ LTS, Bun, or evergreen browsers per repo).

## Idioms & Best Practices

- `strict: true` (all strict flags) in `tsconfig.json`; no `any` — use
  `unknown` plus narrowing. No `@ts-ignore` / `@ts-expect-error` without a
  one-line justification directly above.
- Model states as discriminated unions with a literal `kind`/`type` tag;
  write exhaustive `switch` with an `assertNever`-style `never` default.
- Prefer `type` unions and `satisfies` over classes for domain modeling;
  use `as const` instead of `enum` (string enums included).
- Mark immutable data and parameters `readonly`; avoid mutation of shared
  structures.
- Validate at every trust boundary (HTTP, env, files, queues) with a schema
  library (`zod` or the repo's existing choice) — parsed, not cast.
- Prefer `async/await` over raw `.then` chains; never mix callbacks and
  promises in the same function; use `AbortSignal` for cancellation.
- ESM modules only (`"type": "module"` or `.mts`) unless the repo predates
  it; keep import specifiers explicit with extensions where required.

## Error Handling

- Throw `Error` subclasses with a `code`/`cause` for exceptional states;
  return typed `Result`-style unions (`{ ok: true, data } | { ok: false,
  error }`) for expected, recoverable outcomes.
- Never swallow rejections; top-level handlers log with structured context,
  not string concatenation.

## Linting & Static Checks

- ESLint (typescript-eslint strict-type-checked) or Biome, per repo config —
  must pass with zero warnings; formatting follows the repo's existing
  formatter (Prettier or Biome), never a new one.
- `tsc --noEmit` must pass in CI-equivalent configuration.

## Testing

- Vitest (or the repo's existing runner) with `test.todo` markers for stubs;
  mock network/time at the boundary, not business logic.
- Cover failure paths: rejected promises, malformed payloads, timeouts.
