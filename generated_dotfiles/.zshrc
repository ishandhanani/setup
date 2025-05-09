# This file is auto-generated. Do not edit directly.
# Generated from common_rc/zsh_specifics.sh and common_rc/common_shell_config.sh.
# Zsh PS1 Configuration
export ME=$(whoami)

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
setopt PROMPT_SUBST
PS1='%F{magenta}ishan-mbp%f:%F{cyan}%~%f ${vcs_info_msg_0_}%F{green}$%f '

# Add colors to ls output (macOS/BSD ls)
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Zsh specific aliases
alias editz="vim ~/.zshrc"
alias sourcez="source ~/.zshrc"

# macOS specific aliases & settings
alias speed="speedtest"
alias m="make"

# nav (macOS specific paths)
alias godesk="cd /Users/$ME/Desktop"
alias godown="cd /Users/$ME/Downloads"

# Sourcing an external env file if it exists
. "$HOME/.local/bin/env"

# --- Common Shell Configuration ---
# Common Shell Configuration (for both Bash and Zsh)

# Exports
export EDITOR='vim'
export VISUAL='vim'
export GPG_TTY=$(tty) 

# Git aliases
alias gpr="git pull --rebase"
alias ga="git add"
alias gc="git commit -m"
alias gps="git push"
alias gs="git status"
alias gpl="git pull"
alias gf="git fetch"
alias gcb="git checkout -b"
alias gp="git push"

# Other common aliases
alias v="vim ."
alias ll="ls -alh"
alias d="docker"
alias dc="docker compose"
alias k="kubectl"
alias m="make"
alias c="cursor ."
alias speed="speedtest"
alias cat="bat --style=plain"

# eza
alias ls='eza --color=always --group-directories-first'
alias ll='eza -lh --color=always --git --group-directories-first'
alias la='eza -la --color=always --git --group-directories-first' # All files
alias ltree='eza --tree --level=3 --color=always' # Tree view
