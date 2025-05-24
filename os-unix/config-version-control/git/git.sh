#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Git'

main() {
	helper.setup "$@"
}

install.debian() {
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo apt-get update -y
	sudo apt-get install -y git
}

install.ubuntu() {
	install.debian
}

installed() {
	# Version must be at least 2.37.0 to support "push.autoSetupRemote".
	git_version_check() {
		local -a git_version_arr
		git_version=$(git version)
		git_version=${git_version#git version }
		IFS='.' read -ra git_version_arr <<< "$git_version"
		(( git_version_arr[0] >= 3 || (git_version_arr[0] == 2 && git_version_arr[1] >= 37) ))
	}

	command -v git &>/dev/null && git_version_check
}

util.if_file_sourced || helper.run_main "$@"
