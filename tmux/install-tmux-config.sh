#!/usr/bin/env bash
# Purpose: Link tmux configuration from repo to ~/.config/tmux

set -e

# --- Check if tmux is installed ---
if ! command -v tmux &>/dev/null; then
  echo "⚠️  tmux is not installed on your system."
  read -rp "Do you want to install tmux now? (y/N): " confirm
  confirm=${confirm,,}  # convert to lowercase
  if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
    echo "📦 Installing tmux..."
    if [[ -x "$(command -v apt-get)" ]]; then
    sudo apt-get install -y tmux || {
      echo "❌ tmux installation failed."
      exit 1
    }

    elif [[ -x "$(command -v dnf)" ]]; then
      sudo dnf install -y tmux
    elif [[ -x "$(command -v brew)" ]]; then
      brew install tmux
    else
      echo "❌ Unsupported package manager. Please install tmux manually."
      exit 1
    fi
    echo "✅ tmux installed successfully."
  else
    echo "❌ Aborting — tmux is required for this setup."
    exit 1
  fi
else
  TMUX_VERSION=$(tmux -V 2>/dev/null | awk '{print $2}')
  echo "✅ tmux is already installed (version: $TMUX_VERSION)"
fi

# --- Paths ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_SRC="$REPO_DIR/tmux.conf"
CONFIG_DIR="$HOME/.config/tmux"
TARGET_CONF="$CONFIG_DIR/tmux.conf"

echo
echo "🔧 Setting up tmux configuration..."
echo "Source: $TMUX_SRC"
echo "Target: $TARGET_CONF"
echo

# Ensure target directory exists
mkdir -p "$CONFIG_DIR"

# Backup any existing config (not symlink)
if [ -f "$TARGET_CONF" ] && [ ! -L "$TARGET_CONF" ]; then
  echo "📦 Backing up existing tmux.conf to $TARGET_CONF.bak"
  mv "$TARGET_CONF" "$TARGET_CONF.bak"
fi

# Remove old symlink if it exists
if [ -L "$TARGET_CONF" ]; then
  echo "🔗 Removing old symlink..."
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
