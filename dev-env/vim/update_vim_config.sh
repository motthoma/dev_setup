#!/usr/bin/env bash
set -e
set -u

# ---------------------------------------------------------------------
# 📌 Resolve script directory (absolute path)
# ---------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

VIMRC_SOURCE="$SCRIPT_DIR/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"

REQUIRED_VIM_VERSION="9.1"

# ---------------------------------------------------------------------
# 🎯 1. Ensure Vim 9.1+ is installed
# ---------------------------------------------------------------------
install_vim_91() {
  echo "⬇️ Installing / upgrading Vim to 9.1+ ..."
  sudo apt update
  sudo apt install -y software-properties-common
  sudo add-apt-repository -y ppa:jonathonf/vim
  sudo apt update
  sudo apt install -y vim vim-gtk3
}

if ! command -v vim &>/dev/null; then
  echo "❌ Vim not found."
  install_vim_91
else
  VIM_VERSION_FULL=$(vim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+')
  echo "🔍 Detected Vim $VIM_VERSION_FULL"

  if dpkg --compare-versions "$VIM_VERSION_FULL" lt "$REQUIRED_VIM_VERSION"; then
    echo "⚠️ Vim $VIM_VERSION_FULL is too old (need ≥ $REQUIRED_VIM_VERSION)"
    install_vim_91
  else
    echo "✅ Vim $VIM_VERSION_FULL is sufficient."
  fi
fi

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
# 🧠 4. Ensure Exuberant Ctags (for Tagbar)
# ---------------------------------------------------------------------
echo "🔎 Checking for ctags..."

if ! command -v ctags &>/dev/null; then
  echo "📦 ctags not found — installing Exuberant Ctags..."
  sudo apt update
  sudo apt install -y exuberant-ctags
  echo "✅ Exuberant Ctags installed."
else
  echo "✅ ctags already installed."
fi

# ---------------------------------------------------------------------
# 🧰 5. Install ALE
# ---------------------------------------------------------------------
echo "🔍 Installing ALE..."
mkdir -p "$HOME/.vim/pack/git-plugins/start"
if [ ! -d "$HOME/.vim/pack/git-plugins/start/ale" ]; then
  git clone --depth 1 https://github.com/dense-analysis/ale.git \
    "$HOME/.vim/pack/git-plugins/start/ale"
else
  cd "$HOME/.vim/pack/git-plugins/start/ale" && git pull
fi

# ---------------------------------------------------------------------
# 🚀 6. Install Plugins via Vundle
# ---------------------------------------------------------------------
echo "⚙️ Installing Vim plugins via Vundle..."
vim +PluginInstall +qall

# ---------------------------------------------------------------------
# 🧩 7. Install YouCompleteMe (Vim 9.1+ compatible)
# ---------------------------------------------------------------------
if [ -d "$HOME/.vim/bundle/YouCompleteMe" ]; then
  echo "🧠 Installing YouCompleteMe..."
  cd "$HOME/.vim/bundle/YouCompleteMe"
  python3 install.py --clangd-completer
fi

# ---------------------------------------------------------------------
# 🐍 8. Ensure Python venv
# ---------------------------------------------------------------------
if ! dpkg -s python3-venv &>/dev/null; then
  sudo apt install -y python3-venv
fi

# ---------------------------------------------------------------------
# 🌐 9. Ensure curl
# ---------------------------------------------------------------------
command -v curl &>/dev/null || sudo apt install -y curl

# ---------------------------------------------------------------------
# 🧩 10. Ensure clangd
# ---------------------------------------------------------------------
command -v clangd &>/dev/null || sudo apt install -y clangd

# ---------------------------------------------------------------------
# 🎉 Done
# ---------------------------------------------------------------------
echo "🎉 Vim 9.1+ setup complete!"
vim --version | head -n 1

