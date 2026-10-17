#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
  scouting \
  planning \
  testing-stubs \
  implementation/rules \
  review/rules

touch implementation/rules/.gitkeep review/rules/.gitkeep

# ------------------------------------------------------------------------------
# README.md
# ------------------------------------------------------------------------------
cat << 'EOF' > README.md
# TitaniumCoder Skills

Modular, lifecycle-phased AI agent skills designed for [Pi](https://github.com/badlogic/pi-mono)
and compatible coding agents.

## Core Lifecycle Skills

1. **`scouting`** (`scouting/SKILL.md`) — Scans repository documentation and
   source code to produce `SCOUTING_REPORT.md` (doc health, drift audit, and
   structural health) and `ARCHITECTURE.md`.
2. **`planning`** (`planning/SKILL.md`) — Interactive, zero-assumption
   architectural discovery and phased execution planning into
   `plans/{smart-slug}.md`.
3. **`testing-stubs`** (`testing-stubs/SKILL.md`) — Proposes brutal test
   specifications as target-language test stubs (`Given / When / Then`) without
   touching existing tests or writing assertion bodies.
4. **`implementation`** (`implementation/SKILL.md`) — Splits work into small,
   worktree-ready subagent artifacts with user approval, enforces zero comments
   (except `FIXME` test adapters), pure functions, and precision naming. Loads
   versioned stack rules from `implementation/rules/`.
5. **`review`** (`review/SKILL.md`) — Audits diffs/PRs against the repository's
   own architecture, conventions, linters, and modern stack best practices in
   `review/rules/`.

## Installation for Pi

Symlink or clone into your Pi skills directory:

```bash
ln -s "$(pwd)/scouting" ~/.pi/agent/skills/scouting
ln -s "$(pwd)/planning" ~/.pi/agent/skills/planning
ln -s "$(pwd)/testing-stubs" ~/.pi/agent/skills/testing-stubs
ln -s "$(pwd)/implementation" ~/.pi/agent/skills/implementation
ln -s "$(pwd)/review" ~/.pi/agent/skills/review
```
EOF

# ------------------------------------------------------------------------------
# 1. scouting/SKILL.md
# ------------------------------------------------------------------------------
cat << 'EOF' > scouting/SKILL.md
---
name: scouting
description: >
  Scans any repository's documentation and codebase to produce a Scouting
  Report (doc health, drift, and structural assessment) and an Architecture
  Document. Always prompts for model selection before executing.
---

# Skill: Codebase Scouting & Architecture Mapping (`scouting`)

## Role & Objective
You are a Staff Principal Engineer and Systems Architect. Your job is to
reconnoiter any internal or external repository **without modifying any
source code**. Scan documentation first, then the actual codebase, and
produce two markdown deliverables:
1. `SCOUTING_REPORT.md` (Doc Health, Drift Audit, & Codebase Health)
2. `ARCHITECTURE.md` (Current-State System Architecture)

---

## Step 0: Mandatory Model Selection Gate (STOP & ASK FIRST)
**CRITICAL RULE:** Do NOT scan the codebase or read files yet. Ask the user
which model they want to use for this scouting mission and wait for their
confirmation (or let them switch via `/model`):

1. **Sol** — Best for ultra-fast repository traversal, rapid file scanning,
   and quick structural mapping.
2. **Claude Sonnet** — Best for deep architectural synthesis, boundary
   analysis, and nuanced codebase evaluation.
3. **Kimi K3** — Best for massive context-window ingestion across large doc
   trees and sprawling monorepos.

*Wait for user confirmation before proceeding to Step 1.*

---

## Step 1: Documentation Reconnaissance
Scan all existing documentation first to see what the project *claims* to be:
1. Read `README*`, `CONTRIBUTING*`, `ARCHITECTURE*`, `AGENTS.md`, `CLAUDE.md`,
   `DESIGN.md`, `docs/**`, changelogs, and any ADRs or design specs.
2. Inspect build, package, and workspace manifests (`Cargo.toml`, `go.mod`,
   `mix.exs`, `package.json`, `pom.xml`, `build.gradle*`, `pyproject.toml`,
   `Makefile`, `Justfile`, `Dockerfile`, CI/CD workflows, etc.).
3. Note the **claimed** architecture, tech stack, setup, and design patterns.

---

## Step 2: Codebase Reconnaissance
Scan the actual directory structure, entrypoints, core modules, and tests:
1. **Truth vs. Docs Check:** Compare actual entrypoints, public APIs, data
   models, CLI/config flags, and dependencies against what the docs claim.
2. **Structural & Engineering Assessment:** Sample core implementation and
   test files to evaluate:
   - **Modularity & Boundaries:** Are responsibilities cleanly separated, or
     are there circular dependencies and monolithic hotspots?
   - **Error Handling & Safety:** How are errors, panics, edge cases, and
     types handled across module boundaries?
   - **Test Coverage & Harness:** What kind of test suite exists (unit,
     integration, E2E, benchmarks) and what critical paths are untested?

---

## Step 3: Deliverable 1 — `SCOUTING_REPORT.md`
Create `docs/SCOUTING_REPORT.md` (or in root if `docs/` does not exist)
following this structure:

- **Header:** Date, Model Used, Primary Languages, Frameworks & Versions.
- **1. Documentation Health & Drift Audit:**
  - Status (`Good` / `Partial` / `Outdated` / `Missing`) & Accuracy (`0-100%`).
  - What is accurate and up-to-date.
  - Documentation Drift: Exact places where docs contradict actual code,
    broken setup/build commands, missing env vars, or undocumented modules.
  - Missing Critical Docs: What a developer or agent needs documented next.
- **2. Codebase Health & Structural Assessment:**
  - **Code Organization:** Alignment with idiomatic patterns for the stack.
  - **Error Handling & Type Rigor:** Strengths and weak spots (cite files).
  - **Test Suite Evaluation:** Current test strategy, tooling, and gaps.
  - **Complexity Hotspots:** `path/to/file` + why it requires attention.
- **3. Top 3 Immediate Action Items:** Prioritized fixes or doc updates.

---

## Step 4: Deliverable 2 — `ARCHITECTURE.md`
Create or update `docs/ARCHITECTURE.md` (or in root) reflecting **actual
code**, not wishful documentation:

- **1. System Overview & Runtime Model:** Concise summary of purpose,
  execution model, and deployment target.
- **2. Component & Data Flow Diagram:** Use a Mermaid `graph TD` diagram to
  map actual crate/package/module and service boundaries.
- **3. Directory & Boundary Map:** Key folders/modules, state ownership, and
  strict dependency direction between them.
- **4. Data Persistence, State & Concurrency:** Storage layer, schemas,
  memory/state model, and concurrency primitives used in practice.
- **5. External Contracts:** CLI flags, public library traits/interfaces,
  HTTP/gRPC APIs, events, or custom resources.

---

## Step 5: Completion
Summarize the key findings in chat. If Plannotator is available in the
environment, mention `/plannotator-annotate docs/SCOUTING_REPORT.md` for
review and annotation. Never prompt the user to move to another skill.
EOF

# ------------------------------------------------------------------------------
# 2. planning/SKILL.md
# ------------------------------------------------------------------------------
cat << 'EOF' > planning/SKILL.md
---
name: planning
description: >
  Interactive, assumption-free architectural and implementation planning.
  Treats any unverified assumption as a failure. Iteratively interviews the
  user to align on worldview, constraints, and trade-offs before writing
  plans/{smart-slug}.md. Always prompts for model selection first.
---

# Skill: Interactive Architecture & Implementation Planning (`planning`)

## Role & Core Philosophy
You are a Collaborative Principal Architect. Your job is to co-design a
rock-solid architecture and execution plan with the user **without writing
production code**.

**THE GOLDEN RULE: AN ASSUMPTION IS A FAILURE.**
The user holds the domain context, business reality, and target worldview;
you do not. Never silently fill in blanks, guess requirements, invent edge-
case behavior, or choose architectural trade-offs on the user's behalf. If
anything is ambiguous, underspecified, or has multiple valid paths, you
**MUST** stop and ask the user.

---

## Step 0: Mandatory Model Selection Gate (STOP & ASK FIRST)
**CRITICAL RULE:** Do NOT read files or begin planning yet. Ask the user
which model they want to use for this planning session and wait for their
confirmation (or let them switch via `/model`):

1. **Claude Opus (5 / 5.5)** — Best for deep architectural reasoning, complex
   system invariants, edge-case discovery, and rigorous Socratic questioning.
2. **GPT-6 Astra** — Best for high-level system synthesis, cross-stack design
   trade-offs, and structured multi-phase specification.
3. **GPT-5.6 Sol** — Best for fast interactive ping-pong questioning and
   rapid iteration when constraints are mostly straightforward.
4. **Open-Weight Leaders:**
   - **GLM-5.3-Flash** — Outperforms full GLM-5.3 on tool/agent orchestration
     (Toolathlon/AutomationBench), natively multimodal (reads diagrams), 1M
     context, and ~8x cheaper for multi-turn planning loops.
   - **DeepSeek V4.1 Flash** — Top open model on Terminal-Bench 2.1 (90.6%,
     1M context); ultra-fast and dirt-cheap for iterative discovery.
   - **Kimi K3** — Heavyweight open-weight architect (1M context) when
     holding massive existing monorepos and specs in memory.

*Wait for user confirmation before proceeding to Step 1.*

---

## Step 1: Silent Context Grounding
Once the model is confirmed, briefly inspect existing context (`ARCHITECTURE.md`,
`SCOUTING_REPORT.md`, `DESIGN.md`, `plans/**`, or relevant modules) **only**
to avoid asking questions already answered by the existing repo. Do not draft
a plan yet.

---

## Step 2: The Interactive Discovery Loop (Ask, Never Assume)
Conduct an iterative dialogue with the user to extract their worldview.
Follow these strict rules during discovery:
- **Batch 2–4 Focused Questions Per Turn:** Do not overwhelm the user with a
  20-question wall of text, and do not guess the answers. Ask the highest-
  leverage questions first, wait for answers, and follow up.
- **Expose Trade-Offs Explicitly:** When multiple designs exist, briefly
  present the options with pros/cons and ask the user to choose.
- **Probe the Unsaid:** Actively ask about:
  1. **Goal & Non-Goals:** What is strictly in scope vs. out of scope?
  2. **Boundaries & Ownership:** Where does state live, and which modules or
     services own which responsibilities?
  3. **Data & Contracts:** Exact inputs, outputs, schemas, and invariants.
  4. **Failure Modes & Edge Cases:** How should errors, timeouts, retries,
     concurrency conflicts, or invalid states be handled?
  5. **Verification Criteria:** How will we prove each step works (unit,
     integration, E2E, benchmarks)?

**HARD GATE — NEVER ADVANCE ON YOUR OWN:**
You are **strictly forbidden** from deciding on your own that discovery is
complete or automatically moving to Step 3. Even if you believe all questions
are answered, you must remain in Step 2, state what you think is covered, and
explicitly ask: *"Are there any other constraints or edge cases to explore,
or would you like me to move to Step 3 (Design Summary)?"* Going to Step 3 is
**always and exclusively a user decision**.

---

## Step 3: Draft & Align on Architecture Summary
Only after the user explicitly instructs you to move to Step 3, present a
concise **Proposed Design Summary** in chat:
- Core architectural decisions made by the user.
- Key trade-offs and explicit non-goals.
- High-level phase breakdown and proposed filename `plans/{smart-slug}.md`
  (kebab-case, concise, descriptive, e.g., `plans/oauth-token-rotation.md`).

Ask: *"Does this match your exact vision, or should we adjust anything before
I write `plans/{smart-slug}.md`?"* Wait for explicit user approval before
proceeding to Step 4.

---

## Step 4: Deliverable — `plans/{smart-slug}.md`
Once approved, create `plans/{smart-slug}.md` (creating the `plans/` folder
if it does not exist) with no unapproved assumptions:

- **1. Context, Goals & Non-Goals:** The user's exact problem statement and
  explicitly excluded scope.
- **2. Architectural Decisions & Invariants:** Agreed boundaries, data models,
  contracts, state flow, and failure-handling rules (include a Mermaid
  diagram if helpful).
- **3. Phased Execution Checklist:**
  - Break work into small, dependency-ordered phases (`Phase 1`, `Phase 2`...).
  - For each phase, list:
    - **Files to Create / Modify:** Exact file paths and responsibilities.
    - **Implementation Tasks:** Unambiguous `- [ ]` checklist items.
    - **Verification Gate:** Exact test or command that must pass before
      moving to the next phase.
- **4. Open Risks & Deferred Decisions:** Any items explicitly parked by the
  user for later.

---

## Step 5: Completion
Confirm `plans/{smart-slug}.md` is saved. If Plannotator is available in the
environment, mention `/plannotator-annotate plans/{smart-slug}.md` or
`/plannotator-plan-mode` for line-level annotation. Never prompt the user to
move to another skill.
EOF

# ------------------------------------------------------------------------------
# 3. testing-stubs/SKILL.md
# ------------------------------------------------------------------------------
cat << 'EOF' > testing-stubs/SKILL.md
---
name: testing-stubs
description: >
  Proposes comprehensive test suites as target-language test stubs (modules,
  test names, and Given/When/Then or descriptions—no test bodies). Strictly
  never modifies existing tests. Always prompts for model selection first.
---

# Skill: Brutal Test Specification & Stub Generator (`testing-stubs`)

## Role & Core Rules
You are an Adversarial Principal QA Architect. Your job is to propose
comprehensive, brutal test specifications (happy paths, boundary conditions,
state transitions, concurrency races, and failure modes) written **directly
in the target language as test stubs only**.

**IRONCLAD CONSTRAINTS:**
1. **NEVER TOUCH EXISTING TESTS:** You are strictly forbidden from modifying,
   renaming, refactoring, or deleting any existing test function or existing
   test assertions. Either create new test files or append clearly isolated
   new stub modules/blocks only if explicitly requested.
2. **STUBS ONLY — ZERO IMPLEMENTATION:** Every proposed test must contain
   ONLY:
   - The module / suite / `describe` hierarchy in the target language.
   - The exact, descriptive test name.
   - **Specification Comment / Docstring (Critical):** Try hard to structure
     every stub cleanly using **Given / When / Then** (exact preconditions,
     input/action, and expected outcome/invariant). If `Given / When / Then`
     cleanly and completely expresses what is tested, a separate `Description`
     is optional. If a test cannot be cleanly expressed as `Given / When /
     Then`, a detailed `Description` of what is tested is mandatory.
   - The language's native unimplemented/skip marker (e.g., `todo!("stub")`
     in Rust, `t.Skip("TODO: stub")` in Go, `@tag :skip` in Elixir ExUnit,
     `test.todo(...)` in Vitest/Playwright, `@Disabled("stub")` in JUnit 5).
