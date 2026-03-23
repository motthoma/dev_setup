#!/usr/bin/env bash
set -e  # Exit on error

# ---------------------------------------------------------------------
# 🧱 1. Prepare directories
# ---------------------------------------------------------------------
mkdir -p "$HOME/workspace_thomas/dev_setup"
cd "$HOME/workspace_thomas/dev_setup"

# ---------------------------------------------------------------------
# 🧩 2. Clone Neovim source (v0.11.0)
# ---------------------------------------------------------------------
if [ -d "$HOME/workspace_thomas/dev_setup/neovim" ]; then
  echo "🔁 Updating existing Neovim source..."
  cd "$HOME/workspace_thomas/dev_setup/neovim"
  git fetch --tags
  git checkout v0.11.0
  git pull
else
  echo "⬇️ Cloning Neovim..."
  git clone -b v0.11.0 https://github.com/neovim/neovim.git "$HOME/workspace_thomas/dev_setup/neovim"
  cd "$HOME/workspace_thomas/dev_setup/neovim"
fi

# ---------------------------------------------------------------------
# ⚙️ 3. Install dependencies
# ---------------------------------------------------------------------
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y cmake gettext lua5.1 liblua5.1-0-dev nodejs npm

# ---------------------------------------------------------------------
# 🧱 4. Build Neovim
# ---------------------------------------------------------------------
echo "🛠 Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

# ---------------------------------------------------------------------
# 🚀 5. Install Neovim
# ---------------------------------------------------------------------
echo "🚀 Installing Neovim system-wide..."
sudo make install

# ---------------------------------------------------------------------
# ✅ 6. Verify
# ---------------------------------------------------------------------
echo "✅ Neovim installed successfully!"
nvim --version | head -n 5

