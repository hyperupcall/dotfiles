#!/bin/bash

# dir_colors
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# x11
xhost +local:root >/dev/null 2>&1

eval "$(gnome-keyring-daemon -s)"
