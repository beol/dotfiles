#!/bin/zsh
# Zsh profile for login shells

# Source common configuration files
for file in $HOME/.dotfiles/shell/common/{path,exports,aliases,functions}.sh; do
    [ -r "$file" ] && source "$file"
done
