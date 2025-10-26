# ⚡ Developer Productivity Environment Setup

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

### 💪 Includes setups for:
- 🧩 **Neovim** — modern Vim-based text editor  
- 🖥️ **Tmux** — terminal multiplexer for managing sessions  
- ⚙️ **Ansible** — automated provisioning of your development environment  
- 🧰 **Bash** and Unix utilities for workflow automation  
- 🗒️ **Transcripts and examples** from the course for reference  

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

## 2.1 Neovim

# 🧩 Run Neovim setup via shell script

```bash
cd neovim
chmod +x neovim.sh
./neovim.sh
```

# ⚙️ Or run it via Ansible playbook

```bash
ansible-playbook neovim_ansible.yml
```

## 2.2 tmux 


```bash
cd tmux
```
