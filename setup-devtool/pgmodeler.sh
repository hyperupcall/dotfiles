#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='pgModeler'

install.ubuntu() {
	sudo apt-get update -y
	sudo apt-get install -y pgmodeler

	mkdir -p ~/.local/share/applications
	cat >~/.local/share/applications/pgmodeler.desktop <<EOF
[Desktop Entry]
Name=pgModeler
Comment=PostgreSQL Database Modeler
GenericName=Database Modeler
Exec=pgmodeler
Icon=~/.devresources/pgmodeler-logo.png
Terminal=false
Type=Application
Categories=Development;Database;
Keywords=PostgreSQL;Database;Model;Design;Schema;
StartupNotify=false
EOF
}

install.installed() {
	command -v pgmodeler &>/dev/null
}

util.if_file_sourced || _setup "$@"
