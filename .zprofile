if [[ "$(uname -o)" = "Darwin" ]]; then
    if [[ "$(uname -m)" = "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if [[ -n "$HOMEBREW_PREFIX" ]]; then 
        export PATH=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/binutils/bin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/curl/bin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/influxdb@1/bin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
        export PATH=$HOMEBREW_PREFIX/opt/node@20/bin:$PATH
    fi

    #[[ -n "$SSH_AUTH_SOCK" ]] && ssh-add --apple-use-keychain -q 2>/dev/null
    export SSH_AUTH_SOCK=~/.1password/agent.sock

    export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH

    export JAVA_HOME="$(/usr/libexec/java_home)"

    export PATH=/Users/beol/.local/pipx/venvs/ansible/bin:$PATH
else
    [[ -n "$SSH_AUTH_SOCK" ]] && ssh-add -q 2>/dev/null
fi

export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

[[ -d "$HOME/tools/maven/bin" ]] && export PATH="$HOME/tools/maven/bin:$PATH"
export MAVEN_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

[[ -d "$HOME/tools/gradle/bin" ]] && export PATH="$HOME/tools/gradle/bin:$PATH"
export GRADLE_OPTS="-Xms2048m -Xmx2048m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

export JRUBY_OPTS="--dev -J-Xms2048m -J-Xmx2048m"

export PATH=$HOME/.docker/bin:$PATH
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