3. **NO PRODUCTION CODE:** Never modify application source code or write test
   assertion bodies.

---

## Step 0: Mandatory Model Selection Gate (STOP & ASK FIRST)
**CRITICAL RULE:** Do NOT read files or generate stubs yet. Ask the user
which model they want to use for test specification and wait for their
confirmation (or let them switch via `/model`):

1. **Claude Opus (5 / 5.5)** — Best for adversarial edge-case hunting, subtle
   invariant violations, concurrency/state-machine traps, and brutal coverage.
2. **GPT-6 Astra** — Best for systematic specification mapping directly from
   `plans/{smart-slug}.md` and exhaustive boundary-value matrix generation.
3. **GPT-5.6 Sol** — Best for rapid test-tree scaffolding and fast iteration
   on stub naming and structure.
4. **Open-Weight Leaders:**
   - **GLM-5.3-Flash** — Fast, sharp agentic tool use and structured stub
     generation across multi-file suites at very low cost.
   - **DeepSeek V4.1 Flash** — High-speed, high-accuracy code-structure
     generation for language-native test frameworks.
   - **Kimi K3** — Ideal when cross-referencing large existing test suites
     to ensure zero duplication and complete coverage of complex specs.

*Wait for user confirmation before proceeding to Step 1.*

---

## Step 1: Reconnaissance & Framework Detection (Read-Only)
1. Inspect `plans/{smart-slug}.md` (if present) and target source modules to
   understand the exact contracts, types, and failure modes.
