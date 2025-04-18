#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Backup directory
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to create symlink
create_symlink() {
    local src="$1"
    local dst="$2"
    
    # Check if the destination already exists
    if [ -e "$dst" ]; then
        # If it's already a symlink to our file, do nothing
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            echo -e "${BLUE}Link already exists:${NC} $dst -> $src"
            return
        fi
        
        # Backup the existing file
        echo -e "${YELLOW}Backing up:${NC} $dst -> $BACKUP_DIR/$(basename "$dst")"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    fi
    
    # Check if destination still exists (backup might have failed)
    if [ -e "$dst" ]; then
        echo -e "${YELLOW}Warning:${NC} $dst still exists after backup attempt."
        read -p "Force create symlink? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Forcing symlink creation:${NC} $dst -> $src"
            ln -sf "$src" "$dst"
        else
            echo -e "${YELLOW}Skipping:${NC} $dst"
            return
        fi
    else
        # Create the symlink normally
        echo -e "${GREEN}Creating link:${NC} $dst -> $src"
        ln -s "$src" "$dst"
    fi
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Detect OS
OS=$(detect_os)
echo -e "${BLUE}Detected OS:${NC} $OS"

# Create symlinks
echo -e "\n${BLUE}Creating symlinks...${NC}"

# ZSH - only need to symlink .zshenv since it sets ZDOTDIR
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
# No need for these symlinks as zsh will find them in $ZDOTDIR:
# create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
# create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"

# Bash
if [[ "$OS" == "macos" ]]; then
    create_symlink "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"
    create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
elif [[ "$OS" == "linux" ]]; then
    create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
fi

# Git
create_symlink "$DOTFILES_DIR/git/config" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/ignore" "$HOME/.gitignore"

# Ruby
create_symlink "$DOTFILES_DIR/ruby/gemrc" "$HOME/.gemrc"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Readline
create_symlink "$DOTFILES_DIR/bash/inputrc" "$HOME/.inputrc"

echo -e "\n${GREEN}Done!${NC} Your dotfiles have been installed."
echo -e "Backup of previous dotfiles can be found in: ${YELLOW}$BACKUP_DIR${NC}"
