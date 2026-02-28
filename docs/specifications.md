# Improvement Specifications

This document provides detailed technical specifications for implementing the improvements identified in the assessment.

---

## SPEC-001: Remove External Network Calls from Tmux

**Issue Reference**: ISSUE-001
**Priority**: Critical
**Effort**: 15 minutes
**Risk**: Low

### Current Behavior
Tmux configuration makes external HTTP calls to `ipecho.net` every 5 seconds to display public IP address in the status bar and window title.

### Requirements

#### Functional Requirements
1. Remove all external network calls from tmux configuration
2. Display local IP address instead of public IP (or remove IP display)
3. Maintain status bar visual appearance and layout
4. Ensure tmux remains responsive without network dependency

#### Non-Functional Requirements
- No performance degradation
- No privacy leaks to third-party services
- Works offline
- Cross-platform compatible (macOS/Linux)

### Technical Design

#### Option A: Use Local IP Address (Recommended)
```bash
# macOS
set -g set-titles-string '#(whoami)::#h::#(ipconfig getifaddr en0 2>/dev/null || echo "offline")'
set -g status-left "#[fg=Green]#(whoami)#[fg=White]::#[fg=Cyan]#(hostname -s)#[fg=White]::#[fg=Yellow]#(ipconfig getifaddr en0 2>/dev/null || echo 'N/A') "

# Linux alternative
set -g status-left "#[fg=Green]#(whoami)#[fg=White]::#[fg=Cyan]#(hostname -s)#[fg=White]::#[fg=Yellow]#(hostname -I | cut -d' ' -f1 || echo 'N/A') "
```

#### Option B: Remove IP Display (Simpler)
```bash
set -g set-titles-string '#(whoami)::#h'
set -g status-left "#[fg=Green]#(whoami)#[fg=White]::#[fg=Cyan]#(hostname -s) "
```

#### Option C: Platform-Aware Solution
Create a helper script that detects platform and returns appropriate local IP.

### Implementation Steps
1. Back up current `tmux/tmux.conf`
2. Choose implementation option (recommend A or B based on user preference)
3. Update lines 15 and 25 in `tmux/tmux.conf`
4. Test in new tmux session: `tmux new -s test`
5. Verify status bar displays correctly
6. Verify no network calls: `sudo tcpdump -i any host ipecho.net` (should show nothing)

### Testing
```bash
# Start new tmux session
tmux new -s test

# Verify status bar shows correctly
# Check for network calls (should be none)
sudo tcpdump -i any host ipecho.net

# Test offline behavior
# Disconnect network, status bar should still work
```

### Acceptance Criteria
- [ ] No external HTTP calls made by tmux
- [ ] Status bar displays correctly
- [ ] Window title displays correctly
- [ ] Works without internet connection
- [ ] No performance degradation
- [ ] Cross-platform compatible

---

## SPEC-002: Add Certificate File Existence Check

**Issue Reference**: ISSUE-002
**Priority**: High
**Effort**: 5 minutes
**Risk**: Low

### Current Behavior
`NODE_EXTRA_CA_CERTS` environment variable is set unconditionally to a certificate file path that may not exist, causing Node.js errors.

### Requirements

#### Functional Requirements
1. Only set `NODE_EXTRA_CA_CERTS` if certificate file exists
2. Provide clear documentation about certificate purpose
3. Add template or example for certificate setup
4. Fail gracefully when certificate is missing

#### Non-Functional Requirements
- No impact on Node.js when certificate is present
- No errors when certificate is missing
- Backward compatible for existing users

### Technical Design

#### Implementation
```bash
# shell/common/exports.sh (line 35)
# Node.js custom CA certificate (for corporate/self-signed certificates)
# Only set if certificate file exists
if [[ -f "$HOME/.dotfiles/custom_ca.crt" ]]; then
    export NODE_EXTRA_CA_CERTS="$HOME/.dotfiles/custom_ca.crt"
fi
```

#### Documentation Addition
Add to README.md:
```markdown
### Custom Certificate Authority (Optional)

If you need Node.js to trust a custom CA certificate (e.g., corporate or self-signed):

1. Place your certificate file in the dotfiles directory:
   ```bash
   cp your-ca-cert.crt ~/.dotfiles/custom-ca.crt
   ```

2. Update `shell/common/exports.sh` to reference your certificate:
   ```bash
   export NODE_EXTRA_CA_CERTS="$HOME/.dotfiles/custom-ca.crt"
   ```
```

### Implementation Steps
1. Edit `shell/common/exports.sh` line 35
2. Add conditional check for file existence
3. Add comment explaining purpose
4. Update README.md with certificate documentation
5. Add `.crt` files to `.gitignore` to prevent accidental commit

