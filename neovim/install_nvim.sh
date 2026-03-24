#!/usr/bin/env bash
set -e

# === CONFIG ===
NVIM_MIN_VERSION="0.11.0"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_BIN="/usr/local/bin/nvim"

# === FUNCTIONS ===
version_ge() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)" = "$1" ]
}

get_nvim_version() {
  nvim --version 2>/dev/null | head -n1 | awk '{print $2}' | sed 's/^v//'
}

remove_existing_nvim() {
  echo "→ Removing existing Neovim installations..."

  # Remove apt version if present
  if dpkg -l | grep -q neovim; then
    echo "  - Removing apt Neovim"
    sudo apt remove -y neovim
  fi

  # Remove snap version if present
  if command -v snap >/dev/null && snap list | grep -q nvim; then
    echo "  - Removing snap Neovim"
    sudo snap remove nvim
  fi

  # Remove existing binary if present
  if [ -f "$NVIM_BIN" ]; then
    echo "  - Removing existing $NVIM_BIN"
    sudo rm -f "$NVIM_BIN"
  fi
}

install_nvim_appimage() {
  echo "→ Downloading latest Neovim AppImage..."
  TMP_APPIMAGE="/tmp/nvim.appimage"

  curl -L -o "$TMP_APPIMAGE" "$NVIM_APPIMAGE_URL"
  chmod u+x "$TMP_APPIMAGE"

  echo "→ Installing to $NVIM_BIN"
  sudo mv "$TMP_APPIMAGE" "$NVIM_BIN"
  sudo chmod +x "$NVIM_BIN"
}

# === MAIN ===
if command -v nvim >/dev/null 2>&1; then
  CURRENT_PATH=$(command -v nvim)
  NVIM_CURRENT_VERSION=$(get_nvim_version)

  echo "→ Found Neovim at $CURRENT_PATH (version $NVIM_CURRENT_VERSION)"

  if version_ge "$NVIM_CURRENT_VERSION" "$NVIM_MIN_VERSION"; then
    echo "✅ Neovim is up to date."
    exit 0
  else
    echo "⚠ Version too old → performing clean reinstall..."
    remove_existing_nvim
    install_nvim_appimage
  fi
else
  echo "⚠ Neovim not found → installing..."
  install_nvim_appimage
fi

echo "✅ Neovim installation/update complete!"

hash -r 2>/dev/null || true

echo "→ Installed version: $(nvim --version | head -n1)"
echo "→ Binary path: $(command -v nvim)"
