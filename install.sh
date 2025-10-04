#!/bin/bash
set -euo pipefail

# ----- Packages (Arch) -----
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
  git curl tmux fzf zoxide unzip base-devel \
  bmon btop python python-pip

# ----- JetBrainsMono Nerd Font (repo first, fallback to zip) -----
if pacman -Si nerd-fonts-jetbrains-mono >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm nerd-fonts-jetbrains-mono
else
  tmpdir="$(mktemp -d)"
  pushd "$tmpdir" >/dev/null
  curl -L -o JetBrainsMono.zip \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  mkdir -p ~/.local/share/fonts
  unzip -o JetBrainsMono.zip -d ~/.local/share/fonts
  fc-cache -fv
  popd >/dev/null
  rm -rf "$tmpdir"
fi

# ----- Tmux Plugin Manager -----
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ----- Oh My Bash (non-interactive) -----
export OSH="${HOME}/.oh-my-bash"
if [ ! -d "$OSH" ]; then
  git clone https://github.com/ohmybash/oh-my-bash.git "$OSH"
fi

# Backup existing bashrc
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d%H%M%S)

# ----- Append to ~/.bashrc (Arch fzf paths) -----
cat >> ~/.bashrc <<'EOF'
# ===== Oh My Bash =====
export OSH="$HOME/.oh-my-bash"
OSH_THEME="powerline"
plugins=(
  git
  aliases
  completion
  ssh
  fzf
  # zoxide plugin not in OMB core; init separately below
)
source "$OSH/oh-my-bash.sh"

# ===== zoxide + fzf =====
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi
# Arch fzf scripts:
[ -r /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -r /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
# Fallback (if installed from upstream script)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ===== Aliases =====
alias ll='ls -alF'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gco='git checkout'
alias ..='cd ..'
alias zi='zoxide query -i'
alias zs='zoxide add "$(pwd)"'

# ===== Auto-attach tmux (skip non-interactive/VSCode/SSH forced commands) =====
if command -v tmux >/dev/null 2>&1 \
   && [ -z "$TMUX" ] \
   && [[ $- == *i* ]] \
   && [ -z "${VSCODE_GIT_IPC_HANDLE:-}" ] \
   && [ -z "${VSCODE_INJECTION:-}" ]; then
  tmux attach -t default 2>/dev/null || tmux new -s default
fi
EOF

# ----- ~/.tmux.conf -----
cat > ~/.tmux.conf <<'EOF'
set -g mouse on
set -g history-limit 10000

# Prefix
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Indexing
set -g base-index 1
setw -g pane-base-index 1

# Terminfo: prefer tmux-256color if present
if-shell 'infocmp -x tmux-256color >/dev/null 2>&1' 'set -g default-terminal "tmux-256color"' 'set -g default-terminal "screen-256color"'
setw -g xterm-keys on
set -g allow-rename off

# Status line
set -g status-interval 5
set -g status-justify centre
set -g status-left-length 60
set -g status-right-length 120
set -g status-left "#[fg=cyan][#S]"
set -g status-right "#[fg=yellow]%Y-%m-%d #[fg=green]%H:%M #[fg=cyan]#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD 2>/dev/null)"

# Plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-yank'
# set -g @plugin 'sainnhe/tmux-fzf'  # optional

set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'

run '~/.tmux/plugins/tpm/tpm'
EOF

clear
echo "✅ Terminal setup complete (Arch)."
echo "💡 Run: source ~/.bashrc"
echo "💡 In tmux: Ctrl+a then Shift+I to install plugins."
echo "💡 Select the JetBrainsMono Nerd Font in your terminal settings."
