#!/bin/sh

shopt -s globstar

IFS=$'\n'
for file in $(find -L . -type f -name "*" | grep -Eiv ".jpe?g|.txt|.srt|.nfo|.doc|*:\$|^\$"); do
	printf "\033[0;31mprocessing:\e[0m $file"
	ffmpeg -v error -i "$file" -f null -
done

