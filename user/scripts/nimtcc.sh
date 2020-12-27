#!/bin/bash

if [[ "$#" -eq 0 ]]; then
	echo "at least 1 argument required" >&2
	exit 1
fi

if [[ ! -e "$1" ]]; then
	echo "not found: $1" >&2
	exit 1
fi

umask u+rwx
out=$(mktemp "${TMPDIR:-/tmp/}""$(basename "$1")".XXXXXXXXXXXX)

function finish() {
	rm -- "$out"
}
trap finish EXIT

nim compile \
	--verbosity:0 \
	'--hint[Processing]:off' \
	--cc:tcc \
	"-o:$out" \
	-r "$@"
