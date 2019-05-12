echo "... .bashrc"

[[ -s /etc/bashrc ]] && source /etc/bashrc

[[ -s /usr/local/etc/bash_completion ]] \
    && source "/usr/local/etc/bash_completion"

[[ -s /usr/local/etc/bash_completion.d/git-prompt.sh ]] \
    && source "/usr/local/etc/bash_completion.d/git-prompt.sh"

[[ -x /usr/local/bin/aws_completer ]] \
    && complete -C /usr/local/bin/aws_completer aws

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PROMPT_COMMAND='__git_ps1 "\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]" "\\\$ "'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export GPG_TTY=$(tty)
export EDITOR=vim

[[ -s $HOME/.alias ]] && . $HOME/.alias

# added by travis gem
[ -s ~/.travis/travis.sh ] && . ~/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
