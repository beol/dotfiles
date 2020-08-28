export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ -x "/usr/local/bin/brew" ]]; then 
    export BREW_PREFIX=$(brew --prefix)
    export PATH=$BREW_PREFIX/opt/openssl/bin:$BREW_PREFIX/opt/apr/bin:$BREW_PREFIX/opt/apr-util/bin:$BREW_PREFIX/opt/gpg-agent/bin:$BREW_PREFIX/opt/node@12/bin:$BREW_PREFIX/opt/ruby/bin:$PATH
fi

[[ -n "$SSH_AUTH_SOCK" ]] && ssh-add -K -q

export JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

export PATH="$HOME/tools/apache-maven-3.6.0/bin:$PATH"
export MAVEN_OPTS="-Xms1024m -Xmx2048m"

export JRUBY_OPTS="--dev -J-Xms1024m -J-Xmx2048m"

export PATH=$HOME/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
