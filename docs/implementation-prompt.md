# Implementation Task Prompts

This file provides structured prompts for implementing the improvements defined in `specifications.md`. Each prompt follows the **Task-Reference-Constraint** pattern for clarity and completeness.

---

## TASK-001: Remove External Network Calls from Tmux

**Specification Reference**: SPEC-001
**Issue Reference**: ISSUE-001
**Priority**: Critical
**Files**: `tmux/tmux.conf`

### Task
Remove all external network calls from tmux configuration by replacing `curl ipecho.net/plain` commands with local IP address detection or removing IP display entirely.

### Reference
- Current implementation: Lines 15 and 25 in `tmux/tmux.conf`
- Specification: See SPEC-001 in `docs/specifications.md`
- Assessment: See ISSUE-001 in `docs/assessment.md`

### Constraints
1. **Must**: Eliminate all external HTTP calls
2. **Must**: Maintain visual appearance of status bar
3. **Must**: Work without internet connection
4. **Must**: Be cross-platform compatible (macOS/Linux)
5. **Should**: Display local IP address as alternative
6. **Should**: Handle network interface detection gracefully
7. **Must Not**: Introduce performance degradation
8. **Must Not**: Create privacy leaks to third-party services

### Implementation Options
1. **Option A** (Recommended): Replace with local IP detection
2. **Option B**: Remove IP display completely
3. **Option C**: Create platform-aware helper script

### Verification Steps
```bash
# 1. Test tmux status bar appears correctly
tmux new -s test

# 2. Verify no network calls to ipecho.net
sudo tcpdump -i any host ipecho.net  # Should show nothing

# 3. Test offline functionality
# Disconnect network, tmux should still work normally

# 4. Verify performance
# Status bar should update without lag
```

### Success Criteria
- [ ] No external network calls detected
- [ ] Status bar displays correctly
- [ ] Works offline
- [ ] No performance impact
- [ ] Cross-platform tested

---

## TASK-002: Add Certificate File Existence Check

**Specification Reference**: SPEC-002
**Issue Reference**: ISSUE-002
**Priority**: High
**Files**: `shell/common/exports.sh`, `README.md`, `.gitignore`

### Task
Add conditional check to only set `NODE_EXTRA_CA_CERTS` when certificate file exists, document certificate usage, and prevent certificate files from being committed.

### Reference
- Current implementation: Line 35 in `shell/common/exports.sh`
- Specification: See SPEC-002 in `docs/specifications.md`
- Assessment: See ISSUE-002 in `docs/assessment.md`

### Constraints
1. **Must**: Check file existence before setting variable
2. **Must**: Document certificate purpose and usage
3. **Must**: Add `.crt` files to `.gitignore`
4. **Should**: Provide clear comments in code
5. **Must Not**: Break Node.js when certificate is present
6. **Must Not**: Cause errors when certificate is missing
7. **Must**: Maintain backward compatibility

### Implementation Steps
1. Wrap `NODE_EXTRA_CA_CERTS` export in conditional check
2. Add explanatory comment
3. Create certificate documentation section in README
4. Add `*.crt` to `.gitignore`

### Verification Steps
```bash
# 1. Test with certificate present
touch ~/.dotfiles/custom_ca.crt
source ~/.zshrc
echo $NODE_EXTRA_CA_CERTS  # Should show path

# 2. Test with certificate absent
rm ~/.dotfiles/custom_ca.crt
source ~/.zshrc
echo $NODE_EXTRA_CA_CERTS  # Should be empty, no errors

# 3. Test Node.js functionality
node -e "console.log('Certificate:', process.env.NODE_EXTRA_CA_CERTS)"
```

### Success Criteria
- [ ] Variable only set when file exists
- [ ] No errors when file missing
- [ ] Documentation added to README
- [ ] `.crt` files in `.gitignore`
- [ ] Node.js works in both scenarios

---

## TASK-003: Fix Git Configuration Typo

**Specification Reference**: SPEC-004
**Issue Reference**: ISSUE-004
**Priority**: Low
**Files**: `git/gitconfig`

### Task
Fix typo in git mergetool configuration: change `leepBackup` to `keepBackup`.

### Reference
- Current implementation: Line 36 in `git/gitconfig`
- Specification: See SPEC-004 in `docs/specifications.md`
- Assessment: See ISSUE-004 in `docs/assessment.md`

