#!/usr/bin/env sh

pgrep -u "$(whoami)" xidlehook || {
	echo "Launch xidlehook"
	xidlehook.sh &
}
