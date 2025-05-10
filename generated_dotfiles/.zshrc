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

# git commit helpers
function git_ai_commit() {
    if ! git diff --cached --quiet; then
        # Send the prompt to cgpt via stdin but redirect stderr to /dev/null
        # This way we only capture the actual response
        commit_msg=$(cgpt --no-history << EOF 2>/dev/null
Generate a semantic commit message following the format: type(scope): description
Common types: feat, fix, docs, style, refactor, test, chore
Here are the staged files:
$(git diff --cached --name-only)
And here are the changes:
$(git diff --cached)
Respond ONLY with the commit message, nothing else. Make it concise and descriptive.
EOF
)
        echo "$commit_msg"
        git commit -m "$commit_msg" > /dev/null 2>&1
    else
        echo "No staged changes"
    fi
}

alias gcai="git_ai_commit"

function gprai() {
  local current_branch base_ref branch_diff changed_files pr_prompt pr_content

  # 1) figure out current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # 2) pick the main ref (prefer origin/main, fall back to local main)
  if git show-ref --verify --quiet refs/remotes/origin/main; then
    base_ref=origin/main
  elif git show-ref --verify --quiet refs/heads/main; then
    base_ref=main
  else
    echo "Error: 'main' branch not found locally or on origin."
    return 1
  fi

  # 3) get diff + file list
  branch_diff=$(git diff "$base_ref...$current_branch")
  changed_files=$(git diff --name-only "$base_ref...$current_branch")

  # 4) build the prompt
  pr_prompt=$(cat <<EOF
Generate a PR title and description based on these changes.
Use semantic format: type(scope): description
Common types: feat, fix, docs, style, refactor, test, chore

Files changed:
$changed_files

Diff:
$branch_diff

Respond *exactly* in this format:

TITLE: <type(scope): concise summary>
DESCRIPTION:
## Overview
<one‐ or two‐sentence high‐level summary>
## Changes Made
- <bullet points of specific changes>
EOF
  )

  # 5) call cgpt
  pr_content=$(cgpt --no-history <<EOF
$pr_prompt
EOF
  )

  # 6) output only the AI response
  printf "%s\n" "$pr_content"
}

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
