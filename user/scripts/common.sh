#!/usr/bin/env sh

# Common POSIX Shell Utils

# logging
debug() {
	:
}

warn() {
	:
}

# control flow
die() {
	printf "Ending"
} 1>&2

int () {
	:
}
trap int INT
