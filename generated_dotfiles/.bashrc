# This file is auto-generated. Do not edit directly.
# Generated from common_rc/bash_specifics.sh and common_rc/common_shell_config.sh.
# Bash-specific settings

# Git aware prompt (Bash-specific)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# PS1 with git aware branching
export PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ " 

# Editing rc's
alias editb="vim ~/.bashrc"
alias sourceb="source ~/.bashrc"

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
