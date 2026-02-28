#!/bin/sh
# Common PATH modifications for both bash and zsh

# Add dotfiles bin directory to PATH
export PATH=$HOME/.dotfiles/bin:$PATH

# Add user bin directory to PATH
export PATH=$HOME/bin:$PATH

# macOS specific PATH modifications
if [[ "$(uname -s)" = "Darwin" ]]; then
    # Set up Homebrew based on architecture (Intel vs ARM)
    if [[ "$(uname -m)" = "arm64" ]]; then
        if [[ -x "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        if [[ -x "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    # Set up Homebrew tools if HOMEBREW_PREFIX is set
    if [[ -n "$HOMEBREW_PREFIX" ]]; then
        # GNU tools
        [[ -d "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]] && export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
        
        # Other tools
        [[ -d "$HOMEBREW_PREFIX/opt/binutils/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/binutils/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/curl/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/curl/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/influxdb@1/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/influxdb@1/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/openssl/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/openssl/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/apr/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/apr/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/apr-util/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/apr-util/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/gpg-agent/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/gpg-agent/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
        [[ -d "$HOMEBREW_PREFIX/opt/node@24/bin" ]] && export PATH=$HOMEBREW_PREFIX/opt/node@24/bin:$PATH
    fi

    # Add VS Code to PATH
    [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH

    # Set JAVA_HOME
    if [[ -x "/usr/libexec/java_home" ]]; then
        export JAVA_HOME="$(/usr/libexec/java_home)"
    fi
fi

# Maven
[[ -d "$HOME/tools/maven/bin" ]] && export PATH="$HOME/tools/maven/bin:$PATH"

# Gradle
[[ -d "$HOME/tools/gradle/bin" ]] && export PATH="$HOME/tools/gradle/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

[[ -d "$HOME/.docker/bin" ]] && export PATH="$HOME/.docker/bin:$PATH"

# Load RVM into a shell session as a function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
