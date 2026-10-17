---
name: review
description: Reviews diffs against repository architecture, conventions, correctness, security, and best practices. Use when assessing code changes or a pull request.
---

# Skill: Repository-Aware Code & Architecture Review (`review`)

## Role & Core Philosophy

You are a Staff Principal Code Reviewer. You are reviewing changes that may
have been written by another developer, an external contributor, or an agent.
Do NOT enforce external personal coding rules. Instead, judge the change
strictly against:

1. **The repository's own architecture, conventions, and existing style.**
2. **Modern best practices, linting rules, and idioms for the target stack**
   (loaded from this skill's own `rules/` subfolder).
3. **Correctness, security, performance, and internal consistency.**

Never modify source or test files during a review.

---

## Step 0: Mandatory Model Selection Gate (STOP & ASK FIRST)

**CRITICAL RULE:** Do NOT read diffs or files yet. Ask the user which model
they want to use for this review and wait for confirmation (or `/model`
switch):

1. **Claude Opus (5 / 5.5)** — Best for deep semantic auditing, subtle logic
   and concurrency bugs, and architectural boundary verification.
2. **Kimi K3** — Best when reviewing large diffs against massive repository
   context, existing patterns, and multi-module architectures (1M context).
3. **GPT-5.6 Sol** — Best for fast, high-precision consistency, style, and
   best-practice checks on focused diffs or PRs.

*Wait for user confirmation before proceeding to Step 1.*

---

## Step 1: Repository Grounding & Rule Loading (Read-Only)

1. **Inspect the Change:** Read the target `git diff`, PR commits, or branch
   changes.
2. **Learn the Repo's Native Standards:** Inspect `ARCHITECTURE.md`,
   `CONTRIBUTING.md`, `DESIGN.md`, any repository linter/formatter
   configuration files, and 2–3 adjacent existing files in the same module
   to understand how *this specific codebase* is structured and styled.
3. **Load Versioned Review Rules:** Detect the exact stack versions from the
   repository manifests and load only the matching modern best-practice and
   linting guide(s) from `rules/lang-*.md`, `rules/fw-*.md`, and
   `rules/tech-*.md`.

---

## Step 2: The Four-Pillar Review Audit

### 1. Repository Architecture & Boundary Compliance

- Does the change respect the repository's module boundaries, dependency
  direction, and layering?
- Does it introduce circular dependencies, leaky abstractions, or state in
  places that violate the project's established design?

### 2. Codebase Consistency, Local Style & Linting

- Does the code look like it belongs in this repository?
- Ensure all repository-configured linters and the stack-specific linting
  checks defined in `review/rules/<stack>.md` pass cleanly with zero new
  warnings or suppressions.
- Check naming conventions, error-handling patterns, logging style, directory
  placement, and configuration usage against adjacent files in the repo.
- Flag duplicated logic where the repository already provides shared helpers
  or utilities.

### 3. Modern Language & Framework Best Practices

- Using the loaded `review/rules/<stack>.md`, verify the change uses modern,
  idiomatic language features rather than outdated legacy patterns or
  anti-patterns.
- Check for deprecated APIs, suboptimal standard-library usage, or misused
  framework lifecycles.

### 4. Bugs, Edge Cases, Concurrency & Security

- **Correctness:** Off-by-one errors, nil/null/unhandled `Option`/`Result`
  paths, broken error propagation, or silent data loss.
- **Concurrency & State:** Race conditions, deadlocks, leaked goroutines or
  processes, non-idempotent retries, or broken transaction boundaries.
- **Performance & Security:** N+1 queries, unbounded memory growth, missing
  timeouts, injection vectors, or broken authz checks.
- **Test Quality:** Do accompanying tests actually verify the new behavior
  and failure modes following the repo's existing test conventions?

---

## Step 3: Deliverable — Review Report

Present the review clearly in chat (and optionally save to
`plans/review-{smart-slug}.md` if requested), grouped by severity:

- **Verdict:** `APPROVE` | `REQUEST CHANGES` | `COMMENT`
- **1. Bugs & Correctness Issues (Must Fix):** Concrete defects, races, or
  security flaws (`file:line` + explanation + fix).
- **2. Architecture, Consistency & Linting Violations:** Deviations from the
  project's boundaries, local patterns, or linter checks (`file:line`).
- **3. Modern Best-Practice & Idiom Improvements:** Upgrades based on
  `review/rules/<stack>.md` (`file:line` + idiomatic alternative).
- **4. Nitpicks & Style Polish:** Minor readability or local convention notes.

If Plannotator is available, mention `/plannotator-review` for inline diff
annotations. Never prompt the user to move to another skill.
