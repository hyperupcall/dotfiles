# shellcheck shell=bash

print.die() {
	print.error "$1. Exiting"
	exit 1
}

print.error() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" "Error" "$1"
	else
		printf "\033[0;31m%s\033[0m %s\n" 'Error' "$1"
	fi
}

print.warn() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" 'Warning' "$1" >&2
	else
		printf "\033[0;33m%s\033[0m %s\n" 'Warning' "$1" >&2
	fi
}

print.info() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%s: %s\n" 'Info' "$1" >&2
	else
		printf "\033[0;32m%s\033[0m %s\n" 'Info' "$1" >&2
	fi
}
