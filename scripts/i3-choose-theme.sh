#!/bin/sh -eu

themes=$(echo -e "$(i3-style --list-all | sed -E "s/(.*)(- .*)/\1/g" | grep -v "Available themes" | grep -v seti)\n  seti" | xargs)

#echo $themes | tr ' \n' '#$'

theme=$(echo -e $themes | tr ' ' '\n' | dmenu)

i3-style "$theme" -o ~/.config/i3/config --reload
