# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PS1='\u@\h$(__git_ps1 " (%s)") \W/$ '
export CLICOLOR=1
export PYTHONDONTWRITEBYTECODE=true
export EDITOR='/usr/bin/vim'

export PATH=./bin:/usr/local/lib:/usr/local/bin:$PATH

# Set PATH so it include private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Enable vi mode
set -o vi

function psg {
    ps aux | grep -v grep | grep $1
}

function server {
    python -m SimpleHTTPServer $1
}

function s {
    grep -Hrn $1 $2
}

alias la='ls -la'
alias ll='ls -l'

alias gs='git status --short'
alias gd='git diff'
alias gl='git log --pretty=oneline --abbrev-commit'
alias gg='git graph'

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh

[ -f ~/.nvm/nvm.sh ] && source ~/.nvm/nvm.sh
[ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm

sclang='/Applications/SuperCollider/SuperCollider.app/Contents/Resources/sclang'
if [ -f $sclang ]; then
    alias sclang=$sclang
fi
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib
