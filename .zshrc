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

# vim 
alias v="vim ."

# go bin
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
    # Get current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    # Get base branch (assuming main/master)
    base_branch="main"
    if ! git rev-parse --verify main >/dev/null 2>&1; then
        base_branch="master"
    fi
    
    # Get all changes between base branch and current branch
    branch_diff=$(git diff $base_branch...$current_branch)
    changed_files=$(git diff --name-only $base_branch...$current_branch)
    
    # Get all commits in this branch
    commit_messages=$(git log $base_branch..$current_branch --pretty=format:"%s")
    
    pr_prompt=$(cat << EOF
Generate a PR title and description based on these changes. Try to make the PR title indicative of all changes
For the PR title, use semantic versioning format: type(scope): description
Common types: feat, fix, docs, style, refactor, test, chore
The changes are in these files:
$changed_files
Here are all the commits:
$commit_messages
Here are the actual changes:
$branch_diff
Provide output in exactly this format:
TITLE: <semantic version title>
DESCRIPTION:
## Overview
<high level description of the changes>
## Changes Made
<bullet points of specific changes>
Be concise but descriptive in your response.
EOF
)
    # Generate PR content using cgpt
    pr_content=$(cgpt --no-history << EOF 2>/dev/null
$pr_prompt
EOF
)
    echo "$pr_content"
}


. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
