#!/usr/bin/env sh
[ -f "$1" ] || exit
lesspipe "$1" "$2"
