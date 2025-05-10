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

# ai 
alias ai="cgpt"
alias qq="cgpt -no-history"

# eza
alias ls='eza --color=always --group-directories-first'
alias ll='eza -lh --color=always --group-directories-first'
alias la='eza -la --color=always --group-directories-first' # All files
alias ltree='eza --tree --level=3 --color=always' # Tree view
