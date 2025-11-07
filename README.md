# Developer Environment Setup

[![Frontend Masters](https://img.shields.io/badge/Frontend%20Masters-Developer%20Productivity%20v2-red?logo=frontendmasters&logoColor=white)](https://frontendmasters.com/courses/developer-productivity-v2/)
[![Built with Bash](https://img.shields.io/badge/Bash-4.x-blue?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-black?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-Educational-lightgrey.svg)](#-license)

> 🧠 A full developer environment setup inspired by  
> [The Primeagen’s *Developer Productivity v2*](https://frontendmasters.com/courses/developer-productivity-v2/) course on Frontend Masters.

---

## 📘 Overview

This repository contains a collection of **environment setup scripts, configuration files, and course reference materials** designed to help developers become faster and more efficient in their day-to-day workflows.

It is based on *The Primeagen’s* course on [Frontend Masters](https://frontendmasters.com/), which focuses on practical tools, terminal mastery, automation, and editor customization.

###  Includes setups for:
-  **Neovim**  
-  **Vim**  
-  **Tmux**  

---

> ⚠️ The `course_material/` directory is **for educational reference only**, derived from The Primeagen’s *Developer Productivity v2* course.

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/dev-setup.git
cd dev-setup/dev-env
```
### 2. Run setup scripts 

### 2.1 Neovim

Clone, build and install neovim release 0.11.0 by execution of the *neovim.sh* script: 

```bash
cd neovim
chmod +x neovim.sh
./neovim.sh
```

 or run it via Ansible playbook

```bash
ansible-playbook neovim_ansible.yml
```

Update neovim setup via shell script to clone [neovim kickstart fork](https://github.com/motthoma/kickstart.nvim) that contains custom init.lua file:

```bash
cd neovim
chmod +x update_nvim_config_from_kickstart.sh
./update_nvim_config_from_kickstart.sh
```

### 2.2 Vim

Execute *update_vim_config.sh* script to install vim (if not yet installed), copy *.vimrc* from /dev-env/vim to home and install all plugins.

```bash
cd vim
chmod +x update_vim_config.sh
./update_vim_config.sh
```

The *update_vim_config.sh* installs the plugins according to the following instructions:


```bash
Setup instruction for installation of vim plugins


-ensure with vim --version that 8.2 or newer is installed

-copy dot_vimrc.txt to home and rename it:
 cp -r dot_vimrc.txt ~/.vimrc

- clone vundle plugin manager:
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

-open .vimrc with vim and run :source %

-install exuberant ctags for Tagbars:
 sudo apt install exuberant-ctags

- clone ale code analysis tool:
  mkdir -p ~/.vim/pack/git-plugins/start
  git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale

- open vim and run :PluginInstall

- install LSP Server:
  if venv is not yet installed do sudo apt install python3.10-venv
  open a python script in vim and run :LspInstallServer

YouComplete (not needed if LSP server is used):
-install YouComplete:
 cd ~/.vim/bundle/YouCompleteMe
 python3 install.py
```

### 2.2 Tmux 

Run tmux install config as shell script to install tmux and create symlink to *.tmux.conf*:

```bash
cd tmux
chmod +x install_tmux_config.sh
./install_tmux_config.sh
```
