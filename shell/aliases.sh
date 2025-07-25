alias vim="nvim"
alias gs="git status --short"
alias gd="git diff"
alias gg="git graph"
alias la="ls -la"
alias s="grep -Hrn"
alias server="python3 -m http.server"
alias p="python3"

export EDITOR="vim"
export VISUAL="vim"
export FZF_DEFAULT_COMMAND="rg --iglob '!.git' --iglob '!node_modules' --iglob '!*.gif' --iglob '!*.png' --files"
export FZF_DEFAULT_OPTS="--color=light"
export LESSHISTFILE=/dev/null

export PATH="$HOME/.local/bin:$PATH"
