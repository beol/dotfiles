#!/bin/zsh
# Zsh profile for login shells

# Source common configuration files
for file in $HOME/.dotfiles/shell/common/{path,exports,aliases,functions}.sh; do
    [ -r "$file" ] && source "$file"
done

# Source machine-specific local overrides (not tracked by repo)
[ -r "$HOME/.shell_local.sh" ] && source "$HOME/.shell_local.sh"
