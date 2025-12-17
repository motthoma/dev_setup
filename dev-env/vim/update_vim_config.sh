#!/usr/bin/env bash
set -e
set -u

# ---------------------------------------------------------------------
# 📌 Resolve script directory (absolute path)
# ---------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Path to the local .vimrc inside the repo
VIMRC_SOURCE="$SCRIPT_DIR/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"

# ---------------------------------------------------------------------
# 🎯 1. Ensure Vim is installed (>= 9.2, auto-upgrade via PPA if needed)
# ---------------------------------------------------------------------

REQUIRED_VIM_VERSION="9.0"

get_vim_version() {
  vim --version 2>/dev/null | head -n1 | grep -oE '[0-9]+\.[0-9]+'
}

if ! command -v vim &>/dev/null; then
  echo "⬇️ Vim not found — installing latest Vim via PPA..."
  sudo add-apt-repository -y ppa:jonathonf/vim
  sudo apt update
  sudo apt install -y vim
else
  CURRENT_VIM_VERSION="$(get_vim_version)"
  echo "ℹ️  Detected Vim version: $CURRENT_VIM_VERSION"

  if (( $(echo "$CURRENT_VIM_VERSION < $REQUIRED_VIM_VERSION" | bc -l) )); then
    echo "⬆️  Vim version too old (requires ≥ $REQUIRED_VIM_VERSION)."
    echo "🔄 Adding Vim PPA and upgrading Vim..."
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt update
    sudo apt install -y vim

    NEW_VIM_VERSION="$(get_vim_version)"
    if (( $(echo "$NEW_VIM_VERSION < $REQUIRED_VIM_VERSION" | bc -l) )); then
      echo "❌ Vim upgrade failed. Version $NEW_VIM_VERSION is still < $REQUIRED_VIM_VERSION."
      exit 1
    fi
  else
    echo "✅ Vim version is sufficient (≥ $REQUIRED_VIM_VERSION)."
  fi
fi

echo "✅ Vim $(get_vim_version) ready."

# ---------------------------------------------------------------------
# 📁 2. Copy .vimrc to home (with backup)
# ---------------------------------------------------------------------
if [ -f "$VIMRC_TARGET" ]; then
  echo "📦 Backing up existing .vimrc → ~/.vimrc.backup"
  cp -f "$VIMRC_TARGET" "$HOME/.vimrc.backup"
fi

echo "📄 Copying .vimrc to home directory..."
cp -f "$VIMRC_SOURCE" "$VIMRC_TARGET"

# ---------------------------------------------------------------------
# 🔌 3. Install Vundle plugin manager
# ---------------------------------------------------------------------
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  echo "⬇️ Cloning Vundle..."
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
else
  echo "🔁 Updating Vundle..."
  cd "$HOME/.vim/bundle/Vundle.vim" && git pull
fi

# ---------------------------------------------------------------------
# 🧠 4. Install Exuberant Ctags (for Tagbar)
# ---------------------------------------------------------------------
echo "📦 Installing Exuberant Ctags..."
sudo apt update
sudo apt install -y exuberant-ctags

# ---------------------------------------------------------------------
# 🧰 5. Install ALE (Asynchronous Lint Engine)
# ---------------------------------------------------------------------
echo "🔍 Installing ALE..."
mkdir -p "$HOME/.vim/pack/git-plugins/start"
if [ ! -d "$HOME/.vim/pack/git-plugins/start/ale" ]; then
  git clone --depth 1 https://github.com/dense-analysis/ale.git "$HOME/.vim/pack/git-plugins/start/ale"
else
  echo "🔁 Updating ALE..."
  cd "$HOME/.vim/pack/git-plugins/start/ale" && git pull
fi

# ---------------------------------------------------------------------
# 🚀 6. Install Plugins via Vundle
# ---------------------------------------------------------------------
echo "⚙️ Installing Vim plugins via Vundle..."
vim +PluginInstall +qall

# ---------------------------------------------------------------------
# 🧩 7. (Optional) Install YouCompleteMe if present
# ---------------------------------------------------------------------
if [ -d "$HOME/.vim/bundle/YouCompleteMe" ]; then
  echo "🧠 Installing YouCompleteMe..."
  cd "$HOME/.vim/bundle/YouCompleteMe"
  python3 install.py
fi

# ---------------------------------------------------------------------
# 🐍 8. Ensure Python venv for LSP support
# ---------------------------------------------------------------------
if ! dpkg -s python3.10-venv &>/dev/null && ! dpkg -s python3-venv &>/dev/null; then
  echo "📦 Installing Python venv..."
  sudo apt install -y python3-venv
fi

# ---------------------------------------------------------------------
# 🌐 9. Ensure curl is installed
# ---------------------------------------------------------------------
echo "🔧 Ensuring curl is installed..."
if ! command -v curl &> /dev/null; then
  sudo apt update
  sudo apt install -y curl
  echo "✅ curl installed."
else
  echo "✅ curl already installed."
fi

# ---------------------------------------------------------------------
# 🧩 10. Install clangd (C/C++ language server)
# ---------------------------------------------------------------------
echo "🛠  Installing clangd (C/C++ LSP)..."
if ! command -v clangd &> /dev/null; then
  sudo apt update
  sudo apt install -y clangd
  echo "✅ clangd installed."
else
  echo "✅ clangd already installed."
fi

# ---------------------------------------------------------------------
# 🎉 Done
# ---------------------------------------------------------------------
echo "🎉 Vim setup complete!"
echo "💡 Local .vimrc used from: $VIMRC_SOURCE"

