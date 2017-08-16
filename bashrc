# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PS1='\u@\h$(__git_ps1 " (%s)") \W/\n$ '
export CLICOLOR=1
export PYTHONDONTWRITEBYTECODE=true

alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
export EDITOR='vim'

export PATH=./bin:./build/bin:/usr/local/lib:/usr/local/bin:$PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib:PKG_CONFIG_PATH

if [ -d "$HOME/local/lib" ] ; then
  export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
  export LIBRARY_PATH="$HOME/local/lib:$LIBRARY_PATH"
fi

if [ -d "$HOME/local/bin" ] ; then
  export PATH="$HOME/local/bin:$PATH"
fi

if [ -d "$HOME/local/lib/pkgconfig" ] ; then
  export PKG_CONFIG_PATH="$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

if [ -d "$HOME/Projects/hans" ] ; then
  export DYLD_LIBRARY_PATH="$HOME/Projects/hans/build/lib:$DYLD_LIBRARY_PATH"
  export HANS_MODULES_PATH="$HOME/Projects/hans/build/lib"
fi

export ASAN_OPTIONS=detect_container_overflow=0

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

function encdir {
  tar -c $1 | gpg --symmetric --cipher-algo AES256 > $2
}

function decdir {
  gpg -d $1 | tar -xf -
}

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

[ -f ~/local/genv/bin/activate ] && source ~/local/genv/bin/activate

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh

[ -f ~/.nvm/nvm.sh ] && source ~/.nvm/nvm.sh
[ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
