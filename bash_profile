echo "... .bash_profile"

if [ -n "${TMUX}" ]; then
    unset PATH
    . /etc/profile
fi

[[ -n "$SSH_AUTH_SOCK" ]] && ssh-add -K -q

[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

export JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

export M2_HOME="$HOME/tools/apache-maven-3.6.0"
export M2="$M2_HOME/bin"
export PATH=$M2:$PATH
export MAVEN_OPTS="-Xms1024m -Xmx2048m"

export JRUBY_OPTS="--dev -J-Xms1024m -J-Xmx2048m"

export PATH=$HOME/bin:$(brew --prefix)/opt/openssl/bin:$(brew --prefix)/opt/apr/bin:$(brew --prefix)/opt/apr-util/bin:$(brew --prefix)/opt/gpg-agent/bin:$(brew --prefix)/opt/node@8/bin:$(brew --prefix)/opt/ruby/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
