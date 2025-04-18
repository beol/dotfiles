#!/bin/bash
# Bash-specific configurations

# Source system bashrc if it exists
[[ -s /etc/bashrc ]] && source /etc/bashrc

# Bash completion
if [[ "$(uname -o)" = "Darwin" ]]; then
    # macOS specific completions
    if [[ -n "$HOMEBREW_PREFIX" ]]; then
        [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    else
        [[ -s /usr/local/etc/bash_completion ]] && source "/usr/local/etc/bash_completion"
    fi
else
    # Linux completions
    [[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
fi

# Git prompt
[[ -s /usr/local/etc/bash_completion.d/git-prompt.sh ]] && source "/usr/local/etc/bash_completion.d/git-prompt.sh"

# AWS completion
[[ -x /usr/local/bin/aws_completer ]] && complete -C /usr/local/bin/aws_completer aws

# Git prompt configuration
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PROMPT_COMMAND='__git_ps1 "\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]" "\\\$ "'

# Vi mode for bash
set -o vi
bind '"jj":vi-movement-mode'

# History settings
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# TMUX specific settings
if [ -n "${TMUX}" ]; then
    unset PATH
    . /etc/profile
fi
