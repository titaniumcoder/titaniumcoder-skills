// Agent Skills validation logic. Zero dependencies, imported by the CLI and tests.

export const NAME_RE = /^[a-z0-9]+(-[a-z0-9]+)*$/;
export const MAX_NAME = 64;
export const MAX_DESCRIPTION = 1024;

export function parseFrontmatter(text) {
  const match = /^---\r?\n([\s\S]*?)\r?\n---\r?\n?/.exec(text);
  if (!match) return null;
  const fields = {};
  for (const line of match[1].split(/\r?\n/)) {
    const m = /^([A-Za-z0-9_-]+)\s*:\s*(.*)$/.exec(line);
    if (m) fields[m[1]] = m[2].trim();
  }
  return fields;
}

export function validateSkill({ skillDir, text }) {
  const errors = [];
  const warnings = [];
  const fields = parseFrontmatter(text);

  if (!fields) {
    errors.push("missing or malformed frontmatter (must start with --- block)");
    return { fields, errors, warnings };
  }

  const name = fields.name;
  if (!name) {
    errors.push("frontmatter field 'name' is required");
  } else {
    if (name.length > MAX_NAME) errors.push(`name exceeds ${MAX_NAME} characters`);
    if (!NAME_RE.test(name)) {
      errors.push(`name '${name}' must be lowercase letters/numbers with single hyphens`);
    }
    if (name !== skillDir) {
      warnings.push(`name '${name}' differs from directory '${skillDir}' (portable skills should match)`);
    }
  }

  const description = fields.description;
  if (!description) {
    errors.push("frontmatter field 'description' is required");
  } else if (description.length > MAX_DESCRIPTION) {
    errors.push(`description exceeds ${MAX_DESCRIPTION} characters`);
  } else if (description.length < 20) {
    warnings.push("description is short; state what it does AND when to use it");
  }

  return { fields, errors, warnings };
}