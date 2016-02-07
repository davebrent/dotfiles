DOTFILES := $(shell pwd)

.PHONY: git vim mercurial bash sqlite

all: git vim mercurial bash sqlite

git:
	ln -fns $(DOTFILES)/git-completion.bash ../.git-completion.bash
	ln -fns $(DOTFILES)/git-prompt.sh ../.git-prompt.sh
	ln -fns $(DOTFILES)/gitconfig ../.gitconfig
	ln -fns $(DOTFILES)/gitignore_global ../.gitignore_global

tmux:
	ln -fns $(DOTFILES)/tmux.conf ../.tmux.conf

vim:
	ln -fns $(DOTFILES)/vimrc ../.vimrc
	ln -fns $(DOTFILES)/vimrc ../.config/nvim/init.vim

mercurial:
	ln -fns $(DOTFILES)/hgignore_global ../.hgignore_global

bash:
	ln -fns $(DOTFILES)/bashrc ../.bashrc
	ln -fns $(DOTFILES)/bash_profile ../.bash_profile

sqlite:
	ln -fns $(DOTFILES)/sqliterc ../.sqliterc
