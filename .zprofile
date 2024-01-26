export PATH=$HOME/bin:/usr/local/sbin:$PATH

if [[ -x "/usr/local/bin/brew" ]]; then 
    export BREW_PREFIX=$(brew --prefix)
    export PATH=$BREW_PREFIX/opt/influxdb@1/bin:$BREW_PREFIX/opt/openssl/bin:$BREW_PREFIX/opt/apr/bin:$BREW_PREFIX/opt/apr-util/bin:$BREW_PREFIX/opt/gpg-agent/bin:$BREW_PREFIX/opt/node@16/bin:$BREW_PREFIX/opt/ruby/bin:$PATH
fi

[[ -n "$SSH_AUTH_SOCK" ]] && ssh-add --apple-use-keychain -q

export JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

export PATH="$HOME/tools/maven/bin:$PATH"
export MAVEN_OPTS="-Xms2048m -Xmx2048m"

export JRUBY_OPTS="--dev -J-Xms2048m -J-Xmx2048m"

export PATH=$HOME/.docker/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
