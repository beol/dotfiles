#!/bin/sh
# Common environment variables for both bash and zsh

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor
export EDITOR='vim'

# Java options
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

# Maven options
export MAVEN_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Gradle options
export GRADLE_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# JRuby options
export JRUBY_OPTS="--dev -J-Xms2048m -J-Xmx2048m"

# Terminal colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# GPG configuration
export GPG_TTY=$(tty)

# 1Password SSH agent (macOS only)
if [[ "$(uname -s)" = "Darwin" ]]; then
    export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

export NODE_EXTRA_CA_CERTS=$HOME/.dotfiles/LaksmanaFamily_Root_CA.crt
