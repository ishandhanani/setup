# PS1

export ME=$(whoami)

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
setopt PROMPT_SUBST
PS1='%F{magenta}ishan-mbp%f:%F{cyan}%~%f ${vcs_info_msg_0_}%F{green}$%f '

# Add colors to my ls output
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

#go bin
export PATH=$PATH:~/go/bin

# git aliases
alias gpr="git pull --rebase"
alias ga="git add"
alias gc="git commit -m"
alias gps="git push"
alias gs="git status"
alias gpl="git pull"
alias ll="ls -alh"
alias gco="git checkout"
alias gf="git fetch"
alias gcb="git checkout -b"
alias gp="git push"

# open up zshrc and edit alias
alias editz="vim ~/.zshrc"
alias sourcez="source ~/.zshrc"

# other aliases
alias c="cursor ."
alias speed="speedtest"
alias m="make"

# alt shell tools
alias cat="bat --style=plain"

# nav
alias godesk="cd /Users/$ME/Desktop"
alias godown="cd /Users/$ME/Downloads"

# cgpt
export ANTHROPIC_API_KEY=""
export GOOGLE_API_KEY=""

alias ai="cgpt -c"
alias gocgpt="cd ~/.cgpt"

# go dev
alias goi="go install ./..."

# git commit helpers
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

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
