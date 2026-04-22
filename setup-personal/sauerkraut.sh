#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

declare -g g_name='Sauerkraut'
declare -g g_dir="$HOME/.dev/.data/installed-repositories/sauerkraut"

install.any() {
	util.clone "$g_dir" git@github.com:hyperupcall/autoenv

	cd "$g_dir"
	pnpm install

	mkdir -p ~/.dotfiles/.data/bin
	ln -sf "$g_dir/bin/sauerkraut.js" ~/.dotfiles/.data/bin/sauerkraut

	mkdir -p ~/.local/share/systemd/user
	cat >~/.local/share/systemd/user/brain.service <<'EOF'
[Unit]
Description=Brain
ConditionPathIsDirectory=%h/.dev/.data/installed-repositories/sauerkraut/

[Service]
Type=simple
WorkingDirectory=%h/Documents/BrainSite
ExecStart=%h/.dotfiles/.data/binexec/node %h/.dev/.data/installed-repositories/sauerkraut/bin/sauerkraut.js serve
Environment=PORT=52001
Restart=on-failure

[Install]
WantedBy=default.target
EOF

	systemctl --user daemon-reload
	systemctl --user start brain.service
}

installed() {
	[ -d "$g_dir" ] && [ -f ~/.dotfiles/.data/bin/sauerkraut ]
}

util.if_file_sourced || _setup "$@"
