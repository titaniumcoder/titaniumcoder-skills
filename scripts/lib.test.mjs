// Tests for the skill validator. Run with: npm test (node:test, zero deps)

import { test } from "node:test";
import assert from "node:assert/strict";
import { parseFrontmatter, validateSkill, NAME_RE } from "./lib.mjs";

const okSkill = (name, description = "A perfectly adequate routing description for testing purposes.") =>
  `---\nname: ${name}\ndescription: ${description}\n---\n\n# ${name}\n`;

test("NAME_RE accepts spec-compliant names", () => {
  for (const n of ["hello", "pdf-tools", "a1", "code-review-2"]) assert.ok(NAME_RE.test(n));
});

test("NAME_RE rejects bad names", () => {
  for (const n of ["Hello", "-lead", "trail-", "double--hyphen", "under_score", ""]) assert.ok(!NAME_RE.test(n));
});

test("parseFrontmatter extracts fields from a valid document", () => {
  const fields = parseFrontmatter("---\nname: hello\ndescription: Greets people.\n---\n\nBody.");
  assert.deepEqual(fields, { name: "hello", description: "Greets people." });
});

test("parseFrontmatter returns null when frontmatter is missing", () => {
  assert.equal(parseFrontmatter("# Just a heading\n"), null);
});

test("valid skill produces no errors or warnings", () => {
  const r = validateSkill({ skillDir: "hello", text: okSkill("hello") });
  assert.deepEqual(r.errors, []);
  assert.deepEqual(r.warnings, []);
});

test("missing frontmatter is an error", () => {
  const r = validateSkill({ skillDir: "hello", text: "# No frontmatter\n" });
  assert.equal(r.errors.length, 1);
  assert.match(r.errors[0], /frontmatter/);
});

test("missing name and description are reported", () => {
  const r = validateSkill({ skillDir: "hello", text: "---\nlicense: MIT\n---\nBody." });
  assert.match(r.errors.join(" "), /'name' is required/);
  assert.match(r.errors.join(" "), /'description' is required/);
});

test("invalid name format is an error", () => {
  const r = validateSkill({ skillDir: "Bad_Name", text: okSkill("Bad_Name") });
  assert.match(r.errors.join(" "), /must be lowercase/);
});

test("name longer than 64 characters is an error", () => {
  const long = "x".repeat(65);
  const r = validateSkill({ skillDir: long, text: okSkill(long) });
  assert.match(r.errors.join(" "), /exceeds 64/);
});

test("description longer than 1024 characters is an error", () => {
  const r = validateSkill({ skillDir: "hello", text: okSkill("hello", "d".repeat(1025)) });
  assert.match(r.errors.join(" "), /exceeds 1024/);
});

test("boundary values are accepted: exactly 64-char name and 1024-char description", () => {
  const name = "x".repeat(64);
  const description = "d".repeat(1024);
  const r = validateSkill({ skillDir: name, text: `---\nname: ${name}\ndescription: ${description}\n---\n` });
  assert.deepEqual(r.errors, []);
});

test("CRLF line endings in frontmatter are handled", () => {
  const fields = parseFrontmatter("---\r\nname: hello\r\ndescription: Greets people.\r\n---\r\n\r\nBody.");
  assert.deepEqual(fields, { name: "hello", description: "Greets people." });
  const r = validateSkill({ skillDir: "hello", text: "---\r\nname: hello\r\ndescription: Greets people.\r\n---\r\n" });
  assert.deepEqual(r.errors, []);
});

test("name that differs from directory is an error (spec requirement)", () => {
  const r = validateSkill({ skillDir: "hello", text: okSkill("greeting") });
  assert.match(r.errors.join(" "), /does not match directory/);
  assert.deepEqual(r.warnings, []);
});

test("very short description is a warning", () => {
  const r = validateSkill({ skillDir: "hello", text: okSkill("hello", "Greets.") });
  assert.deepEqual(r.errors, []);
  assert.match(r.warnings.join(" "), /description is short/);
});