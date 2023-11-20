#!/usr/bin/env ksh

# Behavior: Hide windows and set focus to desktop
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/show-desktop' "''"
		;;
esac
dconf update
