#!/bin/bash -eu
# set -euo pipefail

isAbsolute() {
	: "${1:-""}"
	test -z "$1" && {
		echo "no arguments passed to isAbsolute"
		exit 2
	}

	test "${1:0:1}" = "/"
}

set +o allexport
# not working as expected
XDG_DESKTOP_DIR="foo"
# shellcheck source=/etc/xdg/user-dirs.defaults
source "$XDG_CONFIG_DIRS/user-dirs.defaults"
# shellcheck source=../.config/user-dirs.dirs
source "$XDG_CONFIG_HOME/user-dirs.dirs"
set -o allexport

xdgDirs=("XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR XDG_TEMPLATES_DIR \
	XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR XDG_MUSIC_DIR \
	XDG_PICTURES_DIR XDG_VIDEOS_DIR")

# shellcheck disable=SC2068
for dir in ${xdgDirs[@]}; do
	# shellcheck disable=SC2155
	declare envValue="$(printenv "$dir")"
	isAbsolute "${envValue:-"default"}" && {
		echo "$dir"

		continue
	}
	echo "skipping $dir since the variable is empty"
done

