#!/usr/bin/env sh
set -eu

debug() {
	${DEBUG+"f"} || {
		echo "$@"
		echo "$@" >&2
	}
}

case "$@" in
--help|-h)
	cat 0<<-HELPTEXT
		fox-default.sh
		Usage:
		    fox-default.sh {subcommand} {parameters} [...options]

		Description:
		    Perform actions based on default applications. 'set' the default application when opening up a file (w/ xdg-open), 'open' the application, or 'print' the command used to open the application

		Commands:
		    set [application] [value]
		    open [application]
		    print [application]

		Options:
		    --help      Show the help menu
		    --version   Show the current version
	HELPTEXT
;;
esac

doSet() {
	set -- "${1:-''}"
	set -- "${2:-''}"

	: "${2:?"Mime not found"}"

	case "$1" in
	audio)
		mimes="aac ac3 mp2 mp3 mpeg off"
		for mime in $mimes; do
			xdg-mime default "$2" "audio/$mime"
		done
	;;
	font)
		mimes="otf ttf woff2 woff"
		for mime in $mimes; do
			xdg-mime default "$2" "font/$mime"
		done
	;;
	image)
		mimes="bmp gif hief jpg jpeg png tiff webp"
		for mime in $mimes; do
			xdg-mime default "$2" "image/$mime"
		done
	;;
	text)
		mimes="css html rust sgnl tcl troff x-sass"
		for mime in $mimes; do
			xdg-mime default "$2" "text/$mime"
		done
	;;
	video)
		mimes="mp4 mpeg ogg quicktime webm ogg"
		for mime in $mimes; do
			xdg-mime default "$2" "video/$mime"
		done
	;;
	file-browser)
		mimes="inode/directory"
		for mime in $mimes; do
			:
		done
	;;
	screen-locker)
		:
	;;
	*)
		echo "Error: No match found" >&2
		exit 1
	;;
	esac
}

grabb() {
	set -- "${1:-""}"

	case "$1" in
	screen-locker)
		applications="i3bar"
		for application in $applications; do
			command -v "$application" >/dev/null || continue


			case $application in
			i3bar)
				echo "i3bar"
				return
			;;
			window-manager)
				echo "i3"
				return
			;;
			video-player)
				echo "mpv"
				return
			;;
			*)
				echo "Thing not found" >&2
				return 1
			;;
			esac

		done

		echo "Internal Error: Could not select an application" >&2
		return 1
	;;
	*)
		echo "Error: Application not found. Entered: '$1'" >&2
		return 1
	;;
	esac
}

doOpen() {
	command="$(grabb "$@")"
	exitCode=$?
	[ "$exitCode" -ne 0 ] && {
		echo "Error: Could not open application"
		exit $exitCode
	}
	exec $command
}


doPrint() {
	command="$(grabb "$@")"
	exitCode=$?
	[ "$exitCode" -ne 0 ] && {
		echo "Error: Could not open application"
		exit $exitCode
	}
	echo "$command"
}

case "$1" in
set)
	shift
	doSet "$@"
;;
open)
	shift
	doOpen "$@"
;;
print)
	shift
	doPrint "$@"
;;
*)
	echo "Error: Subcommand not found. Entered: '$1'" >&2
	exit 1
;;
esac
