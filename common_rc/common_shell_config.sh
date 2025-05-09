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
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -lh --icons --color=always --git --group-directories-first'
alias la='eza -la --icons --color=always --git --group-directories-first' # All files
alias ltree='eza --tree --level=3 --icons --color=always' # Tree view
