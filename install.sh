#!/usr/bin/env bash
# oh-my-god installer
# Usage: curl -fsSL https://raw.githubusercontent.com/chatre7/oh-my-god/master/install.sh | bash

set -e

REPO="https://github.com/chatre7/oh-my-god.git"
TMP_DIR=$(mktemp -d)
TARGET="${1:-$PWD}"

echo "Installing oh-my-god into: $TARGET"
echo ""

# Clone repo to temp dir
git clone --depth=1 --quiet "$REPO" "$TMP_DIR/oh-my-god"

SRC="$TMP_DIR/oh-my-god"

# --- Append config files (preserve existing content) ---
append_or_copy() {
  local file="$1"
  local src="$SRC/$file"
  local dest="$TARGET/$file"
  if [ -f "$dest" ]; then
    echo "" >> "$dest"
    echo "# --- oh-my-god ---" >> "$dest"
    cat "$src" >> "$dest"
    echo "  $file        appended"
  else
    cp "$src" "$dest"
    echo "  $file        ✓"
  fi
}

append_or_copy "CLAUDE.md"
append_or_copy "AGENTS.md"
append_or_copy "GEMINI.md"

# --- Skip if exists (project-specific data) ---
skip_if_exists() {
  local file="$1"
  local src="$SRC/$file"
  local dest="$TARGET/$file"
  if [ -f "$dest" ]; then
    echo "  $file        skipped (already exists)"
  else
    cp "$src" "$dest"
    echo "  $file        ✓"
  fi
}

skip_if_exists "gemini-extension.json"
skip_if_exists "stat.md"

# --- Overwrite library files ---
mkdir -p "$TARGET/.agents"
cp -r "$SRC/.agents/skills" "$TARGET/.agents/"
echo "  .agents/skills/ (46) ✓"

cp -r "$SRC/.claude" "$TARGET/"
echo "  .claude/commands ✓"

cp -r "$SRC/hooks" "$TARGET/"
chmod +x "$TARGET/hooks/session-start.sh"
chmod +x "$TARGET/hooks/log-skill.sh"
echo "  hooks/           ✓"

# Cleanup
rm -rf "$TMP_DIR"

echo ""
echo "━━━ oh-my-god installed ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Start with: /oh-my-god <task>"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
