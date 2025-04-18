#!/bin/sh
# Common aliases for both bash and zsh

# Directory listing
alias ll="ls -l"
alias la="ls -alF"

# macOS specific
if [[ "$(uname -o)" = "Darwin" ]]; then
    # DNS cache management
    alias flushdnscache="sudo killall -HUP mDNSResponder"
    alias restartmdns="sudo sh -c 'killall -STOP mDNSResponder && killall -CONT mDNSResponder'"
    
    # Homebrew
    alias brewup="brew update && brew upgrade"
fi

# Git shortcuts
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias ga="git add"
alias gb="git branch"
alias gco="git checkout"
