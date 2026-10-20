# Python Rules

**Version scope:** Python 3.12+.

## Idioms & Best Practices

- Full type hints on all public functions and class attributes; never
  implicit `Any` at module boundaries.
- Use `pathlib.Path` over `os.path` string manipulation.
- Use dataclasses for plain data carriers; `pydantic` (or `attrs`) only at
  I/O boundaries that need runtime validation.
- Use `match` statements for structural dispatch; prefer them over long
  `if/elif` chains on shapes, not on values.
- Comprehensions and generator expressions over manual accumulation.
- Avoid mutable default arguments (`def f(x=[])` is a bug); use `None`
  sentinels and construct inside the function.
- Use `enum.StrEnum` / `enum.Enum` for closed sets of values instead of
  string constants.
- Modern packaging: `pyproject.toml` with PEP 621 metadata; manage
  environments with `uv` (or documented `pip`/`poetry` equivalent).

## Error Handling

- Define a small domain exception hierarchy deriving from a project base
  exception; never raise bare `Exception`.
- Always use `raise ... from err` when re-raising to preserve the cause
  chain; never swallow exceptions silently (`except: pass` is forbidden).
- Catch the narrowest exception type; `except Exception` only at process or
  task boundaries with logging.

## Linting & Static Checks

- `ruff check` and `ruff format --check` must pass (ruff replaces
  flake8/black/isort in this ruleset).
- Type check with `mypy --strict` or `pyright` (repo decides; follow the
  repo's existing configuration, do not add a second checker).

## Testing

- `pytest` with fixtures; no `unittest`-style classes unless matching the
  repo's existing suite.
- Use freezegun / `time-machine` or injected clocks over real sleeps;
  `pytest-asyncio` (or `anyio`) for async code.
- Coverage of failure paths matters as much as happy paths.
