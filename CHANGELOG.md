# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Pre-flight check in `install.sh` to enforce Oh My Zsh installation.
- Comprehensive usage, keybindings, and troubleshooting sections to `README.md`.

### Fixed

- Documentation inaccuracies in `README.md` regarding shell loading order, OS-specific manual installation steps, and git configuration filenames.
- Critical macOS compatibility issues by replacing `uname -o` with `uname -s`.
- Infinite recursion loop in Bash startup configuration.
- `server` alias compatibility with Python 3.
- Destructive `PATH` reset in Tmux sessions.

### Changed

- Standardized indentation in `git/gitconfig` to 4 spaces.
- Simplified `.gitignore` to focus strictly on repository-specific files.

### Removed

- Unused `git/config` and backup files.
