#!/usr/bin/env bash
set -euo pipefail

REQUIRED_MAJOR="9.2"

install_vim() {
  echo "⬇️ Installing Vim ${REQUIRED_MAJOR}+ ..."

  sudo apt update || true
  sudo apt install -y git build-essential libncurses-dev curl unzip

  # Fix for corporate networks (HTTP/2 issues)
  git config --global http.version HTTP/1.1 || true

  cd /tmp
  rm -rf vim vim.zip vim-*

  echo "🔎 Detecting latest Vim ${REQUIRED_MAJOR}.x tag..."

  # Try to fetch latest 9.2.x tag
  LATEST_TAG=$(git ls-remote --tags https://github.com/vim/vim.git 2>/dev/null \
    | grep -o "refs/tags/v${REQUIRED_MAJOR}\.[0-9]*" \
    | sed 's|refs/tags/||' \
    | sort -V \
    | tail -n1)

  if [ -z "${LATEST_TAG:-}" ]; then
    echo "⚠️ Could not detect latest tag via git — using fallback v9.2.0000"
    LATEST_TAG="v9.2.0000"
  fi

  echo "📌 Using Vim tag: $LATEST_TAG"

  # Try git clone first
  if git clone --depth 1 --branch "$LATEST_TAG" https://github.com/vim/vim.git; then
    cd vim
  else
    echo "⚠️ Git clone failed — falling back to ZIP..."

    curl -L -o vim.zip "https://github.com/vim/vim/archive/refs/tags/${LATEST_TAG}.zip"
    unzip vim.zip
    cd "vim-${LATEST_TAG#v}"
  fi

  echo "⚙️ Building Vim..."
  ./configure --with-features=huge --enable-multibyte
  make -j$(nproc)
  sudo make install

  echo "✅ Vim installed."
}

# ---------------------------------------------------------------------
# Check existing version
# ---------------------------------------------------------------------
if command -v vim &>/dev/null; then
  CURRENT=$(vim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+')
  echo "🔍 Detected Vim $CURRENT"

  if dpkg --compare-versions "$CURRENT" lt "$REQUIRED_MAJOR"; then
    echo "⚠️ Vim too old — upgrading..."
    install_vim
  else
    echo "✅ Vim is already sufficient."
  fi
else
  echo "❌ Vim not found — installing..."
  install_vim
fi

# ---------------------------------------------------------------------
# Ensure correct binary is used
# ---------------------------------------------------------------------
if [ -x /usr/local/bin/vim ]; then
  export PATH=/usr/local/bin:$PATH
fi

echo "🎉 Done:"
vim --version | head -n1
