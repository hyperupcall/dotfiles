# shellcheck shell=bash

# Name:
# Update Others
#
# Description:
# Installs and updates miscellaneous packages. This includes:
# - Several Vim package managers

main() {
	if util.confirm 'Install random Vim plugin managers'; then
	# Vim Plug
	curl -fLo "$XDG_CONFIG_HOME/vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	# Pathogen
	curl -fLo "$XDG_CONFIG_HOME/vim/autoload/pathogen.vim" --create-dirs 'https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim'

	# Vundle
	git clone 'https://github.com/VundleVim/Vundle.vim' "$XDG_STATE_HOME/vim/bundle-vundle/vundle.vim"

	# NeoBundle
	git clone 'https://github.com/Shougo/neobundle.vim' "$XDG_STATE_HOME/vim/bundle-neobundle/neobundle.vim"

	# dein
	git clone 'https://github.com/Shougo/dein.vim' "$XDG_STATE_HOME/vim/bundle-dein/dein.vim"

	# minpac
	git clone 'https://github.com/k-takata/minpac' "$XDG_STATE_HOME/vim/pack/minpac/opt/minpac"

	# Packer
	git clone --depth 1 'https://github.com/wbthomason/packer.nvim' "$XDG_STATE_HOME/nvim/site/pack/packer/start/packer.nvim"
	fi


	# 4. Bash
	if util.confirm 'Install Bash stuff?'; then
		# Frameworks
		util.clone_in_dots 'https://github.com/ohmybash/oh-my-bash'
		util.clone_in_dots 'https://github.com/bash-it/bash-it'
		source ~/.dotfiles/.data/repos/bash-it/install.sh --no-modify-config

		# Prompts
		util.clone_in_dots 'https://github.com/magicmonty/bash-git-prompt'
		util.clone_in_dots 'https://github.com/riobard/bash-powerline'
		util.clone_in_dots 'https://github.com/barryclark/bashstrap'
		util.clone_in_dots 'https://github.com/lvv/git-prompt'
		util.clone_in_dots 'https://github.com/nojhan/liquidprompt'
		util.clone_in_dots 'https://github.com/arialdomartini/oh-my-git'
		util.clone_in_dots 'https://github.com/twolfson/sexy-bash-prompt'

		# Utilities
		util.clone_in_dots 'https://github.com/akinomyoga/ble.sh'
		util.clone_in_dots 'https://github.com/huyng/bashmarks'

		# Unused
		# util.clone 'https://github.com/basherpm/basher' ~/.dotfiles/.data/repos/basher
	fi


	# 8. Git
	if util.confirm 'Install Random Git packages?'; then
		util.clone_in_dots 'jayphelps/git-blame-someone-else'
		util.clone_in_dots 'davidosomething/git-ink'
		util.clone_in_dots 'qw3rtman/git-fire'
		util.clone_in_dots 'paulirish/git-recent'
		util.clone_in_dots 'imsky/git-fresh'
		util.clone_in_dots 'paulirish/git-open'
	fi
}
