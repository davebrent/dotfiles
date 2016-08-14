DOTFILES := $(shell pwd)

.PHONY: local git guile tmux vim mercurial bash sqlite

all: local git guile tmux vim mercurial bash sqlite

../local/:
	mkdir -p $@
../local/lib/: ../local/
	mkdir -p $@
../local/bin/: ../local/
	mkdir -p $@
../local/include/: ../local/
	mkdir -p $@
../local/genv/: ../local/
	virtualenv $@ --no-site-packages && \
		source ../local/genv/bin/activate && \
		pip install -r requirements.txt
local: ../local/lib ../local/bin ../local/include ../local/genv

# Git

../.git-completion.bash:
	ln -fns $(DOTFILES)/git-completion.bash $@
../.git-prompt.sh:
	ln -fns $(DOTFILES)/git-prompt.sh $@
../.gitconfig:
	ln -fns $(DOTFILES)/gitconfig $@
../.gitignore_global:
	ln -fns $(DOTFILES)/gitignore_global $@
git: ../.git-completion.bash ../.git-prompt.sh ../.gitconfig ../.gitignore_global

# Guile

../.guile:
	ln -fns $(DOTFILES)/guile $@
guile: ../.guile

# Tmux

../.tmux.conf:
	ln -fns $(DOTFILES)/tmux.conf $@
tmux: ../.tmux.conf

# Vim

../.vimrc:
	ln -fns $(DOTFILES)/vimrc $@
../.config/nvim/init.vim:
	ln -fns $(DOTFILES)/vimrc $@
vim: ../.vimrc ../.config/nvim/init.vim

# Mercurial

../.hgignore_global:
	ln -fns $(DOTFILES)/hgignore_global $@
mercurial: ../.hgignore_global

# Bash

../.bashrc:
	ln -fns $(DOTFILES)/bashrc $@
../.bash_profile:
	ln -fns $(DOTFILES)/bash_profile $@
bash: ../.bashrc ../.bash_profile

# Sqlite

../.sqliterc:
	ln -fns $(DOTFILES)/sqliterc $@
sqlite: ../.sqliterc
