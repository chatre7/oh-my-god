#!/usr/bin/env bash
# oh-my-god installer
# Usage: curl -fsSL https://raw.githubusercontent.com/chatre7/oh-my-god/master/install.sh | bash

set -e

REPO="https://github.com/chatre7/oh-my-god.git"
TMP_DIR=$(mktemp -d)
TARGET="${1:-$PWD}"

echo "Installing oh-my-god into: $TARGET"

# Clone repo to temp dir
git clone --depth=1 --quiet "$REPO" "$TMP_DIR/oh-my-god"

SRC="$TMP_DIR/oh-my-god"

# Copy core files
cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
cp -r "$SRC/skills" "$TARGET/"
cp -r "$SRC/.claude" "$TARGET/"

# Copy platform files
cp "$SRC/AGENTS.md" "$TARGET/AGENTS.md"
cp "$SRC/GEMINI.md" "$TARGET/GEMINI.md"
cp "$SRC/gemini-extension.json" "$TARGET/gemini-extension.json"

# Copy hooks
cp -r "$SRC/hooks" "$TARGET/"
chmod +x "$TARGET/hooks/session-start.sh"
chmod +x "$TARGET/hooks/log-skill.sh"

# Copy stat.md if not already present
if [ ! -f "$TARGET/stat.md" ]; then
  cp "$SRC/stat.md" "$TARGET/stat.md"
fi

# Cleanup
rm -rf "$TMP_DIR"

echo ""
echo "━━━ oh-my-god installed ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  CLAUDE.md        ✓"
echo "  skills/ (46)     ✓"
echo "  .claude/commands ✓"
echo "  hooks/           ✓"
echo "  stat.md          ✓"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Start with: /oh-my-god <task>"
echo ""
