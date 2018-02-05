# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PS1='\u@\h$(__git_ps1 " (%s)") \W/\n$ '
export CLICOLOR=1
export PYTHONDONTWRITEBYTECODE=true

alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
export EDITOR='vim'
export VISUAL='vim'

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

function vm {
  VBoxManage startvm "${1^}" --type headless
}

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
  python -m http.server $1
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

[ -f /usr/share/git/completion/git-completion.bash ] && source /usr/share/git/completion/git-completion.bash
[ -f /usr/share/git/completion/git-prompt.sh ] && source /usr/share/git/completion/git-prompt.sh

[ -f ~/.nvm/nvm.sh ] && source ~/.nvm/nvm.sh
[ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
