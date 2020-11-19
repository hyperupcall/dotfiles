#!/usr/bin/env sh

set -eu

case "$@" in
	--help|-h)
		cat 0<<-HELPTEXT
			quark-default

			Commands:
			  set [application] [value]

			Options:
			  --help      Show the help menu
			  --version   Show the current version
		HELPTEXT
	;;
esac

case "$1" in
	audio)
		mimes="aac ac3 mp2 mp3 mpeg off"
		for mime in $mimes; do
			xdg-mime default "$2" "audio/$mime"
		done;
	;;
	font)
		mimes="otf ttf woff2 woff"
		for mime in $mimes; do
			xdg-mime default "$2" "font/$mime"
		done;
	;;
	image)
		mimes="bmp gif hief jpg jpeg png tiff webp"
		for mime in $mimes; do
			xdg-mime default "$2" "image/$mime"
		done;
	;;
	text)
		mimes="css html rust sgnl tcl troff x-sass"
		for mime in $mimes; do
			xdg-mime default "$2" "text/$mime"
		done;
	;;
	video)
		mimes="mp4 mpeg ogg quicktime webm ogg"
		for mime in $mimes; do
			xdg-mime default "$2" "video/$mime"
		done;
	;;
	*)
		echo "Error: No match found"
	;;
esac

# browser
# surf, vimprobable, vimprobabl2, qutebrowser, dwb, jumanji, luakit, ubzl, midori, chromium, google-chrome, opera, firefox, seamonkey, iceweasel, epiphany, konqueror, elinks, links2, links, lynx, w3m