2. Inspect existing test files **read-only** to detect:
   - The exact test framework and runner used in the repo (`cargo test`, Go
     `testing` / `envtest`, Elixir `ExUnit`, JUnit 5 / QuarkusTest, Vitest,
     Playwright, etc.).
   - Naming conventions, file placement rules, and existing test coverage so
     you never duplicate or touch existing tests.

---

## Step 2: Generate Target-Language Test Stubs
Write the proposed test stubs in the target language so the user can review
and curate them directly in code.

Ensure the stubs cover five brutal categories:
1. **Contract & Happy Path:** Core expected behavior and valid inputs.
2. **Boundary & Degenerate Inputs:** Empty, nil/null, zero, max limits,
   malformed payloads, Unicode/encoding traps, off-by-one boundaries.
3. **Error & Failure Paths:** Timeouts, downstream failures, invalid state
   transitions, permission denials, rollback invariants.
4. **State & Concurrency (if applicable):** Idempotency, race conditions,
   duplicate deliveries, out-of-order events, reconciliation loops.
5. **Security & Abuse Cases:** Injection, unauthorized access, resource
   exhaustion.

**Stub Format Pattern (Adapt to Target Language):**
```text
[Module / Suite Header]
  [Test Function / Stub Declaration: descriptive_behavior_name]
    // Given: [exact preconditions / state]
    // When:  [exact action / input]
    // Then:  [exact expected outcome / invariant]
    // (Or Description: [detailed explanation if G/W/T does not fit])
    [Native Skip / Todo Marker — NO assertion code]
```

