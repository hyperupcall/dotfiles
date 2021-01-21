#!/usr/bin/env sh

theme="$(printf "nord\ndracula" | fzf)"
echo "$theme" | ~/scripts/themer.nim
