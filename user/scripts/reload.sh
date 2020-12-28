#!/usr/bin/env sh
mkdir -p "$XDG_DATA_HOME/maven"

reload() {
	type "$1" >/dev/null 2>&1 && {
		eval "$2"
		echo "Info: '$2' reloaded"
		return
	}

	echo "Info: '$1' not found"
}

xrdb -load ~/config/X11/Xresources
# systemctl --user reload sxhkd.service
reload "xbindkey" "killall -HUP xbindkeys"
reload "sxhkd" "pkill -USR1 sxhkd"
reload "i3" "i3-msg reload"
reload "urxvt" "pkill -HUP urxvt && pkill -HUP urxvt"
kill -HUP "$MAINPID" # must move mouse after
