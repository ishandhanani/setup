# This file is auto-generated. Do not edit directly.
# Generated from common_rc/bash_specifics.sh and common_rc/common_shell_config.sh.
# Bash-specific settings

# Gruvbox Dark Colors (for reference in PS1)
# FG_DEFAULT="#ebdbb2"
# USER_COLOR="#fabd2f"      # Yellow
# HOST_COLOR="#d3869b"      # Magenta
# PATH_COLOR="#83a598"      # Aqua
# GIT_BRANCH_COLOR="#b8bb26" # Green
# PROMPT_SYMBOL_COLOR="#fe8019" # Orange
# SEPARATOR_COLOR="#928374"   # Dark Gray

# Function to get current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' # No color here, just the branch name in parens
}

# Define color escape sequences
C_USER='\[\033[38;2;250;189;47m\]'   # Yellow: fabd2f
C_AT='\[\033[38;2;146;131;116m\]'    # Dark Gray: 928374 (for @)
C_HOST='\[\033[38;2;211;134;155m\]' # Magenta: d3869b
C_COLON='\[\033[38;2;146;131;116m\]'  # Dark Gray: 928374 (for :)
C_PATH='\[\033[38;2;131;165;152m\]' # Aqua: 83a598
C_GIT_BRANCH='\[\033[38;2;184;187;38m\]' # Green: b8bb26
C_PROMPT_SYMBOL='\[\033[38;2;254;128;25m\]' # Orange: fe8019
C_DEFAULT_TEXT='\[\033[38;2;235;219;178m\]' # Default Text: ebdbb2
C_RESET='\[\033[0m\]'

# PS1 with Gruvbox colors and git aware branching
# Structure: user@host:path (git_branch) $
export PS1="${C_USER}\u${C_AT}@${C_HOST}\h${C_COLON}:${C_PATH}\w${C_RESET} ${C_GIT_BRANCH}\$(parse_git_branch)${C_DEFAULT_TEXT} ${C_PROMPT_SYMBOL}\$ ${C_RESET}"

# Editing rc's
alias editb="vim ~/.bashrc"
alias sourceb="source ~/.bashrc"

# --- Common Shell Configuration ---
# Common Shell Configuration (for both Bash and Zsh)

# Exports
export EDITOR='vim'
export VISUAL='vim'
export GPG_TTY=$(tty) 

# path
export PATH=$PATH:$HOME/go/bin

# Git aliases
alias gpr="git pull --rebase"
alias ga="git add"
alias gc="git commit"
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

# ai 
alias ai="cgpt"
alias qq="cgpt -no-history"

# brev
alias brs="brev refresh && brev ls"

# eza
alias ls='eza --color=always --group-directories-first'
alias ll='eza -la --color=always --group-directories-first'
alias ltree='eza --tree --level=3 --color=always' # Tree view

# ip util
alias myip="curl -s icanhazip.com"
