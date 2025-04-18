# Dotfiles

A collection of configuration files for various tools and shells.

## Features

- **Shell Configurations**: ZSH and Bash configurations with useful aliases and functions
- **Git Configuration**: Aliases, colors, and useful defaults
- **Tmux Configuration**: Custom keybindings and status bar
- **Ruby Configuration**: Gem settings
- **Cross-platform Support**: Works on macOS and Linux
- **DRY Configuration**: Shared configuration between Bash and Zsh

## Directory Structure

```
.dotfiles/
├── bash/           # Bash-specific configuration files
├── bin/            # Executable scripts
├── git/            # Git configuration files
├── ruby/           # Ruby configuration files
├── shell/          # Shared shell configurations
│   ├── common/     # Common configuration files for all shells
│   │   ├── aliases.sh    # Common aliases
│   │   ├── exports.sh    # Common environment variables
│   │   ├── functions.sh  # Common shell functions
│   │   └── path.sh       # Common PATH setup
│   ├── bash_specific.sh  # Bash-specific settings
│   └── zsh_specific.sh   # Zsh-specific settings
├── tmux/           # Tmux configuration files
├── zsh/            # ZSH-specific configuration files (with leading dots)
├── install.sh      # Installation script
└── README.md       # This file
```

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/beol/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the installation script

```bash
./install.sh
```

This will:

- Create symbolic links for all configuration files
- Backup any existing configuration files
- Detect your OS and create the appropriate links

## Manual Installation

If you prefer to create the symlinks manually, you can do so with the following commands:

```bash
# ZSH - only need to symlink .zshenv since it sets ZDOTDIR
ln -s ~/.dotfiles/zsh/.zshenv ~/.zshenv
# No need for these symlinks as zsh will find them in $ZDOTDIR:
# ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
# ln -s ~/.dotfiles/zsh/.zprofile ~/.zprofile

# Git
ln -s ~/.dotfiles/git/config ~/.gitconfig
ln -s ~/.dotfiles/git/ignore ~/.gitignore

# Ruby
ln -s ~/.dotfiles/ruby/gemrc ~/.gemrc

# Tmux
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# Bash
ln -s ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/bash/bashrc ~/.bashrc
ln -s ~/.dotfiles/bash/inputrc ~/.inputrc
```

## Configuration Structure

### Shared Configuration

The repository uses a DRY (Don't Repeat Yourself) approach to shell configuration:

1. **Common Files**: Located in `shell/common/` directory, these files are sourced by both Bash and Zsh:

   - `path.sh`: PATH setup, including Homebrew paths with architecture detection
   - `exports.sh`: Common environment variables
   - `aliases.sh`: Common command aliases
   - `functions.sh`: Useful shell functions

2. **Shell-Specific Files**: Located in the `shell/` directory:

   - `bash_specific.sh`: Bash-specific settings (prompt, completion, etc.)
   - `zsh_specific.sh`: Zsh-specific settings (Oh My Zsh, plugins, etc.)

3. **Loading Order**:
   - Zsh: `~/.zshenv` → sets ZDOTDIR → `$ZDOTDIR/.zprofile` (sources common files) → `$ZDOTDIR/.zshrc` (sources zsh_specific.sh)
   - Bash: `~/.bash_profile` (sources common files and bash_specific.sh) → `~/.bashrc`

## Customization

- **Machine-specific Git**: Create a `~/.gitconfig.local` file, which will be included automatically
- **Shell Functions**: Add your own functions to the common functions file
- **Aliases**: Add your own aliases to the common aliases file
