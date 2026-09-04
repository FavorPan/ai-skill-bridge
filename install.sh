#!/usr/bin/env bash
# AI Skill Bridge — One-click installer
# Usage:
#   ./install.sh              # Install to all tools
#   ./install.sh claude-code  # Install to specific tool
#   ./install.sh hermes cursor # Install to multiple tools

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ALL_TOOLS="hermes claude-code codex cursor openclaw"

get_src() {
  case "$1" in
    hermes)      echo "$SCRIPT_DIR/hermes/SKILL.md" ;;
    claude-code) echo "$SCRIPT_DIR/claude-code/SKILL.md" ;;
    codex)       echo "$SCRIPT_DIR/codex/SKILL.md" ;;
    cursor)      echo "$SCRIPT_DIR/cursor/skill.mdc" ;;
    openclaw)    echo "$SCRIPT_DIR/openclaw/SKILL.md" ;;
  esac
}

get_dst() {
  case "$1" in
    hermes)      echo "$HOME/.hermes/skills/devops/ai-skill-bridge/SKILL.md" ;;
    claude-code) echo "$HOME/.claude/commands/ai-skill-bridge.md" ;;
    codex)       echo "$HOME/.codex/skills/ai-skill-bridge.md" ;;
    cursor)      echo "$(pwd)/.cursor/rules/ai-skill-bridge.mdc" ;;
    openclaw)    echo "$HOME/.openclaw/skills/ai-skill-bridge.md" ;;
  esac
}

install_tool() {
  local tool="$1"
  local src dst
  src="$(get_src "$tool")"
  dst="$(get_dst "$tool")"

  if [[ ! -f "$src" ]]; then
    echo "  ✗ Source not found: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  ✓ $tool → $dst"
}

is_valid_tool() {
  local t="$1"
  for valid in $ALL_TOOLS; do
    [[ "$t" == "$valid" ]] && return 0
  done
  return 1
}

# Parse args
if [[ $# -eq 0 ]]; then
  targets=($ALL_TOOLS)
else
  targets=("$@")
fi

echo "AI Skill Bridge — Installing..."
echo ""

for tool in "${targets[@]}"; do
  if ! is_valid_tool "$tool"; then
    echo "  ✗ Unknown tool: $tool"
    echo "    Available: $ALL_TOOLS"
    exit 1
  fi
  install_tool "$tool"
done

echo ""
echo "Done."
