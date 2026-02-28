#!/bin/zsh
# ZSH-specific configurations

# Path to your oh-my-zsh installation
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    alias-finder
    aws
    brew
    bundler
    colorize
    gem
    git-flow
    git-prompt
    git
    gpg-agent
    history
    mvn
    nmap
    node
    npm
    pip
    python
    rsync
    ruby
    rvm
    tmux
    vi-mode
    virtualenv
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Source zsh-specific plugins if Homebrew is available
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    # Check if the files exist before sourcing them
    [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    
    [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# User configuration
export MANPATH="/usr/local/share/man:$MANPATH"

# Vi mode
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

# Prompt customization
setopt PROMPT_SUBST
autoload -Uz vcs_info
precmd() {
    print -rP "%{$fg[green]%}%m%{$reset_color%} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)"
}
PROMPT="%(?:%{%}➜ :%{%}➜ )"
unset RPROMPT

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt incappendhistory

