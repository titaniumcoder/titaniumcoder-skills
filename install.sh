#!/usr/bin/env bash
# titaniumcoder-skills installer.
#
# Clones (or updates) this repository to a stable path on the machine, then
# installs the prompt adapters for pi, Claude Code, and GitHub Copilot. All
# adapters point back at the stable clone, so `git pull` (or rerunning this
# script) updates every workflow at once.
#
# Usage:
#   ./install.sh                # update clone + install prompt adapters
#   ./install.sh --with-skills  # additionally expose skills/ as auto-triggering
#                               # Agent Skills in ~/.agents/skills
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
MODE="prompts"

if [[ "${1:-}" == "--with-skills" ]]; then
  MODE="skills-and-prompts"
elif [[ -n "${1:-}" ]]; then
  echo "Unknown option: $1 (expected --with-skills or nothing)" >&2
  exit 1
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

# 2. Install prompt adapters (thin wrappers, one file per agent per workflow).
mkdir -p "${HOME}/.pi/agent/prompts"
cp "${DEST}"/adapters/pi/*.md "${HOME}/.pi/agent/prompts/"

if [[ -d "${HOME}/.claude" ]]; then
  mkdir -p "${HOME}/.claude/commands"
  cp "${DEST}"/adapters/claude/*.md "${HOME}/.claude/commands/"
fi

if [[ -d "${HOME}/.copilot" ]]; then
  mkdir -p "${HOME}/.copilot/agents"
  cp "${DEST}"/adapters/copilot/*.agent.md "${HOME}/.copilot/agents/"
fi

# 3. Optionally expose the skills themselves (auto-triggering agents).
if [[ "${MODE}" == "skills-and-prompts" ]]; then
  mkdir -p "${HOME}/.agents/skills"
  for dir in "${DEST}"/skills/*/; do
    ln -sfn "${dir}" "${HOME}/.agents/skills/$(basename "${dir}")"
  done
fi

echo "Installed (mode: ${MODE}) from ${DEST}:"
echo "  - pi prompt templates  -> ~/.pi/agent/prompts/  (/scout /plan /stubs /implement /review)"
[[ -d "${HOME}/.claude" ]] && echo "  - Claude Code commands -> ~/.claude/commands/"
[[ -d "${HOME}/.copilot" ]] && echo "  - Copilot custom agents -> ~/.copilot/agents/"
[[ "${MODE}" == "skills-and-prompts" ]] && echo "  - skills symlinked     -> ~/.agents/skills/"
echo "Run /reload in pi (or restart your agent) to pick up new or updated commands."