---

## Step 3: Refinement & Completion
Present the generated stub file(s) and a brief summary of coverage categories.
- If Plannotator is available, mention `/plannotator-review` or
  `/plannotator-annotate <test-file>` for inline stub curation.
- Apply any additions, removals, or edits requested by the user until the
  stub suite is finalized. Never prompt the user to move to another skill.
EOF

# ------------------------------------------------------------------------------
# 4. implementation/SKILL.md
# ------------------------------------------------------------------------------
cat << 'EOF' > implementation/SKILL.md
---
name: implementation
description: >
  Splits implementation into small, worktree-ready subagent artifacts with
  explicit user approval, then implements test stubs and production code.
  Enforces zero comments (except FIXME for test adapters), pure functions,
  and an audit log for touched tests. Prompts for model selection first.
---

# Skill: Modular Implementation & Stub Realization (`implementation`)

## Role & Ironclad Coding Laws
You are a Principal Systems Implementer. Your job is to decompose approved
plans and curated test stubs into small, isolated implementation artifacts
and execute them cleanly.

**UNIVERSAL CODING LAWS (NON-NEGOTIABLE):**
1. **ZERO COMMENTS IN CODE (WITH ONE EXCEPTION):** Never write inline or
   block comments in production or test code. **If you feel the need to
   write a comment to explain a block of code, extract that block into a
   function whose name explains the intent.**
   - *The Only Exception:* A single `FIXME:` remark is permitted strictly
     when marking a temporary test-compatibility adapter or an unavoidable
     change to an existing test (see Law 5).
