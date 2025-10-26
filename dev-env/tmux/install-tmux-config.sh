#!/usr/bin/env bash
# install-tmux-config.sh
# Purpose: Link tmux configuration from repo to ~/.config/tmux

set -e

# --- Paths ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_SRC="$REPO_DIR/.tmux.conf"
CONFIG_DIR="$HOME/.config/tmux"
TARGET_CONF="$CONFIG_DIR/tmux.conf"

echo "🔧 Setting up tmux configuration..."
echo "Source: $TMUX_SRC"
echo "Target: $TARGET_CONF"
echo

# Ensure target directory exists
mkdir -p "$CONFIG_DIR"

# Backup any existing config (not symlink)
if [ -f "$TARGET_CONF" ] && [ ! -L "$TARGET_CONF" ]; then
  echo "Backing up existing tmux.conf to $TARGET_CONF.bak"
  mv "$TARGET_CONF" "$TARGET_CONF.bak"
fi

# Remove old symlink if it exists
if [ -L "$TARGET_CONF" ]; then
  echo "Removing old symlink..."
  rm "$TARGET_CONF"
fi

# Create new symlink
ln -s "$TMUX_SRC" "$TARGET_CONF"
echo "✅ Symlink created successfully."

# Show confirmation
echo
echo "🧩 Current link:"
ls -l "$TARGET_CONF"
echo

# Reload tmux if running
if tmux info &>/dev/null; then
  tmux source-file "$TARGET_CONF"
  echo "♻️  Reloaded tmux configuration inside running tmux session."
else
  echo "ℹ️  tmux is not running — configuration will load next time you start tmux."
fi

echo
echo "🎉 Done! Your tmux config is now active."
