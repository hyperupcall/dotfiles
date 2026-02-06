#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Homebrew'

main() {
	bash -c "$(curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

installed() {
	[ -x /home/linuxbrew/.linuxbrew/bin/brew ]
}

configure() {
	util.write_shellfile 'homebrew' \
		--sh 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

}

util.if_file_sourced || _setup "$@"
