#!/usr/bin/env bash

source "${0%/*}/../source.sh"

case $XDG_CURRENT_DESKTOP in
	MATE)
		;;
	*)
		core.print_warn "Desktop environment not supported: $XDG_CURRENT_DESKTOP"
		exit 1
		;;
esac

# Behavior: Hide windows and set focus to desktop
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/show-desktop' "'disabled'"
		;;
esac
dconf update
