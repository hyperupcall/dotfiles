#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='dev'

main() {
	helper.setup "$@"
}

install.any() {
	# Download and install NodeJS runtime.
	local dir=(~/.dotfiles/.data/node-v*/)
	dir=${dir%/}
	if [[ "${dir}" == *\* ]]; then
		dir=
	fi
	local old_nodejs_version="${dir[0]##*/}"
	old_nodejs_version=${old_nodejs_version#node-v}
	old_nodejs_version=${old_nodejs_version%%-*}
	local nodejs_version='23.6.0' # TODO: Update and update docs
	if [ -d "${dir[0]}" ] && [ "$old_nodejs_version" = "$nodejs_version" ]; then
		local dir_pretty="~${dir[0]#$HOME}"
		core.print_info "Already installed NodeJS to $dir_pretty"
	else
		pushd ~/.dotfiles/.data >/dev/null
		local file="./node-v$nodejs_version.tar.xz"
		if [ "$old_nodejs_version" != "$nodejs_version" ] && [ -n "$old_nodejs_version" ]; then
			core.print_info "Removing outdated NodeJS v$old_nodejs_version"
			rm -rf "${dir[0]}"
		fi
		core.print_info "Downloading NodeJS v$nodejs_version"
		curl -K "$CURL_CONFIG" -o "$file" "https://nodejs.org/dist/v$nodejs_version/node-v$nodejs_version-linux-x64.tar.xz"
		core.print_info "Extracting $file"
		tar xf "$file"
		rm -rf "$file"
		popd >/dev/null
	fi
	if [ ! -f ~/.dotfiles/.data/node ]; then
		ln -sf ~/.dotfiles/.data/node-v*/bin/node ~/.dotfiles/.data/node
	fi

	# Download and install Deno runtime.
	if [ -x ~/.dotfiles/.data/deno ]; then
		core.print_info "Already installed NodeJS to ~/.dotfiles/.data/deno"
	else
		curl -K "$CURL_CONFIG" https://deno.land/install.sh | DENO_INSTALL="$PWD" CI=1 sh
		mv "$PWD/bin/deno" ~/.dotfiles/.data/deno
	fi

	# Download and install "dev".
	local dir="$HOME/.dev"
	if [ ! -d "$dir" ]; then
		util.clone "$dir" git@github.com:fox-incubating/dev
	fi
	mkdir -p "$dir/.data"
	if [ ! -f ~/.dotfiles/.data/bin/dev ]; then
		cd ~/.dotfiles/.data/node*/
		local bin_dir="$PWD"
		bin_dir=${bin_dir#/home/}
		bin_dir=${bin_dir#*/}
		bin_dir="$HOME/$bin_dir/bin"
		PATH="$bin_dir:$PATH"
		cd ~/.dev/
		npm i -g pnpm
		pnpm install

		cat <<-EOF > ~/.dotfiles/.data/bin/dev
		#!/usr/bin/env sh
		set -e
		PATH="$bin_dir:\$PATH" ~/.dev/bin/dev.ts "\$@"
		EOF
		chmod +x ~/.dotfiles/.data/bin/dev
	fi
	mkdir -p "$XDG_DATA_HOME/systemd/user"
	cat > "$XDG_DATA_HOME/systemd/user/dev.service" <<-'EOF'
[Unit]
Description=Dev
ConditionPathIsDirectory=%h/.dev

[Service]
Type=simple
WorkingDirectory=%h/.dev
ExecStart=%h/.dotfiles/.data/deno --allow-all %h/.dev/bin/dev.ts start-dev-server
Environment=PORT=40008
Restart=on-failure

[Install]
WantedBy=default.target
EOF
	systemctl --user daemon-reload
	# systemctl --user enable --now dev.service # TODO
}

installed() {
	[ -f "$XDG_DATA_HOME/systemd/user/dev.service" ]
}

util.if_file_sourced || _main "$@"
