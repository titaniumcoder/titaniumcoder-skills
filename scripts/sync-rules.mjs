#!/usr/bin/env node
// Mirrors the canonical rules files from skills/implementation/rules/ into
// skills/review/rules/ so both skills share one source of truth without
// symlinks (which would break single-skill installs via `npx skills add`).
// Exit code 1 on any error.

import { copyFileSync, mkdirSync, readdirSync, rmSync, statSync } from "node:fs";
import { join } from "node:path";

const ROOT = join(import.meta.dirname, "..");
const SRC = join(ROOT, "skills", "implementation", "rules");
const DEST = join(ROOT, "skills", "review", "rules");

for (const dir of [SRC, DEST]) {
  if (!statSync(dir).isDirectory()) {
    console.error(`Missing rules directory: ${dir}`);
    process.exit(1);
  }
}

const canonical = readdirSync(SRC).filter((f) => f.endsWith(".md"));
mkdirSync(DEST, { recursive: true });

for (const file of canonical) {
  copyFileSync(join(SRC, file), join(DEST, file));
  console.log(`synced: review/rules/${file}`);
}

// Remove stale mirrored files that no longer exist in the canonical set.
const stale = readdirSync(DEST).filter(
  (f) => f.endsWith(".md") && !canonical.includes(f),
);
for (const file of stale) {
  rmSync(join(DEST, file));
  console.log(`removed stale: review/rules/${file}`);
}

if (stale.length === 0 && canonical.length === 0) {
  console.error("No rules files found in implementation/rules/");
  process.exit(1);
}
