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