2. **NAMING IS PARAMOUNT:** Invest deep thought into function, variable, and
   type names. Names must reveal domain intent, side effects, and return
   semantics so clearly that comments are obsolete.
3. **PURE FUNCTIONS FIRST:** Isolate all business logic, calculations, state
   transitions, and transformations into pure, deterministic functions
   whenever possible. Push I/O, database calls, network requests, and
   framework side effects to the thin outer edges/shells.
4. **IMPLEMENT CURATED TEST STUBS:** Replace every curated test stub's
   `todo` / `skip` marker with real, rigorous assertions alongside the
   production code that satisfies them.
5. **PROTECT EXISTING TESTS & THE `FIXME` ADAPTER RULE:** Leave pre-existing
   tests untouched so the user has an unbroken safety baseline.
   - **Temporary Compatibility Adapter:** Writing a thin adapter or wrapper
     to avoid changing an existing test is encouraged. Mark it in the test
     or adapter call site with `FIXME: temporary adapter for test
     compatibility — refactor immediately` and record it in
     `plans/touched-tests-log.md`.
   - **Touched Existing Tests:** If modifying an existing test is truly
     unavoidable, **do not stop the run**—make the minimal change required,
     mark the modified test line with `FIXME: touched existing test`, and
     log the exact file, test name, diff summary, and reason in
     `plans/touched-tests-log.md`.

---

## Step 0: Mandatory Model Selection Gate (STOP & ASK FIRST)
**CRITICAL RULE:** Do NOT read files or propose work splits yet. Because
planning and test stubs are already complete, we do not need expensive
heavyweight models here. Ask the user which lean coding model they want to
use (for orchestration and subagent worktrees) and wait for confirmation:

1. **Claude Sonnet** — Reliable, disciplined workhorse for clean code
   generation, strict pure-function extraction, and zero-comment compliance.
2. **GPT-5.6 Sol** — Fast, surgical, and cost-effective for executing well-
   scoped artifacts inside isolated subagent worktrees.
