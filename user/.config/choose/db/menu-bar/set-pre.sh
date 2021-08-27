# shellcheck shell=bash

categoryDir="$1"
program="$2"

for dir in "$categoryDir"/*/; do
	dir="${dir%/}"; dir="${dir##*/}"

	if [ "$dir" = "$program" ]; then
		continue
	fi
	echo a "$dir"
	case "$dir" in
		dzen) systemctl --user stop dzen ;;
		lemonbar) systemctl --user stop lemonbar ;;
	esac
done

i3-msg bar mode invisible
