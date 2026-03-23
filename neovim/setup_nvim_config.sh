#!/usr/bin/env bash
set -e

LOCAL_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nvim"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "→ Ensuring $NVIM_CONFIG_DIR is symlinked to $LOCAL_CONFIG_DIR"
if [ -L "$NVIM_CONFIG_DIR" ]; then
  # Already a symlink, check if it points to the right place
  CURRENT_TARGET=$(readlink -f "$NVIM_CONFIG_DIR")
  if [ "$CURRENT_TARGET" != "$LOCAL_CONFIG_DIR" ]; then
    echo "⚠ $NVIM_CONFIG_DIR points to $CURRENT_TARGET. Updating to $LOCAL_CONFIG_DIR..."
    rm "$NVIM_CONFIG_DIR"
    ln -s "$LOCAL_CONFIG_DIR" "$NVIM_CONFIG_DIR"
  fi
elif [ -d "$NVIM_CONFIG_DIR" ]; then
  echo "⚠ $NVIM_CONFIG_DIR is a directory. Moving to $NVIM_CONFIG_DIR.bak and symlinking..."
  mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
  ln -s "$LOCAL_CONFIG_DIR" "$NVIM_CONFIG_DIR"
else
  echo "→ Creating symlink $NVIM_CONFIG_DIR → $LOCAL_CONFIG_DIR"
  mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
  ln -s "$LOCAL_CONFIG_DIR" "$NVIM_CONFIG_DIR"
fi

echo "✅ Neovim configuration symlinked successfully!"
