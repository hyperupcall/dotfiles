#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

declare -g g_name='Conda'

main() {
	util.get_latest_github_tag 'conda-forge/miniforge'
	local version="$REPLY"

	curl -K "$CURL_CONFIG" -o './miniforge.sh' "https://github.com/conda-forge/miniforge/releases/download/$version/Miniforge3-${version}-Linux-x86_64.sh"
	chmod +x './miniforge.sh'
	./miniforge.sh -p "$XDG_STATE_HOME/miniforge3"
}

configure() {
	util.write_shellfile 'conda' \
		--bash 'eval "$("$XDG_STATE_HOME/miniforge3/bin/mamba" shell hook --shell bash --root-prefix "$XDG_STATE_HOME/miniforge3")"' \
		--zsh 'eval "$("$XDG_STATE_HOME/miniforge3/bin/mamba" shell hook --shell zsh --root-prefix "$XDG_STATE_HOME/miniforge3")"' \
		--tcsh 'eval "$("$XDG_STATE_HOME/miniforge3/bin/mamba" shell hook --shell tcsh --root-prefix "$XDG_STATE_HOME/miniforge3")"'
}

installed() {
	command -v mamba &>/dev/null
}

util.if_file_sourced || _setup "$@"
