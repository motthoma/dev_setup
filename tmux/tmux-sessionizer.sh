#!/usr/bin/env bash
# tmux-sessionizer.sh
# Purpose: Quickly attach or create tmux sessions for a directory

# --- Select a directory ---
selected=$(find ~/ -mindepth 1 -maxdepth 2 -type d | fzf)
if [[ -z "$selected" ]]; then
    exit 0
fi

# --- Generate a safe tmux session name ---
selected_name=$(basename "$selected" | tr ":, .-" "___")

# --- Function to attach or switch ---
switch_to() {
    if [[ -z "$TMUX" ]]; then
        # Not inside tmux: attach session
        tmux attach-session -t "$selected_name"
    else
        # Inside tmux: switch client to the session
        tmux switch-client -t "$selected_name"
    fi
}

# --- Check if the session exists ---
if tmux has-session -t "$selected_name" 2>/dev/null; then
    switch_to
    exit 0
fi

# --- Create a new detached session in the selected directory ---
tmux new-session -ds "$selected_name" -c "$selected"

# --- Optional: send an initial command inside the session ---
# For example, your "ready-tmux" script or any initialization
if [[ -x "$selected/ready-tmux" ]]; then
    tmux send-keys -t "$selected_name" "./ready-tmux" C-m
fi

# --- Attach or switch to the new session ---
switch_to
