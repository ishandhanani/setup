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