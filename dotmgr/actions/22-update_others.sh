# shellcheck shell=bash

# Name:
# Update Others
#
# Description:
# Installs and updates miscellaneous packages. This includes:
# - Several Vim package managers

main() {
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
}
