DOTFILES := $(shell pwd)

.PHONY: local git guile tmux vim mercurial bash sqlite flake8

all: local git guile tmux vim mercurial bash sqlite flake8

../.config:
	mkdir -p $@

# Git

../.gitconfig:
	ln -fns $(DOTFILES)/gitconfig $@
../.gitignore_global:
	ln -fns $(DOTFILES)/gitignore_global $@
git: ../.git-completion.bash ../.git-prompt.sh ../.gitconfig ../.gitignore_global

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

# Flake8

../.config/flake8: ../.config
	ln -fns $(DOTFILES)/flake8 $@
flake8: ../.config/flake8

# Tarsnap

../.tarsnaprc:
	ln -fns $(DOTFILES)/tarsnaprc $@
tarsnap: ../.tarsnaprc
