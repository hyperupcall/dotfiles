#!/usr/bin/env sh
[ -f "$1" ] || exit
/usr/bin/lesspipe "$1" | /usr/bin/source-highlight --out-format=esc --failsafe -i "$1"