### Constraints
1. **Must**: Correct the typo
2. **Must**: Maintain existing configuration intent
3. **Should**: Verify git accepts the corrected configuration

### Implementation Steps
1. Edit `git/gitconfig` line 36
2. Change `leepBackup` to `keepBackup`
3. Verify git configuration is valid

### Verification Steps
```bash
# 1. Check configuration is valid
git config --get mergetool.p4merge.keepBackup

# 2. Verify git doesn't show warnings
git config --list 2>&1 | grep -i error
```

### Success Criteria
- [ ] Typo corrected
- [ ] Git configuration valid
- [ ] No warnings or errors

---

## TASK-004: Move User Information to Local Config

**Specification Reference**: SPEC-003
**Issue Reference**: ISSUE-003
**Priority**: Medium
**Files**: `git/gitconfig`, `git/gitconfig.local.template`, `install.sh`, `README.md`, `.gitignore`

### Task
Remove personal user information from tracked files and create a template-based system for user-specific git configuration.

### Reference
- Current implementation: Lines 2-3 in `git/gitconfig`
- Specification: See SPEC-003 in `docs/specifications.md`
- Assessment: See ISSUE-003 in `docs/assessment.md`

### Constraints
1. **Must**: Remove personal information from tracked files
2. **Must**: Create template file for user configuration
3. **Must**: Update install script to prompt for configuration
4. **Must**: Document the setup process
5. **Must**: Add `.gitconfig.local` to `.gitignore`
6. **Should**: Maintain backward compatibility
7. **Must Not**: Break git functionality

### Implementation Steps
1. Create `git/gitconfig.local.template` with examples
2. Remove or comment user section from `git/gitconfig`
3. Update `install.sh` to prompt for local config setup
4. Add documentation to README
5. Add `.gitconfig.local` to `.gitignore`

### Verification Steps
```bash
# 1. Test install script prompts correctly
./install.sh

# 2. Verify template exists and is useful
cat git/gitconfig.local.template

# 3. Test git configuration works
git config --get user.name
git config --get user.email

# 4. Verify include mechanism works
git config --list | grep -A2 "user\."
```

### Success Criteria
- [ ] No personal info in tracked files
- [ ] Template file created with examples
- [ ] Install script prompts for setup
- [ ] Documentation complete
- [ ] `.gitconfig.local` in `.gitignore`
- [ ] Git works correctly

---

## TASK-005: Fix Disk Detection in Sysinfo

**Specification Reference**: SPEC-005
**Issue Reference**: ISSUE-005
**Priority**: Medium
**Files**: `bin/sysinfo`

### Task
Replace hard-coded disk name detection with root filesystem query that works across different disk configurations and platforms.

### Reference
- Current implementation: Line 20 in `bin/sysinfo`
- Specification: See SPEC-005 in `docs/specifications.md`
- Assessment: See ISSUE-005 in `docs/assessment.md`

### Constraints
1. **Must**: Work on macOS (Intel and ARM)
2. **Must**: Work on Linux
3. **Must**: Handle different filesystem types (APFS, HFS+, ext4)
4. **Should**: Maintain output format consistency
5. **Should**: Handle detection failures gracefully
6. **Must Not**: Hard-code disk names

### Implementation Steps
1. Replace `grep disk1s1` with root filesystem query
2. Use `df -h / | tail -1` for universal detection
3. Test output format matches expected pattern
4. Verify cross-platform compatibility

### Verification Steps
```bash
# 1. Test on current system
./bin/sysinfo | grep "Disk:"

# 2. Verify output format
# Should show: "XX.XG / XX.XG (XX% used)"

# 3. Test on Linux (if available)
# Should work without modification

# 4. Test edge cases
# External boot drives, unusual configurations
```

### Success Criteria
- [ ] Works on macOS (Intel/ARM)
- [ ] Works on Linux
- [ ] Output format consistent
- [ ] Handles all filesystem types
- [ ] No hard-coded disk names

---

## TASK-006: Add Dependency Validation to Functions

**Specification Reference**: SPEC-006
**Issue Reference**: ISSUE-006
**Priority**: Medium
**Files**: `shell/common/functions.sh`

