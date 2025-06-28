#!/bin/bash

set -e

# Prompt for OpenAI API key
read -p "Enter your OpenAI API key (sk-...): " OPENAI_KEY

# Write to .env file
mkdir -p ~/.config/bash_tmux_setup
cat > ~/.config/bash_tmux_setup/.env <<EOF
OPENAI_API_KEY="$OPENAI_KEY"
EOF

# Export API key for immediate use
export OPENAI_API_KEY="$OPENAI_KEY"

# Install dependencies
sudo apt update && sudo apt install -y   curl git tmux fzf zoxide unzip build-essential   fonts-powerline python3-pip

# Install Python packages
pip install --user openai aider-chat rich

# Install OxProto Nerd Font Mono
wget -O OxProto.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/OxProto.zip
unzip -o OxProto.zip -d OxProtoFonts
mkdir -p ~/.local/share/fonts
cp OxProtoFonts/*Mono*.ttf ~/.local/share/fonts/
fc-cache -fv

# Install Oh My Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

# Create ~/.bashrc
cat > ~/.bashrc <<'EOF'
OSH_THEME="powerline"

OSH_PLUGINS=(
  git
  aliases
  completion
  ssh
  bashmarks
  tmux-autoattach
  fzf
  zoxide
)

eval "$(zoxide init bash)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias ll='ls -alF'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gco='git checkout'
alias ..='cd ..'
alias zi='zoxide query -i'
alias zs='zoxide add $(pwd)'
alias ai='aider'

# Load OpenAI API key
if [ -f ~/.config/bash_tmux_setup/.env ]; then
  export $(cat ~/.config/bash_tmux_setup/.env | xargs)
fi

# Auto attach tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi
EOF

# Install ChatGPT CLI script from repo
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/padauker/bash-tmux-setup/main/scripts/chatgpt -o ~/.local/bin/chatgpt
chmod +x ~/.local/bin/chatgpt

# Create ~/.tmux.conf
cat > ~/.tmux.conf <<'EOF'
set -g mouse on
set -g history-limit 10000
set -g prefix C-a
unbind C-b
bind C-a send-prefix
set -g base-index 1
setw -g pane-base-index 1
set -g default-terminal "screen-256color"
setw -g xterm-keys on
set-option -g allow-rename off

set -g status-interval 5
set -g status-justify centre
set -g status-left-length 60
set -g status-right-length 120
set -g status-left "#[fg=cyan][#S]"
set -g status-right "#[fg=yellow]%Y-%m-%d #[fg=green]%H:%M #[fg=cyan]#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD 2>/dev/null)"

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'sainnhe/tmux-fzf'

set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'

bind-key a display-popup -E "aider"

run '~/.tmux/plugins/tpm/tpm'
EOF

clear
echo "✅ Terminal setup complete. Start tmux and press Ctrl+a then Shift+I to install plugins."
