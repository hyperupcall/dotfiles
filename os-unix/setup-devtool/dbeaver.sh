#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='DBeaver'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
	sudo apt-get update -y
	sudo apt-get install -y dbeaver-ce
}

installed() {
	command -v dbeaver &>/dev/null
}

caveats() {
	cat <<"EOF"
To  fix the scollbar, write to `~/.config/gtk-4.0/settings.ini`:

gtk-overlay-scrolling=false
gtk-primary-button-warps-slider = false

More information: https://github.com/dbeaver/dbeaver/issues/10950
EOF
}

util.if_file_sourced || _setup "$@"
