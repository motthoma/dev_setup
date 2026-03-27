#!/usr/bin/env bash
set -euo pipefail

# =========================
# CONFIG
# =========================
NVIM_MIN_VERSION="0.10.0"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"

INSTALL_PATH="/usr/local/bin/nvim"

# =========================
# HELPERS
# =========================

log() {
  echo -e "\n→ $1"
}

warn() {
  echo -e "\n⚠ $1"
}

die() {
  echo -e "\n❌ $1"
  exit 1
}

version_ge() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)" = "$1" ]
}

get_nvim_version() {
  nvim --version 2>/dev/null | head -n1 | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | sed 's/^v//' || true
}

detect_all_nvims() {
  log "Checking existing Neovim binaries..."
  which -a nvim 2>/dev/null || true
}

remove_conflicts() {
  log "Removing conflicting Neovim installations..."

  # apt version
  if dpkg -l 2>/dev/null | grep -q neovim; then
    sudo apt remove -y neovim
  fi

  # snap version
  if command -v snap >/dev/null 2>&1 && snap list 2>/dev/null | grep -q nvim; then
    sudo snap remove nvim || true
  fi

  # old manual binary
  if [ -f "$INSTALL_PATH" ]; then
    sudo rm -f "$INSTALL_PATH"
  fi
}

install_appimage() {
  log "Downloading latest Neovim AppImage..."

  TMP_APPIMAGE="/tmp/nvim.appimage"

  curl -fL -o "$TMP_APPIMAGE" "$NVIM_APPIMAGE_URL" \
    || die "Download failed"

  chmod +x "$TMP_APPIMAGE"

  log "Installing to $INSTALL_PATH"

  sudo mv "$TMP_APPIMAGE" "$INSTALL_PATH"
  sudo chmod +x "$INSTALL_PATH"
}

verify_install() {
  log "Verifying installation..."

  if ! command -v nvim >/dev/null 2>&1; then
    die "nvim not found in PATH after install"
  fi

  NVIM_VER="$(get_nvim_version)"

  if [ -z "$NVIM_VER" ]; then
    warn "Could not detect Neovim version"
  else
    echo "→ Installed version: $NVIM_VER"
  fi

  echo "→ Binary: $(command -v nvim)"
}

# =========================
# MAIN
# =========================

log "Neovim installer starting..."

detect_all_nvims

CURRENT_VER="$(get_nvim_version)"

if [ -n "$CURRENT_VER" ]; then
  echo "→ Current version: $CURRENT_VER"
fi

if [ -n "$CURRENT_VER" ] && version_ge "$CURRENT_VER" "$NVIM_MIN_VERSION"; then
  echo "✅ Neovim already up-to-date"
  exit 0
fi

warn "Installing/upgrading Neovim..."

remove_conflicts
install_appimage
verify_install

log "DONE"
echo "👉 Run: hash -r (or restart terminal)"
echo "👉 Then: nvim --version"
