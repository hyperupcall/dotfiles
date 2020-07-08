#!/bin/sh -eu

themes=$(printf "%s" "$(i3-style --list-all | sed -E "s/(.*)(- .*)/\1/g" | grep -v "Available themes" | grep -v seti)\n  seti" | xargs)

theme=$(printf "%s" "$themes" | tr ' ' '\n' | dmenu)

i3-style "$theme" -o ~/.config/i3/config --reload
