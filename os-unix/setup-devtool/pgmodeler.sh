#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='pgModeler'

main() {
	util.install_by_setup "$@"
}

install.ubuntu() {
	sudo apt-get update -y
	sudo apt-get install -y pgmodeler

	mkdir -p ~/.local/share/applications
	cat > ~/.local/share/applications/pgmodeler.desktop <<EOF
[Desktop Entry]
Name=pgModeler
Comment=PostgreSQL Database Modeler
GenericName=Database Modeler
Exec=pgmodeler
Icon=~/.dotfiles/os-unix/data/pgmodeler-logo.png
Terminal=false
Type=Application
Categories=Development;Database;
Keywords=PostgreSQL;Database;Model;Design;Schema;
StartupNotify=false
EOF
}

installed() {
	command -v pgmodeler &>/dev/null
}

util.if_file_sourced || _setup "$@"
