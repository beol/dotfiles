#!/bin/zsh
# Zsh configuration for interactive shells
[ -r "$HOME/.credentials" ] && source "${HOME}/.credentials"

# Source zsh-specific configuration
[ -r "$HOME/.dotfiles/shell/zsh_specific.sh" ] && source "$HOME/.dotfiles/shell/zsh_specific.sh"
