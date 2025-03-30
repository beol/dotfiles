[[ -x "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"

export PATH=$HOME/bin:/usr/local/sbin:$PATH

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
    export PATH=$HOMEBREW_PREFIX/opt/openssl/bin:$PATH
    #export PATH=$HOMEBREW_PREFIX/opt/apr/bin:$PATH
    #export PATH=$HOMEBREW_PREFIX/opt/apr-util/bin:$PATH
    #export PATH=$HOMEBREW_PREFIX/opt/gpg-agent/bin:$PATH
    export PATH=$HOMEBREW_PREFIX/opt/node@20/bin:$PATH
    export PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
fi

if [[ -n "$SSH_AUTH_SOCK" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    ssh-add --apple-use-keychain -q 2>/dev/null
  else
    ssh-add -q 2>/dev/null
  fi
fi

if [[ -x "/usr/libexec/java_home" ]]; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

export PATH="$HOME/tools/maven/bin:$PATH"
export MAVEN_OPTS="-Xms2048m -Xmx2048m"

export JRUBY_OPTS="--dev -J-Xms2048m -J-Xmx2048m"

export PATH=$HOME/.docker/bin:$PATH

if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
    export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
