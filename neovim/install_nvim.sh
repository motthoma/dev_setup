#!/usr/bin/env bash
set -e

# === CONFIG ===
NVIM_MIN_VERSION="0.11.0"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_BIN="/usr/local/bin/nvim"

# === FUNCTIONS ===
version_ge() {
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

# === CHECK/INSTALL NEOVIM ===
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

echo "✅ Neovim installation/update complete!"
