#!/usr/bin/env bash
set +o history
set -o noglob

for c in $(echo "$CHARS" | sed -e 's/\(.\)/\1\n/g'); do
    	#echo "char: $c"

	case "$c" in
    	":") c="colon" ;;
	";") c="semicolon" ;;
	"?") c="question" ;;
	"_") c="underscore" ;;
	"~") c="asciitilde" ;;
	"|") c="bar" ;;
	"\\") c="backslash" ;;
	"/") c="slash" ;;
	"!") c="exclam" ;;
	"@") c="at" ;;
	"#") c="numbersign" ;;
	"$") c="dollar" ;;
	"%") c="percent" ;;
	"^") c="asciicircum" ;;
	"&") c="ampersand" ;;
	"*") c="asterisk" ;;
	")") c="parenleft" ;;
	"(") c="parenright" ;;
	"[") c="bracketleft" ;;
	"]") c="bracketright" ;;
	"{") c="braceleft" ;;
	"}") c="braceright" ;;
	"<") c="less" ;;
	">") c="greater" ;;
	",") c="comma" ;;
	".") c="period" ;;
	"-") c="minus" ;;
	"_") c="underscore" ;;
	"=") c="equal" ;;
	"\"") c="semicolon" ;;
	"'") c="apostrophe" ;;
	"\`") c="grave" ;;
	esac
	xdotool key -- "$c"; sleep 0.05
done
notify-send 'done'
