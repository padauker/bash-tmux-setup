# Bash + Tmux Developer Terminal Setup

This repo contains a complete and modern Bash terminal environment designed for productivity, clarity, and tmux integration.

## ✨ Features

- **oh-my-bash** with `powerline` theme for a clean, informative prompt
- **0xProto Nerd Font Mono** for perfect Powerline and icon rendering
- **fzf** for fast fuzzy search of history, files, and directories
- **zoxide** as a smarter `cd` replacement
- **tmux** with TPM and plugins:
  - `tmux-resurrect` for saving sessions
  - `tmux-continuum` for auto-restore
  - `tmux-prefix-highlight` for prefix visual cue
  - `tmux-yank` for clipboard integration
  - `tmux-fzf` for fast pane/window switching
- **Git integration** in prompt and tmux bar
- **Local ChatGPT CLI integration** for AI assistance
- **Aider** AI-powered pair programming assistant via terminal
- Auto tmux session attach

## 🔧 Installation (One-liner)
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/padauker/bash-tmux-setup/main/install.sh)"
```

## 🗂 Files Included
- `install.sh` — Full terminal setup script
- `.bashrc` — Aliases, plugin setup, and auto-tmux attach
- `.tmux.conf` — tmux config with plugins
- `chatgpt` — Optional CLI script for OpenAI-powered AI assistant

## 📸 Screenshot
Coming soon...

## 📋 Keyboard Shortcuts
- `Ctrl+a ,` → Rename tmux window
- `Ctrl+a d` → Detach session
- `Ctrl+a Ctrl-s` → Save session
- `Ctrl+a Ctrl-r` → Restore session
- `Ctrl+r` → Fuzzy search command history (fzf)
- `zi` → Fuzzy jump to recently used dir (zoxide)
- `prefix + a` → Open Aider assistant in tmux popup (if bound)

## 📦 Dependencies
Tested on Debian/Ubuntu:
```bash
sudo apt install curl git tmux fzf zoxide unzip build-essential fonts-powerline python3-pip
pip install openai aider-chat
```

## 🤖 AI Assistant CLI (Optional)
A CLI script for OpenAI chat is automatically installed as `~/.local/bin/chatgpt`.

Example:
```bash
chatgpt "Explain how tmux copy mode works"
```

Supports:
- Streaming output
- Multiline prompts via stdin
- Configured via `~/.config/bash_tmux_setup/.env`

## 🧠 Aider Integration (Optional)
Install Aider:
```bash
pip install aider-chat
```

Optional alias in `.bashrc`:
```bash
alias ai="aider"
```

To launch inside tmux popup:
```tmux
bind-key a display-popup -E "aider"
```

Then use:
```bash
ai src/  # to chat with files in your repo
```

## ✅ Post-Install
After install, start tmux and press:
```
Ctrl+a then Shift+I
```
to install all plugins via TPM.

---

Contributions welcome! PRs to add new plugins or themes are appreciated.
