export ME=$(whoami)

# Gruvbox Dark Colors
local c_user="#fabd2f"          # Yellow
local c_at="#928374"            # Dark Gray (for @)
local c_host="#d3869b"          # Magenta
local c_colon="#928374"         # Dark Gray (for :)
local c_path="#83a598"          # Aqua
local c_git_branch="#b8bb26"    # Green
local c_prompt_symbol="#fe8019" # Orange
local c_default_text="#ebdbb2"  # Default Text

# Load edit-cmd-line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Add colors to ls output (macOS/BSD ls)
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Zsh specific aliases
alias editz="vim ~/.zshrc"
alias sourcez="source ~/.zshrc"

# nav (macOS specific paths)
alias godesk="cd /Users/$ME/Desktop"
alias godown="cd /Users/$ME/Downloads"

# Sourcing an external env file if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

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

# ip util
alias myip="curl -s icanhazip.com"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

eval "$(starship init zsh)"
