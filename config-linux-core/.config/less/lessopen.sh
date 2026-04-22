#!/usr/bin/env sh
esc='esc'
if [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
	esc='esc256'
else
	colors=$(tput colors)
	if [ "$colors" -eq 256 ]; then
		esc='esc256'
	fi
fi

for file; do
	[ -f "$1" ] || continue

	cmd="source-highlight --failsafe --outlang-def $esc.outlang"
	case $file in
	*.json)
		cmd="$cmd --style-file json.style"
		;;
	*)
		cmd="$cmd --style-file $esc.style"
		;;
	esac

	case $file in
	*.zip | *.tar | *.tgz | *.gz | *.bz2 | *.xz)
		lesspipe "$file"
		;;
	*)
		lesspipe "$file" | $cmd --infer-lang -i "$file"
		;;
	esac
done
