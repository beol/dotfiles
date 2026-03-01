#!/bin/sh
# Common environment variables for both bash and zsh

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor
export EDITOR='vim'

# Java options
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

# JVM build tool heap settings (2 GB initial/max for fast compilation)
# -Xms: initial heap size  -Xmx: max heap size
# -XX:+TieredCompilation -XX:TieredStopAtLevel=1: use interpreter-only mode
#   to minimize JVM startup time at the cost of peak throughput
# Override any of these in ~/.shell_local.sh for machines with less RAM,
# e.g.: export MAVEN_OPTS="-Xms512m -Xmx1024m"
export MAVEN_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export GRADLE_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export JRUBY_OPTS="--dev -J-Xms2048m -J-Xmx2048m"

# Terminal colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# GPG configuration
export GPG_TTY=$(tty)

# 1Password SSH agent (macOS only, socket must exist)
if [[ "$(uname -s)" = "Darwin" ]] && [[ -S "$HOME/.1password/agent.sock" ]]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
fi

[ -f "$HOME/.dotfiles/custom_ca.crt" ] && export NODE_EXTRA_CA_CERTS="$HOME/.dotfiles/custom_ca.crt"

export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_DISABLE_ANALYTICS=1