### Testing
```bash
# Test with certificate present
touch ~/.dotfiles/custom_ca.crt
source ~/.zshrc
echo $NODE_EXTRA_CA_CERTS  # Should show path

# Test with certificate absent
rm ~/.dotfiles/custom_ca.crt
source ~/.zshrc
echo $NODE_EXTRA_CA_CERTS  # Should be empty

# Test Node.js behavior
node -e "console.log(process.env.NODE_EXTRA_CA_CERTS)"
```

### Acceptance Criteria
- [ ] Variable only set when file exists
- [ ] No errors when file is missing
- [ ] Node.js works correctly in both scenarios
- [ ] Certificate documented in README
- [ ] `.crt` files added to `.gitignore`

---

## SPEC-003: Move User Information to Local Config

**Issue Reference**: ISSUE-003
**Priority**: Medium
**Effort**: 10 minutes
**Risk**: Low

### Current Behavior
Personal user information (name and email) is hard-coded in `git/gitconfig`, exposing personal data in the repository.

### Requirements

#### Functional Requirements
1. Remove personal information from tracked files
2. Create template for user-specific configuration
3. Update install script to guide user setup
4. Maintain backward compatibility

#### Non-Functional Requirements
- Git continues to work correctly
- Clear instructions for new users
- Easy to set up

### Technical Design

#### Update git/gitconfig
```ini
# Remove or comment out:
# [user]
#     name = Leo Laksmana
#     email = beol@example.com

# Keep the include (already present):
[include]
    path = ~/.gitconfig.local
```

#### Create git/gitconfig.local.template
```ini
# ~/.gitconfig.local template
# Copy this file to ~/.gitconfig.local and update with your information
#
# cp ~/.dotfiles/git/gitconfig.local.template ~/.gitconfig.local

[user]
    name = Your Name
    email = your.email@example.com

# Add any other machine-specific git configuration here
# Examples:
# [credential]
#     helper = osxkeychain  # macOS
#     # helper = cache      # Linux
```

#### Update install.sh
Add after line 98 (after git symlinks):
```bash
# Check for .gitconfig.local
if [ ! -f "$HOME/.gitconfig.local" ]; then
    echo -e "${YELLOW}Note:${NC} Please create ~/.gitconfig.local with your user information"
    echo "Template available at: $DOTFILES_DIR/git/gitconfig.local.template"
    read -p "Would you like to copy the template now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$DOTFILES_DIR/git/gitconfig.local.template" "$HOME/.gitconfig.local"
        echo -e "${GREEN}Template copied.${NC} Please edit ~/.gitconfig.local with your information."
    fi
fi
```

### Implementation Steps
1. Create `git/gitconfig.local.template`
2. Remove or comment user section from `git/gitconfig`
3. Update `install.sh` with setup prompt
4. Update README.md with instructions
5. Add `gitconfig.local` to `.gitignore`

### Testing
```bash
# Test git configuration still works
git config --get user.name
git config --get user.email

# Test include works
git config --list | grep user

# Test install script prompts correctly
./install.sh
```

### Acceptance Criteria
- [ ] No personal information in tracked files
- [ ] Template file created with examples
- [ ] Install script prompts for configuration
- [ ] Git works correctly with local config
- [ ] Documentation updated
- [ ] `.gitconfig.local` in `.gitignore`

---

## SPEC-004: Fix Git Configuration Typo

**Issue Reference**: ISSUE-004
**Priority**: Low
**Effort**: 2 minutes
**Risk**: None

### Current Behavior
Typo in `git/gitconfig` line 36: `leepBackup` should be `keepBackup`

### Requirements
Fix typo to ensure merge tool configuration works correctly.

### Technical Design
```ini
# git/gitconfig line 36
# Before:
    leepBackup = false

# After:
    keepBackup = false
```

### Implementation Steps
1. Edit `git/gitconfig` line 36
2. Change `leepBackup` to `keepBackup`
3. Test git mergetool configuration

### Testing
```bash
git config --get mergetool.p4merge.keepBackup
# Should return: false
```

### Acceptance Criteria
- [ ] Typo corrected
- [ ] Git mergetool configuration valid

---

## SPEC-005: Fix Disk Detection in Sysinfo

**Issue Reference**: ISSUE-005
**Priority**: Medium
**Effort**: 15 minutes
**Risk**: Low

### Current Behavior
`bin/sysinfo` hard-codes `disk1s1` for disk detection, which fails on many systems.

### Requirements

#### Functional Requirements
1. Detect root filesystem correctly on all systems
2. Work with APFS, HFS+, ext4, etc.
3. Provide fallback for detection failure
4. Cross-platform compatibility

### Technical Design

