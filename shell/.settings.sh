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

export PATH="$HOME/.local/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND="rg --iglob '!.git' --iglob '!node_modules' --iglob '!*.gif' --iglob '!*.png' --files"
export FZF_DEFAULT_OPTS="--color=light"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export CPATH="$CPATH:/opt/homebrew/include"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"
export CC="$(brew --prefix llvm)/bin/clang"
export CXX="$(brew --prefix llvm)/bin/clang++"
alias clangd="$(brew --prefix llvm)/bin/clangd"

# Rustup
source "$HOME/.cargo/env"

# Less
export LESSHISTFILE=/dev/null
