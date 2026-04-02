#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Adminer'

install.any() {
	util.get_latest_github_tag 'vrana/adminer'
	local version="$REPLY"

	mkdir -p ~/.dotfiles/.data/{adminer,binexec}
	curl -K "$CURL_CONFIG" -o ./adminer-${version#v}.php "https://github.com/vrana/adminer/releases/download/$version/adminer-${version#v}.php"
	mv ./adminer-${version#v}.php ~/.dotfiles/.data/adminer/adminer-${version#v}.php
	cat > ~/.dotfiles/.data/binexec/adminer <<EOF
#!/bin/sh
if ! pgrep -f "php -S localhost:9095 adminer-*.php"; then
	/usr/bin/php -S localhost:9095 ~/.dotfiles/.data/adminer/adminer-${version#v}.php &
fi
if ! xdg-open http://localhost:9095; then
	notify-send --urgency critical 'Failed top open adminer website URL'
fi
EOF
	chmod +x ~/.dotfiles/.data/binexec/adminer
	cat > "$XDG_DATA_HOME/applications/adminer.desktop" <<EOF
[Desktop Entry]
Name=Adminer
Comment=Run adminer ${version}
GenericName=Database Manager
Exec=~/.dotfiles/.data/binexec/adminer
Icon=~/.dotfiles/data/adminer-logo.png
Type=Application
StartupNotify=false
StartupWMClass=Adminer
Categories=IDE;Development
MimeType=application/sql
Keywords=MySQL;MariaDB;PostgreSQL;CockroachDB;SQLite;SQL
EOF
}

installed() {
	[ -d ~/.dotfiles/.data/adminer ]
}

util.if_file_sourced || _setup "$@"