#### Option A: Use Root Filesystem (Recommended)
```bash
# macOS and Linux compatible
DISK=$(df -h / | tail -1 | awk '{print $4 " / " $2 " (" $5 " used)"}')
```

#### Option B: Try Primary Disk, Fall Back to Root
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Try to find boot disk, fall back to root
    DISK=$(df -h / | tail -1 | awk '{print $4 " / " $2 " (" $5 " used)"}')
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DISK=$(df -h / | tail -1 | awk '{print $4 " / " $2 " (" $5 " used)"}')
else
    DISK="Unknown"
fi
```

### Implementation Steps
1. Edit `bin/sysinfo` line 20
2. Replace hard-coded `disk1s1` with root filesystem query
3. Test on different systems
4. Verify output format matches

### Testing
```bash
# Test on macOS
./bin/sysinfo

# Test on Linux (if available)
./bin/sysinfo

# Verify output format
# Should show: "XX.XG / XX.XG (XX% used)"
```

### Acceptance Criteria
- [ ] Works on macOS (Intel and ARM)
- [ ] Works on Linux
- [ ] Shows correct disk usage
- [ ] Graceful handling if detection fails

---

## SPEC-006: Add Dependency Validation to Functions

**Issue Reference**: ISSUE-006
**Priority**: Medium
**Effort**: 30 minutes
**Risk**: Low

### Current Behavior
Shell functions call external tools without checking if they exist, resulting in cryptic error messages.

### Requirements

#### Functional Requirements
1. Validate dependencies before use
2. Provide clear error messages
3. Suggest installation commands when possible
4. Non-breaking for functions that work

#### Non-Functional Requirements
- Minimal performance impact
- Helpful error messages
- Cross-platform compatible

### Technical Design

#### Pattern for Dependency Checking
```bash
# Helper function
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Usage in functions
extract() {
    if [ ! -f "$1" ]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.rar)
            if ! command_exists unrar; then
                echo "Error: unrar is required but not installed"
                echo "Install: brew install unrar  # macOS"
                return 1
            fi
            unrar e "$1"
            ;;
        *.7z)
            if ! command_exists 7z; then
                echo "Error: 7z is required but not installed"
                echo "Install: brew install p7zip  # macOS"
                return 1
            fi
            7z x "$1"
            ;;
        # ... other cases
    esac
}
```

#### Functions to Update
1. `extract()` - Check for unrar, 7z, bunzip2
2. `dataurl()` - Check for openssl, file
3. `fshow()` - Check for fzf, git
4. `getcertnames()` - Check for openssl

### Implementation Steps
1. Add `command_exists()` helper at top of `shell/common/functions.sh`
2. Update `extract()` with per-format validation
3. Update `dataurl()` with dependency check
4. Update `fshow()` with fzf check
5. Update `getcertnames()` with openssl check
6. Test each function with and without dependencies

### Testing
```bash
# Test with dependencies present
extract test.zip
dataurl test.txt
fshow

# Test with dependencies missing (rename commands temporarily)
# Should show helpful error messages
```

### Acceptance Criteria
- [ ] All functions validate dependencies
- [ ] Clear error messages for missing tools
- [ ] Installation suggestions provided
- [ ] No breaking changes for working functions
- [ ] Cross-platform error messages

---

## SPEC-007: Respect User's Default Shell in Tmux

**Issue Reference**: ISSUE-007
**Priority**: Medium
**Effort**: 5 minutes
**Risk**: Low

### Current Behavior
Tmux hard-codes `/bin/zsh` as default shell, ignoring user preference.

### Requirements
1. Respect user's `$SHELL` environment variable
2. Work with any shell (zsh, bash, fish, etc.)
3. Handle missing shell gracefully

### Technical Design

```bash
# tmux/tmux.conf line 33
# Before:
set -g default-command /bin/zsh

# After:
set -g default-shell $SHELL
```

### Implementation Steps
1. Edit `tmux/tmux.conf` line 33
2. Replace hard-coded path with `$SHELL` variable
3. Test with different shells
4. Verify tmux respects shell setting

### Testing
```bash
# Test with current shell
echo $SHELL
tmux new -s test
echo $SHELL  # Should match

# Test behavior with different SHELL
SHELL=/bin/bash tmux new -s test_bash
```

### Acceptance Criteria
- [ ] Tmux uses `$SHELL` variable
- [ ] Works with zsh, bash, and other shells
- [ ] No hard-coded paths

---

## SPEC-008: Document Memory Settings

**Issue Reference**: ISSUE-008
**Priority**: Medium
**Effort**: 20 minutes
**Risk**: Low

### Current Behavior
Maven, Gradle, and JRuby memory settings are hard-coded at 2GB without documentation or easy configuration.

### Requirements

#### Functional Requirements
1. Document memory settings and rationale
2. Provide way to override settings
3. Consider system constraints
4. Maintain performance for power users

#### Non-Functional Requirements
- Easy to customize
- Clear documentation
- Backward compatible

### Technical Design

#### Add Configuration Variables
```bash
# shell/common/exports.sh

