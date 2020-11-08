#!/usr/bin/env bash

# dir_colors
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# x11
#xhost +local:root >/dev/null 2>&1


openimage() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd "$(dirname "$1")" || exit
	local file
	file=$(basename "$1")

	feh -q "$types" --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}
