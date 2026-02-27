# 🧠 tmux Cheat Sheet

### 🏁 Prefix Key
Most tmux commands start with:
```
Ctrl + b    # (written as C-b)
```

---

## 🧩 Sessions
| Action | Command |
|--------|----------|
| New session | `tmux new -s mysession` |
| Detach from session | `C-b d` |
| List sessions | `tmux ls` |
| Attach to session | `tmux attach -t mysession` |
| Rename session | `C-b $` |
| Kill session | `tmux kill-session -t mysession` |
| Kill all sessions | `tmux kill-server` |

---

## 🪟 Windows (tabs within a session)
| Action | Command |
|--------|----------|
| New window | `C-b c` |
| Next window | `C-b n` |
| Previous window | `C-b p` |
| Go to window by number | `C-b <number>` |
| Rename window | `C-b ,` |
| Close (kill) window | `C-b &` |

---

## 🧱 Panes (splits within a window)
| Action | Command |
|--------|----------|
| Split horizontally (top/bottom) | `C-b "` |
| Split vertically (left/right) | `C-b %` |
| Switch pane | `C-b o` |
| Switch to last active pane | `C-b ;` |
| Move with arrow keys | `C-b ↑ / ↓ / ← / →` |
| Resize pane | `C-b :resize-pane -U/D/L/R <n>` |
| Kill current pane | `C-b x` |

---

## 🚀 Navigation & Copy Mode
| Action | Command |
|--------|----------|
| Enter copy/scroll mode | `C-b [` |
| Exit copy mode | `q` |
| Start text selection | `Space` |
| Copy selection | `Enter` |
| Paste | `C-b ]` |

---

## ⚙️ Swap Tabs 
| Action | Command |
|--------|----------|
| Swap current window with left | `C-b :swap-window -t -1` |
| Swap current window with right | `C-b :swap-window -t +1` |
| Swap window X with window Y | `C-b :swap-window -s <X> -t <Y>` |

---

## ⚙️ Pane & Window Management
| Action | Command |
|--------|----------|
| Synchronize panes (type in all) | `C-b :setw synchronize-panes on` |
| Turn off sync | `C-b :setw synchronize-panes off` |
| List all key bindings | `C-b ?` |

---

## 🧭 Quick Workflow Example
```bash
tmux new -s work      # start session
C-b %                 # split vertically
C-b "                 # split horizontally
C-b arrow             # move between panes
C-b d                 # detach
tmux attach -t work   # re-attach later
```

---

## 💡 Pro Tips
- Prefix key too slow? Speed up key repeats:
  ```bash
  set -sg escape-time 0
  ```
- Change prefix to Ctrl + a (like GNU screen):
  ```bash
  set -g prefix C-a
  unbind C-b
  bind C-a send-prefix
  ```
