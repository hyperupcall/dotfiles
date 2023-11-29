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

# Behavior: Take a screenshot
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/run-command-screenshot' "'disabled'"
		;;
esac
dconf update

# Behavior: Take a screenshot of a window
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/run-command-window-screenshot' "'disabled'"
		;;
esac
dconf update
