#!/usr/bin/env sh
[ -f "$1" ] || exit
/usr/bin/lesspipe "$1" "$2"
