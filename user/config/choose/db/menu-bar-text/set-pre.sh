# shellcheck shell=bash

categoryDir="$1"
program="$2"

sh "$categoryDir"/../menu-bar/set-pre.sh "$categoryDir"/../menu-bar "$program"

i3-msg bar mode dock
