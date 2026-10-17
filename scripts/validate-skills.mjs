#!/usr/bin/env node
// Validates every skills/**/SKILL.md against the Agent Skills specification.
// Zero dependencies — uses only the Node standard library.
// Exit code 1 on any error; warnings do not fail the run.

import { readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative, basename, dirname } from "node:path";
import { validateSkill } from "./lib.mjs";

const ROOT = join(import.meta.dirname, "..");
const SKILLS_DIR = join(ROOT, "skills");

const errors = [];
const warnings = [];
const skills = [];

function findSkillFiles(dir) {
  const out = [];
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      out.push(...findSkillFiles(full));
    } else if (entry === "SKILL.md") {
      out.push(full);
    }
  }
  return out;
}

const files = findSkillFiles(SKILLS_DIR);
if (files.length === 0) {
  errors.push("No SKILL.md files found under skills/");
}

const seen = new Map();
for (const file of files) {
  const rel = relative(ROOT, file);
  const result = validateSkill({ skillDir: basename(dirname(file)), text: readFileSync(file, "utf8") });
  skills.push({ rel, fields: result.fields });

  for (const e of result.errors) errors.push(`${rel}: ${e}`);
  for (const w of result.warnings) warnings.push(`${rel}: ${w}`);

  const name = result.fields?.name;
  if (name && seen.has(name)) {
    errors.push(`${rel}: duplicate skill name '${name}' (first seen in ${seen.get(name)}); first one wins`);
  } else if (name) {
    seen.set(name, rel);
  }
}

for (const e of errors) console.error(`ERROR: ${e}`);
for (const w of warnings) console.warn(`WARN:  ${w}`);

if (errors.length > 0) {
  console.error(`\nValidation failed: ${errors.length} error(s), ${warnings.length} warning(s), ${skills.length} skill(s).`);
  process.exit(1);
}
console.log(`OK: ${skills.length} skill(s) valid, ${warnings.length} warning(s).`);