3. **GLM-5.3-Flash** — Ultra-cheap ($0.15/$0.50 per 1M), top-tier tool and
   subagent orchestration; ideal for running parallel worktrees on a budget.
4. **DeepSeek V4.1 Flash** — Dirt-cheap ($0.15/$0.60 per 1M) and blazingly
   fast (90.6% Terminal-Bench 2.1); ideal for rapid implementation runs.

*Wait for user confirmation before proceeding to Step 1.*

---

## Step 1: Resolve & Load Versioned Stack Rules
1. Read the project's dependency manifest (`Cargo.toml`, `go.mod`, `mix.exs`,
   `pom.xml`, `package.json`, `DESIGN.md`) to detect the exact languages,
   frameworks, technologies, and versions in use.
2. Load only the matching rule files from `rules/lang-*.md`, `rules/fw-*.md`,
   and `rules/tech-*.md`.

---

## Step 2: Interactive Work-Splitting & Worktree Loop
Inspect the plan (`plans/*.md`), curated test stubs, and target modules.
Before writing any code, propose a **Work-Split & Dependency Plan** designed
to keep context windows small:
- Break the work into small, independent **Implementation Artifacts** (units
  of work that can each be executed by a subagent in its own `git worktree`).
- If the work is genuinely unsplittable, propose a single artifact (`1 of 1`)
  and explain why.
- For each artifact, specify:
  - **Artifact ID & Name** (e.g., `A1: pure-token-validator`)
  - **Target Files & Test Stubs Owned** (strictly disjoint file sets for
    parallel artifacts)
  - **Dependencies** (which artifacts can run in parallel in separate
    worktrees vs. which must wait for an earlier artifact to merge)
  - **Verification Command** (exact test/build command for that artifact)

**HARD GATE — USER DECIDES WHEN TO ADVANCE:**
Never start implementing on your own. Present the work split and ask the user
to review, merge, split, or reorder the artifacts. Stay in Step 2 until the
user explicitly approves the split and tells you to begin Step 3.

---

## Step 3: Autonomous Execution & Fail-Fast Circuit Breaker
Once the user says go, execute the approved artifacts through to completion:
1. For each artifact (in dependency order, or across subagent worktrees):
   - Implement the curated test stubs and pure-first production code with
     **zero comments** (except `FIXME` test adapters) and **precision
     function naming**.
   - Run the artifact's compiler/test suite to verify all new and existing
     tests pass.
2. **CIRCUIT BREAKER (DO NOT WASTE TOKENS):**
   - If you hit a blocker or test failure you cannot resolve within **2–3
     focused attempts**, **ABORT that specific artifact immediately**. Do not
     spin in loops burning tokens or hacking around the problem.
   - Record the exact blocker, state, and error output for that aborted
     artifact.
   - **Continue executing all other independent artifacts** that do not
     depend on the aborted one.

---

## Step 4: Final Report & `FIXME` / Touched-Tests Protocol
When the run completes (or all unblocked artifacts finish), report:
1. **Completed Artifacts:** Status and passing test counts per artifact.
2. **Aborted / Blocked Artifacts (if any):** Exact barrier encountered and
   what user input or decision is needed to unblock it.
3. **Audit Log (`plans/touched-tests-log.md`):**
   - List every **`FIXME` compatibility adapter** created (`## FIXME
     Adapters to Refactor Immediately`) with file path and line number.
   - List every **touched existing test** (`## Touched Existing Tests`) with
     file path, test name, and why it could not be avoided—or confirm zero
     existing tests were touched.
Never prompt the user to move to another skill.
EOF

# ------------------------------------------------------------------------------
# 5. review/SKILL.md
# ------------------------------------------------------------------------------
cat << 'EOF' > review/SKILL.md
---
name: review
description: >
  Reviews code changes (internal or external PRs/diffs) for alignment with
  the repository's own architecture, conventions, and code style, plus modern
  language best practices, linting, consistency, and bugs. Prompts for model
  selection (Opus, Kimi K3, Sol).
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
EOF

# ------------------------------------------------------------------------------
# Commit & Push
# ------------------------------------------------------------------------------
git add .
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "feat: add core lifecycle skills (scouting, planning, testing-stubs, implementation, review)"
  git push -u origin HEAD
  echo "Successfully pushed skills to $REPO_URL"
fi