# Java/JVM Memory Settings
# Customize these based on your system's available RAM
# Default: 2048m (2GB) - suitable for systems with 8GB+ RAM
# For systems with less RAM, consider: 1024m (1GB) or 512m
JAVA_HEAP_SIZE="${JAVA_HEAP_SIZE:-2048m}"

# Maven options
export MAVEN_OPTS="-Xms${JAVA_HEAP_SIZE} -Xmx${JAVA_HEAP_SIZE} -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Gradle options
export GRADLE_OPTS="-Xms${JAVA_HEAP_SIZE} -Xmx${JAVA_HEAP_SIZE} -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# JRuby options
export JRUBY_OPTS="--dev -J-Xms${JAVA_HEAP_SIZE} -J-Xmx${JAVA_HEAP_SIZE}"
```

#### Add README Documentation
```markdown
### Java/JVM Memory Configuration

The default memory settings allocate 2GB heap size for Maven, Gradle, and JRuby.
This is suitable for systems with 8GB+ RAM.

To customize for your system, set the `JAVA_HEAP_SIZE` variable before sourcing dotfiles:

```bash
# Add to ~/.zshenv or ~/.bashrc before dotfiles are sourced
export JAVA_HEAP_SIZE="1024m"  # For systems with 4-8GB RAM
export JAVA_HEAP_SIZE="512m"   # For systems with <4GB RAM
```
```

### Implementation Steps
1. Update `shell/common/exports.sh` with configurable variable
2. Add documentation to README.md
3. Test with different heap sizes
4. Verify Maven/Gradle/JRuby work correctly

### Testing
```bash
# Test with default
source ~/.zshrc
echo $MAVEN_OPTS

# Test with custom size
export JAVA_HEAP_SIZE="1024m"
source ~/.zshrc
echo $MAVEN_OPTS  # Should show 1024m
```

### Acceptance Criteria
- [ ] Memory settings configurable via environment variable
- [ ] Defaults remain at 2GB
- [ ] Documentation explains customization
- [ ] Backward compatible

---

## SPEC-009: Validate 1Password Socket Path

**Issue Reference**: ISSUE-009
**Priority**: Low-Medium
**Effort**: 5 minutes
**Risk**: Low

### Current Behavior
SSH agent socket is set to 1Password path unconditionally, breaking SSH for users without 1Password.

### Requirements
1. Only set SSH_AUTH_SOCK if 1Password socket exists
2. Don't break existing SSH agent configuration
3. Document 1Password integration

### Technical Design

```bash
# shell/common/exports.sh (lines 30-33)
# 1Password SSH agent (macOS only)
# Only set if 1Password socket exists
if [[ "$(uname -s)" = "Darwin" ]] && [[ -S "$HOME/.1password/agent.sock" ]]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
fi
```

### Implementation Steps
1. Edit `shell/common/exports.sh` lines 30-33
2. Add socket existence check using `-S` test
3. Add comment explaining conditional
4. Test with and without 1Password

### Testing
```bash
# Test with 1Password installed
ls -l ~/.1password/agent.sock
source ~/.zshrc
echo $SSH_AUTH_SOCK  # Should show 1Password path

# Test without 1Password
rm ~/.1password/agent.sock  # Temporarily
source ~/.zshrc
echo $SSH_AUTH_SOCK  # Should show default or empty

# Test SSH still works
ssh-add -l
```

### Acceptance Criteria
- [ ] Socket only set if file exists and is a socket
- [ ] SSH works with 1Password present
- [ ] SSH works with 1Password absent
- [ ] No breaking changes to SSH functionality

---

## Implementation Priority Matrix

| Spec | Priority | Effort | Risk | Order |
|------|----------|--------|------|-------|
| SPEC-001 | Critical | 15min | Low | 1 |
| SPEC-002 | High | 5min | Low | 2 |
| SPEC-004 | Low | 2min | None | 3 |
| SPEC-003 | Medium | 10min | Low | 4 |
| SPEC-009 | Low-Med | 5min | Low | 5 |
| SPEC-007 | Medium | 5min | Low | 6 |
| SPEC-005 | Medium | 15min | Low | 7 |
| SPEC-008 | Medium | 20min | Low | 8 |
| SPEC-006 | Medium | 30min | Low | 9 |

**Total Estimated Effort**: ~2 hours
**Recommended Approach**: Implement in order, test each before proceeding
