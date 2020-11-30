#!/usr/bin/env sh

reload() {
	type "$1" >/dev/null 2>&1 && {
		eval "$2"
		echo "Info: '$2' reloaded"
		return
	}

	echo "Info: '$1' not found"
}

reload "sxhkd" "pkill -USR1 sxhkd"
reload "i3" "i3-msg reload"
reload "urxvt" "pkill -HUP urxvt && pkill -HUP urxvt"
