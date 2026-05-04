# Developer Environment Setup

[![Built with Bash](https://img.shields.io/badge/Bash-4.x-blue?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-black?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](#-license)

---

## 📘 Overview

This repository contains a collection of **environment setup scripts, configuration files, and course reference materials** designed to help developers become faster and more efficient in their day-to-day workflows.


###  Includes setups for:
-  **Neovim**  
-  **Vim**  
-  **Tmux**  
-  **GitHub Copilot** (Vim & Neovim plugin)
-  **Dotfiles** (`github .gitconfig`)

It is based on *The Primeagen’s* course on [Frontend Masters](https://frontendmasters.com/), which focuses on practical tools, terminal mastery, automation, and editor customization.

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/dev-setup.git
cd dev-setup/dev-env
```
### 2. Run setup scripts 

### 2.1 Neovim

#### Installation

Install/Update Neovim (latest AppImage, min version 0.11.0) by executing the *install_nvim.sh* script:

```bash
cd neovim
chmod +x install_nvim.sh
./install_nvim.sh
```

Or run it via Ansible playbook:

```bash
ansible-playbook neovim_ansible.yml
```

#### Configuration

Setup the Neovim configuration by symlinking `~/.config/nvim` to the local `nvim` directory:

```bash
cd neovim
chmod +x setup_nvim_config.sh
./setup_nvim_config.sh
```

The configuration is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and includes:
- **blink.cmp** for autocompletion (configured to accept the first suggestion with Enter).
- **LSP** support for multiple languages.
- **Telescope** for fuzzy finding.
- **Treesitter** for better syntax highlighting.

### 2.2 Vim

Execute *update_vim_config.sh* script to install vim (if not yet installed), copy *.vimrc* from /dev-env/vim to home and install all plugins.

```bash
cd vim
chmod +x update_vim_config.sh
./update_vim_config.sh
```

The *update_vim_config.sh* installs the plugins according to the following instructions:


#### Setup instructions for installation of vim plugins with vundle plugin manager


- ensure with 
```bash
 vim --version
```
  that 8.2 or newer is installed

- copy *dot_vimrc.txt* to home and rename it:
```bash
 cp -r dot_vimrc.txt ~/.vimrc
```

- clone vundle plugin manager:
```bash
 git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

- open *.vimrc* with vim and run *:source %*

- install exuberant ctags for Tagbars:
```bash
 sudo apt install exuberant-ctags
```

- clone ale code analysis tool:
```bash
 mkdir -p ~/.vim/pack/git-plugins/start
 git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale
```

- open vim and run *:PluginInstall*

- install LSP Server:
  if venv is not yet installed do 
```bash
 sudo apt install python3.10-venv
```
- open a python script in vim and run *:LspInstallServer*

- install YouComplete (not needed if LSP server is used):
```bash
 cd ~/.vim/bundle/YouCompleteMe
 python3 install.py
```

### 2.3 GitHub Copilot Plugin

#### Vim

Install using Vim's native package system (no vimrc changes needed):

```bash
mkdir -p ~/.vim/pack/github/start
curl -fsSL https://github.com/github/copilot.vim/archive/refs/heads/release.tar.gz \
  | tar -xz -C ~/.vim/pack/github/start/
mv ~/.vim/pack/github/start/copilot.vim-release ~/.vim/pack/github/start/copilot.vim
```

Then open Vim and run `:Copilot setup`.

#### Neovim (lazy.nvim / kickstart.nvim)

Create `~/.config/nvim/lua/custom/plugins/copilot.lua`:

```lua
return {
  {
    'github/copilot.vim',
    lazy = false,
    init = function()
      -- Remove or replace the line below if not using GitHub Enterprise
      vim.g.copilot_enterprise_uri = 'https://YOUR_DOMAIN.ghe.com'
    end,
  },
}
```

Uncomment the custom plugins import in `init.lua` (~line 1072):

```lua
{ import = 'custom.plugins' },
```

Then in Neovim run `:Lazy sync` and `:Copilot setup`.

---

### 2.4 Dotfiles (`github_copilot_dot_files`)

The `github_copilot_dot_files` directory contains a `.gitconfig` with user, editor, and credential settings. Copy it to your home directory to apply:

```bash
cp github_copilot_dot_files/.gitconfig ~/.gitconfig
```

---

### 2.3 Tmux 

Run tmux install config as shell script to install tmux and create symlink to *.tmux.conf*:

```bash
cd tmux
chmod +x install_tmux_config.sh
./install_tmux_config.sh
```