### Task
Add dependency validation to shell functions that call external tools, providing clear error messages and installation suggestions when tools are missing.

### Reference
- Current implementation: `shell/common/functions.sh`
- Specification: See SPEC-006 in `docs/specifications.md`
- Assessment: See ISSUE-006 in `docs/assessment.md`

### Constraints
1. **Must**: Validate all required dependencies
2. **Must**: Provide clear, actionable error messages
3. **Should**: Suggest installation commands for missing tools
4. **Should**: Be cross-platform aware
5. **Must Not**: Break existing functionality
6. **Must Not**: Add significant performance overhead
7. **Should**: Use consistent error message format

### Functions to Update
1. `extract()` - Check for: unrar, 7z, bunzip2
2. `dataurl()` - Check for: openssl, file
3. `fshow()` - Check for: fzf, git
4. `getcertnames()` - Check for: openssl

### Implementation Steps
1. Add `command_exists()` helper function
2. Update `extract()` with per-format validation
3. Update `dataurl()` with dependency checks
4. Update `fshow()` with fzf validation
5. Update `getcertnames()` with openssl check
6. Test each function with missing dependencies

### Verification Steps
```bash
# 1. Test with all dependencies present
extract test.zip
dataurl test.txt
fshow

# 2. Test with dependencies missing
# Temporarily rename commands to simulate missing tools
# Should show helpful error messages with install suggestions

# 3. Test error message clarity
# Error messages should be clear and actionable
```

### Success Criteria
- [ ] All functions validate dependencies
- [ ] Clear error messages displayed
- [ ] Installation suggestions provided
- [ ] Cross-platform compatible messages
- [ ] No breaking changes
- [ ] Performance impact minimal

---

## TASK-007: Respect User's Default Shell in Tmux

**Specification Reference**: SPEC-007
**Issue Reference**: ISSUE-007
**Priority**: Medium
**Files**: `tmux/tmux.conf`

### Task
Replace hard-coded shell path with `$SHELL` environment variable to respect user's preferred shell.

### Reference
- Current implementation: Line 33 in `tmux/tmux.conf`
- Specification: See SPEC-007 in `docs/specifications.md`
- Assessment: See ISSUE-007 in `docs/assessment.md`

### Constraints
1. **Must**: Use `$SHELL` environment variable
2. **Must**: Work with any shell (zsh, bash, fish, etc.)
3. **Should**: Handle edge cases gracefully
4. **Must Not**: Hard-code shell paths

### Implementation Steps
1. Edit `tmux/tmux.conf` line 33
2. Replace `/bin/zsh` with `$SHELL`
3. Test with multiple shells
4. Verify tmux sessions use correct shell

### Verification Steps
```bash
# 1. Test with current shell
echo $SHELL
tmux new -s test
echo $SHELL  # Should match

# 2. Test with different shell
SHELL=/bin/bash tmux new -s test_bash
echo $SHELL  # Should be bash

# 3. Verify no hard-coded paths remain
grep -n "/bin/zsh" tmux/tmux.conf  # Should return nothing
```

### Success Criteria
- [ ] Uses `$SHELL` variable
- [ ] Works with multiple shells
- [ ] No hard-coded paths
- [ ] Tmux sessions use correct shell

---

## TASK-008: Document and Make Memory Settings Configurable

**Specification Reference**: SPEC-008
**Issue Reference**: ISSUE-008
**Priority**: Medium
**Files**: `shell/common/exports.sh`, `README.md`

### Task
Make Java/JVM memory settings configurable through environment variables and document how to customize them for different system configurations.

### Reference
- Current implementation: Lines 15-21 in `shell/common/exports.sh`
- Specification: See SPEC-008 in `docs/specifications.md`
- Assessment: See ISSUE-008 in `docs/assessment.md`

### Constraints
1. **Must**: Allow environment variable override
2. **Must**: Maintain default values (2048m)
3. **Must**: Document customization process
4. **Should**: Explain rationale for defaults
5. **Should**: Provide guidance for different RAM amounts
6. **Must**: Maintain backward compatibility
7. **Must Not**: Break existing configurations

### Implementation Steps
1. Add `JAVA_HEAP_SIZE` configurable variable
2. Update Maven, Gradle, JRuby options to use variable
3. Add comments explaining configuration
4. Document in README with examples
5. Test with different heap sizes

