# GitHub Copilot Instructions — Devsetup_Frontendmasters

Purpose
- This repository contains developer environment setup scripts and configs (Neovim, Vim, Tmux, dotfiles, Ansible). Copilot should produce suggestions useful for installation scripts, configuration, documentation, and small automation improvements.

Preferred behavior
- Focus on improving idempotency, robustness, and clarity of shell/ansible/lua files.
- Prefer POSIX-compatible, secure bash idioms (set -euo pipefail, check dependencies, graceful failures).
- Suggest small, self-contained changes with explanations and short examples.
- When proposing edits to Neovim Lua config, favor patterns consistent with kickstart.nvim / lazy.nvim plugin management.

What to avoid
- Never insert secrets, credentials, or hard-coded personal paths (e.g., /home/USERNAME) — suggest using $HOME or variables.
- Avoid recommending changes that overwrite user data without explicit confirmation.
- Do not assume specific desktop environments (X11 vs Wayland) or package managers; suggest checks or multi-platform options.
- Avoid committing generated artifacts (plugin lockfiles, caches) unless maintainer policy permits.

Commit & PR guidance
- Recommend atomic, well-described commits. Include the Co-authored-by trailer when appropriate.
- For PRs: include reproduction steps, commands used, environment details, and validation steps.

Testing & validation
- Suggest running install scripts in disposable environments (containers or VMs) before merging.
- Recommend adding basic validation: check script exit codes, add --help where useful, and include brief README updates when behavior changes.

Prompts examples (use these as templates)
- "Suggest an idempotent fix for install_nvim.sh to check for an existing neovim >= 0.11 and skip download if present."
- "Improve setup_nvim_config.sh: ensure it creates a backup before overwriting ~/.config/nvim and verify permissions after symlink."
- "Propose a small README addition showing how to run the Ansible playbook for Neovim on Ubuntu."

Repo notes (observed)
- Main areas: `neovim/`, `vim/`, `tmux/`, `dotfiles/` and Ansible playbooks.
- Neovim config is kickstart/lazy.nvim-style; copilot integration is documented and copilot is disabled by default in .vimrc in this repo.

If unsure
- Prefer suggestions as diffs or small patches and include explicit commands to test them locally.
- Ask the repo maintainer before changing personal configuration files in `dotfiles/`.

Thank you — help keep suggestions safe, reproducible, and easy to review.
