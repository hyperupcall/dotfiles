#!/usr/bin/env sh

case "$1" in
	system)
		pyenv global system
		;;
	restore)
		latest="$(pyenv versions | tail -1 | awk '{ print $1 }')"
		pyenv global "$latest"
		;;
	*)
		echo "Subcommand not found"
		exit 1
		;;
esac