### Verification Steps
```bash
# 1. Test with default settings
source ~/.zshrc
echo $MAVEN_OPTS  # Should show 2048m

# 2. Test with custom heap size
export JAVA_HEAP_SIZE="1024m"
source ~/.zshrc
echo $MAVEN_OPTS  # Should show 1024m

# 3. Verify Maven/Gradle still work
mvn --version
gradle --version
```

### Success Criteria
- [ ] Memory settings configurable
- [ ] Defaults remain 2048m
- [ ] Documentation complete
- [ ] Examples for different RAM amounts
- [ ] Backward compatible
- [ ] Maven/Gradle/JRuby work correctly

---

## TASK-009: Validate 1Password Socket Path

**Specification Reference**: SPEC-009
**Issue Reference**: ISSUE-009
**Priority**: Low-Medium
**Files**: `shell/common/exports.sh`

### Task
Add existence check to only set SSH_AUTH_SOCK for 1Password when the socket file actually exists.

### Reference
- Current implementation: Lines 30-33 in `shell/common/exports.sh`
- Specification: See SPEC-009 in `docs/specifications.md`
- Assessment: See ISSUE-009 in `docs/assessment.md`

### Constraints
1. **Must**: Check socket existence before setting
2. **Must**: Use socket test (`-S`) not just file test
3. **Must Not**: Break SSH for users without 1Password
4. **Must Not**: Break SSH for users with 1Password
5. **Should**: Add explanatory comment

### Implementation Steps
1. Edit `shell/common/exports.sh` lines 30-33
2. Add socket existence check using `-S` test
3. Update comment to explain conditional
4. Test with and without 1Password

### Verification Steps
```bash
# 1. Test with 1Password installed
ls -l ~/.1password/agent.sock
source ~/.zshrc
echo $SSH_AUTH_SOCK  # Should show 1Password path

# 2. Test without 1Password
# Temporarily remove socket
source ~/.zshrc
echo $SSH_AUTH_SOCK  # Should show default or empty

# 3. Verify SSH functionality
ssh-add -l  # Should work in both cases
```

### Success Criteria
- [ ] Socket only set when it exists
- [ ] Uses `-S` test for sockets
- [ ] SSH works with 1Password
- [ ] SSH works without 1Password
- [ ] No breaking changes

---

## Batch Implementation Prompt

For implementing all tasks in sequence:

```
I need to implement the improvements identified in the dotfiles assessment.
Please implement the following tasks in order:

Phase 1 (Critical - 30 minutes):
- TASK-001: Remove external network calls from tmux
- TASK-002: Add certificate file existence check
- TASK-003: Fix git configuration typo

Phase 2 (High Priority - 45 minutes):
- TASK-004: Move user information to local config
- TASK-009: Validate 1Password socket path
- TASK-007: Respect user's default shell in tmux

Phase 3 (Medium Priority - 60 minutes):
- TASK-005: Fix disk detection in sysinfo
- TASK-008: Document memory settings
- TASK-006: Add dependency validation to functions

For each task:
1. Read the specification in docs/specifications.md
2. Review the constraints carefully
3. Implement the changes
4. Run the verification steps
5. Confirm all success criteria are met

References:
- Assessment: docs/assessment.md
- Specifications: docs/specifications.md
- Implementation Prompts: docs/implementation-prompt.md (this file)
```

---

## Individual Task Execution Template

When working on a single task:

```
I need to implement [TASK-XXX: Task Name].

Context:
- Specification: See SPEC-XXX in docs/specifications.md
- Assessment: See ISSUE-XXX in docs/assessment.md
- Files to modify: [list files]

Please:
1. Read the complete specification
2. Review all constraints
3. Implement the solution
4. Run verification steps
5. Confirm success criteria

After implementation, provide:
- Summary of changes made
- Verification results
- Any issues encountered
- Next steps if applicable
```

---

## Notes

- All tasks reference detailed specifications in `docs/specifications.md`
- All issues reference detailed assessment in `docs/assessment.md`
- Follow the priority order for optimal results
- Test each task thoroughly before proceeding to the next
- Total estimated time: ~2.5 hours for all tasks
- Can be implemented incrementally or as a batch
