#!/usr/bin/env bash

debug() {
	if [[ -v DEBUG ]]; then
		echo "$@"
	fi
}

lines="$(clang -E -< "$XDG_CONFIG_HOME/X11/themes/nord.theme.xresources" | grep -Ev '^#|^!')"

IFS=$'\t\n'
for line in $lines; do
	name="${line%%:*}"
	color="${line##*:*#}"

	debug "$name"
	case "$name" in
		*foreground)
			index=10
			;;
		*background)
			index=11
			;;
		*cursorColor)
			index=12
			;;
		*pointerColor2)
			index=13
			;;
		*pointerColor)
			index=14
			;;
		*highlight)
			index=17
			;;
		*borderColor)
			index=708
			continue
			;;
		*font)
			index=710
			continue
			;;
		# *color0)
		# index=105\;c
		# continue
		# ;;
		*)
			continue
			;;
	esac

	printf "\033]%s;#%s\007" "$index" "$color"

done
