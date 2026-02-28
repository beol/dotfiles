# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Local override mechanism: `shell/local.template.sh` and `git/gitconfig.local.template`
  provide templates for machine-specific settings (API proxy URLs, work credentials,
  per-machine PATH entries) that should never be committed to the shared repo.
- `zsh/.zprofile` and `bash/bashrc` now source `~/.shell_local.sh` after shared config,
  mirroring the existing `.gitconfig.local` pattern for git.
- Certificate and key file patterns (`*.crt`, `*.pem`, `*.key`, `*.p12`, `*.pfx`) added
  to `.gitignore` to prevent accidental credential commits.
- `.credentials` and `.shell_local.sh` added to `.gitignore`.
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` and `CLAUDE_CODE_DISABLE_ANALYTICS`
  exported in `exports.sh`.
- Source `~/.credentials` in `zsh/.zshrc` for secrets not tracked in the repo.
- Assessment, specifications, and implementation docs added to `docs/`.
- Pre-flight check in `install.sh` to enforce Oh My Zsh installation.
- Comprehensive usage, keybindings, and troubleshooting sections to `README.md`.

### Fixed

- Replaced external `curl ipecho.net` calls in `tmux/tmux.conf` with local `ifconfig`
  to eliminate continuous privacy leak and offline breakage (ISSUE-001).
- Added file existence guard (`[ -f ]`) to `NODE_EXTRA_CA_CERTS` in `exports.sh` so
  Node.js does not error on machines without the custom certificate (ISSUE-002).
- Removed personal `[user]` block from `git/gitconfig`; identity must now be set in
  `~/.gitconfig.local` using the new template (ISSUE-003).
- Fixed `leepBackup` typo to `keepBackup` in `git/gitconfig` merge tool config (ISSUE-004).
- Fixed macOS disk detection in `bin/sysinfo` to use `df -h /` instead of hard-coded
  `grep disk1s1`, which fails on Apple Silicon and non-default volumes (ISSUE-005).
- Replaced hard-coded `/bin/zsh` with `$SHELL` in `tmux/tmux.conf` so tmux respects
  the user's default shell (ISSUE-007).
- Added `-S` socket existence check to the 1Password `SSH_AUTH_SOCK` export so SSH
  agent is not broken on Macs without 1Password installed (ISSUE-009).
- Documentation inaccuracies in `README.md` regarding shell loading order, OS-specific
  manual installation steps, and git configuration filenames.
- Critical macOS compatibility issues by replacing `uname -o` with `uname -s`.
- Infinite recursion loop in Bash startup configuration.
- `server` alias compatibility with Python 3.
- Destructive `PATH` reset in Tmux sessions.

### Changed

- `ANTHROPIC_BASE_URL` removed from `exports.sh`; it belongs in `~/.shell_local.sh`
  as a machine-specific LAN proxy setting.
- Bumped `node@20` to `node@24` in `shell/common/path.sh`.
- Standardized indentation in `git/gitconfig` to 4 spaces.
- Simplified `.gitignore` to focus strictly on repository-specific files.

### Removed

- Unused `git/config` and backup files.
