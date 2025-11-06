#!/usr/bin/env bash
set -e  # Exit on error

# === CONFIG ===
REPO_URL="https://github.com/motthoma/kickstart.nvim.git"
CLONE_DIR="$HOME/home/thomas/workspace_thomas/dev_setup/dev-env/github_repos"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# === HEADER ===
echo "====================================="
echo " Updating Neovim config from fork"
echo " Repository: $REPO_URL"
echo " Target: $NVIM_CONFIG_DIR"
echo "====================================="
echo

# === CLONE OR UPDATE REPO ===
if [ -d "$CLONE_DIR/.git" ]; then
  echo "→ Pulling latest changes in $CLONE_DIR"
  git -C "$CLONE_DIR" pull --rebase
else
  echo "→ Cloning repository..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi

# === SYNC CONFIG ===
echo "→ Copying configuration to $NVIM_CONFIG_DIR"
mkdir -p "$NVIM_CONFIG_DIR"
rsync -avh --delete "$CLONE_DIR/" "$NVIM_CONFIG_DIR/"

# === DONE ===
echo
echo "✅ Neovim configuration updated successfully!"
echo "You can now open Neovim with: nvim"
