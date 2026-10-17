---
name: scouting
description: Surveys a repository's documentation and code to produce a scouting report and architecture document. Use when assessing a codebase before planning or onboarding.
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
