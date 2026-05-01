#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

declare -g g_name='dev'

install.any() {
	local nodejs_version='24.7.0'

	# Download and install NodeJS runtime.
	local dirs=(~/.dotfiles/.data/node-v*/)
	dirs=("${dirs[@]%/}")
	local old_nodejs_version="${dirs[0]##*/}"
	old_nodejs_version=${old_nodejs_version#node-v}
	old_nodejs_version=${old_nodejs_version%%-*}
	if [ -d "${dirs[0]}" ] && [ "$old_nodejs_version" = "$nodejs_version" ]; then
		local dir_pretty="~${dirs[0]#"$HOME"}"
		core.print_info "Already installed NodeJS to $dir_pretty"
	else
		pushd ~/.dotfiles/.data >/dev/null
		local file="./node-v$nodejs_version.tar.xz"
		if [ "$old_nodejs_version" != "$nodejs_version" ] && [ -n "$old_nodejs_version" ]; then
			core.print_info "Removing outdated NodeJS v$old_nodejs_version"
			rm -rf "${dirs[0]}"
		fi
		core.print_info "Downloading NodeJS v$nodejs_version"
		curl -K "$CURL_CONFIG" -o "$file" "https://nodejs.org/dist/v$nodejs_version/node-v$nodejs_version-linux-x64.tar.xz"
		core.print_info "Extracting $file"
		tar xf "$file"
		rm -rf "$file"
		popd >/dev/null
	fi
	mkdir -p ~/.dotfiles/.data/binexec
	if [ ! -f ~/.dotfiles/.data/binexec/node ]; then
		ln -sf ~/.dotfiles/.data/node-v*/bin/node ~/.dotfiles/.data/binexec/node
	fi

	# Download and install "dev".
	local dir="$HOME/.dev"
	if [ ! -d "$dir" ]; then
		util.clone "$dir" git@github.com:fox-incubating/dev # TODO: Update references
	fi
	mkdir -p "$dir/.data"
	if [ ! -f ~/.dotfiles/.data/bin/dev ]; then
		cat <<-EOF >~/.dotfiles/.data/bin/dev
			#!/usr/bin/env sh
			set -e
			PATH="\$HOME/.dotfiles/.data/binexec:\$PATH" ~/.dev/bin/dev.ts "\$@"
		EOF
		chmod +x ~/.dotfiles/.data/bin/dev
	fi
	mise trust ~/.dev
	pushd ~/.dev
	pnpm install
	node --run build
	popd ~/.dev

	if util.is_in_container_or_chroot; then
		core.print_warn 'Skipping installing and running dev.service since in container or chroot'
	else
		mkdir -p "$XDG_DATA_HOME/systemd/user"
		cp ~/.dev/config/dev.service "$XDG_DATA_HOME/systemd/user/dev.service"
		systemctl --user daemon-reload
		systemctl --user enable --now dev.service
	fi
}

installed() {
	[ -f "$XDG_DATA_HOME/systemd/user/dev.service" ] && [ -f ~/.dotfiles/.data/binexec/node ]
}

util.if_file_sourced || _setup "$@"
