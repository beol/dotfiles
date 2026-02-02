# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that manages shell configurations for Zsh and Bash, along with Git, Tmux, and Ruby settings. It uses a DRY (Don't Repeat Yourself) architecture with shared configuration between shells.

## Installation & Testing

### Initial Setup
```bash
# Install the dotfiles
./install.sh
```

The install script:
- Checks for Oh My Zsh (required dependency)
- Creates timestamped backups in `~/.dotfiles_backup/YYYYMMDD_HHMMSS/`
- Creates symlinks for all configuration files
- Detects OS (macOS/Linux) and creates appropriate links

### Testing Changes
After modifying dotfiles, reload the configuration:
```bash
# Zsh
source ~/.zshrc

# Bash
source ~/.bashrc
```

To test the installation script without affecting the system, review the symlinks it creates but note that it will require user interaction for existing files.

## Architecture

### Configuration Loading Flow

The repository uses a centralized configuration approach where common settings are shared between shells:

**Zsh Loading Sequence:**
1. `~/.zshenv` → Sets `ZDOTDIR=$HOME/.dotfiles/zsh`
2. `$ZDOTDIR/.zprofile` → Sources common config files (path, exports, aliases, functions)
3. `$ZDOTDIR/.zshrc` → Sources `shell/zsh_specific.sh`

**Bash Loading Sequence:**
1. `~/.bash_profile` (macOS) or `~/.bashrc` (Linux)
2. `~/.bashrc` → Sources common config files (path, exports, aliases, functions)
3. `~/.bashrc` → Sources `shell/bash_specific.sh`

### Directory Structure

```
shell/
├── common/              # Shared configuration for all shells
│   ├── path.sh         # PATH setup with Homebrew detection (Intel/ARM)
│   ├── exports.sh      # Environment variables
│   ├── aliases.sh      # Command aliases
│   └── functions.sh    # Shell functions
├── bash_specific.sh    # Bash: prompt, completion, history
└── zsh_specific.sh     # Zsh: Oh My Zsh, plugins, theme

zsh/                    # Zsh entry points (these set ZDOTDIR)
├── .zshenv            # Only this needs to be symlinked to ~/
├── .zprofile          # Sources common config
└── .zshrc             # Sources zsh_specific.sh

bash/                   # Bash entry points
├── bash_profile       # macOS: sources bashrc
├── bashrc             # Sources common config + bash_specific
└── inputrc            # Readline configuration

git/
├── gitconfig          # Main git config with aliases
└── gitignore          # Global ignore patterns

tmux/
└── tmux.conf          # Tmux configuration

ruby/
└── gemrc              # Ruby gem settings

bin/
└── sysinfo            # System information display script
```

## Key Implementation Details

### PATH Management (`shell/common/path.sh`)
- Detects macOS architecture (Intel vs ARM) for Homebrew paths
- Intel Macs: `/usr/local/bin/brew`
- Apple Silicon: `/opt/homebrew/bin/brew`
- Adds GNU tools, Homebrew tools, and development tools to PATH
- Supports RVM, Maven, Gradle, VS Code, and Docker
- Custom bin directories: `~/.dotfiles/bin`, `~/bin`, `~/.local/bin`

### Shell-Specific Configurations

**Zsh** (`shell/zsh_specific.sh`):
- Uses Oh My Zsh framework (required dependency)
- Theme: `robbyrussell`
- Includes 30+ plugins (git, aws, brew, docker, python, ruby, etc.)
- Optional Homebrew plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Vi mode with `jj` to escape insert mode
- History: 10,000 entries with sharing across sessions

**Bash** (`shell/bash_specific.sh`):
- Git-aware prompt via `git-prompt.sh`
- Bash completion for various tools (aws, git)
- Vi mode with `jj` to escape insert mode
- History: 10,000 entries with deduplication
- Special handling to avoid PATH issues in Tmux sessions

### Git Configuration
- Global ignore file: `~/.dotfiles/git/gitignore`
- Includes `~/.gitconfig.local` for machine-specific settings
- Default branch: `main`
- Aliases: `co`, `in`, `br`, `st`, `ci`, `fe`, `pu`
- Merge/diff tools: p4merge, vimdiff
- Line endings: LF, no autocrlf

### Symlink Strategy
Only `~/.zshenv` needs to be symlinked to the home directory for Zsh. All other Zsh files (`.zshrc`, `.zprofile`) remain in `~/.dotfiles/zsh/` because `ZDOTDIR` redirects Zsh to that directory.

## Making Changes

### Adding New Aliases or Functions
- **Aliases**: Edit `shell/common/aliases.sh` (affects both shells)
- **Functions**: Edit `shell/common/functions.sh` (affects both shells)
- **Shell-specific**: Edit `shell/bash_specific.sh` or `shell/zsh_specific.sh`

### Adding New Environment Variables
Edit `shell/common/exports.sh` for variables needed by both shells.

### Modifying PATH
Edit `shell/common/path.sh`. Be aware of the architecture detection logic for macOS Homebrew.

### Testing Cross-Shell Compatibility
When modifying common configuration files, test in both Bash and Zsh to ensure compatibility. Use POSIX-compliant syntax in common files.

## Important Notes

- Oh My Zsh is a **required dependency** - the install script will fail without it
- The install script is idempotent - running it multiple times is safe
- All backups are timestamped and preserved in `~/.dotfiles_backup/`
- Machine-specific Git config should go in `~/.gitconfig.local` (included automatically)
- The `.gitignore` in this repository is for the dotfiles repo itself, not the global gitignore
- When working in Tmux, be careful with PATH modifications to avoid overwriting dotfiles settings
