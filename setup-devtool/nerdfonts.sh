#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='NerdFonts'

install.any() {
	brew install --cask \
		font-0xproto{,-nerd-font} \
		font-adwaita{,-mono-nerd-font} \
		font-agave{,-nerd-font} \
		font-code-new-roman-nerd-font \
		font-commit-mono{,-nerd-font} \
		font-fantasque-sans-mono{,-nerd-font} \
		font-fira-{code,mono}{,-nerd-font} \
		font-hack{,-nerd-font} \
		font-inconsolata{,-nerd-font} \
		font-jetbrains-mono{,-nerd-font} \
		font-meslo-lg{,-nerd-font} \
		font-ubuntu-mono{,-nerd-font} \
		font-source-code-pro
}

install.installed() {
	[ -f ~/.local/share/fonts/UbuntuMono-Regular.ttf ]
}

util.if_file_sourced || _setup "$@"
