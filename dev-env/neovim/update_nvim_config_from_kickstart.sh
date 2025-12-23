#!/usr/bin/env bash
set -e  # Exit on error

# === CONFIG ===
REPO_URL="https://github.com/motthoma/kickstart.nvim.git"
CLONE_DIR="$HOME/home/thomas/workspace_thomas/dev_setup/dev-env/github_repos"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_MIN_VERSION="0.11.0"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_BIN="/usr/local/bin/nvim"

# === FUNCTIONS ===
version_ge() {
  # returns 0 if $1 >= $2
  [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

install_nvim_appimage() {
  echo "→ Downloading latest Neovim AppImage..."
  TMP_APPIMAGE="/tmp/nvim.appimage"
  curl -L -o "$TMP_APPIMAGE" "$NVIM_APPIMAGE_URL"
  chmod u+x "$TMP_APPIMAGE"
  echo "→ Moving Neovim AppImage to $NVIM_BIN"
  sudo mv "$TMP_APPIMAGE" "$NVIM_BIN"
  sudo chmod +x "$NVIM_BIN"
}

# === CHECK NEOVIM ===
if command -v nvim >/dev/null 2>&1; then
  NVIM_CURRENT_VERSION=$(nvim --version | head -n1 | awk '{print $2}')
  if version_ge "$NVIM_CURRENT_VERSION" "$NVIM_MIN_VERSION"; then
    echo "✅ Neovim $NVIM_CURRENT_VERSION is already installed."
  else
    echo "⚠ Neovim version $NVIM_CURRENT_VERSION is too old, installing latest..."
    install_nvim_appimage
  fi
else
  echo "⚠ Neovim not found, installing latest..."
  install_nvim_appimage
fi

# === HEADER ===
echo
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
