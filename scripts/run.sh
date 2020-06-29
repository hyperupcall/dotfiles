#!/bin/bash -eu

shopt -s globstar

cd ~/.dots/scripts/run
file="$(echo ./** | tr ' ' '\n' | dmenu)"

filePath="$PWD/$file"
test -x "$filePath" && { "$filePath"; exit; }
echo "File '$filePath' not exist or not executable."; exit 1
