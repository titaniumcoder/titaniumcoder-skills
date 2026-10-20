#!/usr/bin/env bash
# titaniumcoder-skills installer (Claude Code command adapters).
#
# Clones (or updates) this repository to a stable path on the machine, then
# installs the Claude Code command adapters. They point back at the stable
# clone, so `git pull` (or rerunning this script) updates every workflow at
# once.
#
# For pi, this script is NOT used: install the pi package instead with
#   pi install git:github.com/titaniumcoder/titaniumcoder-skills@main
# which deploys the prompt templates and updates via `pi update`.
#
# Usage: ./install.sh
#
# The skills/ directories remain the source of truth; adapters are thin
# wrappers that tell the agent to read and follow skills/<name>/SKILL.md.

set -euo pipefail

REPO_URL="https://github.com/titaniumcoder/titaniumcoder-skills.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.agents/skills-src"
# When run from a checkout of this repository, install from that checkout so
# local commits deploy immediately; otherwise fall back to the GitHub URL.
if [[ -d "${SCRIPT_DIR}/adapters" && -d "${SCRIPT_DIR}/.git" ]]; then
  REPO_URL="${SCRIPT_DIR}"
fi

# 1. Clone or update the stable source checkout.
if [[ -d "${DEST}/.git" ]]; then
  if ! git -C "${DEST}" remote get-url origin >/dev/null 2>&1; then
    rm -rf "${DEST}"
  fi
fi
if [[ -d "${DEST}/.git" ]]; then
  git -C "${DEST}" pull --ff-only
else
  git clone "${REPO_URL}" "${DEST}"
fi
if [[ ! -d "${DEST}/adapters" ]]; then
  echo "ERROR: ${DEST} has no adapters/ — the source checkout may be stale." >&2
  exit 1
fi

# 2. Install the Claude Code command adapters (thin wrappers).
mkdir -p "${HOME}/.claude/commands"
cp "${DEST}"/adapters/claude/*.md "${HOME}/.claude/commands/"

echo "Installed from ${DEST}: Claude Code commands -> ~/.claude/commands/"
echo "  (/scout /plan /stubs /implement /review)"
echo "Restart Claude Code to pick up new or updated commands."
