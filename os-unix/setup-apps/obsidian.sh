#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

declare -g g_name='Obsidian'

main() {
	if ! command -v appimagelauncherd &>/dev/null; then
		core.print_die "This scripts depends on the installation of AppImageLauncher"
	fi

	util.get_latest_github_tag 'obsidianmd/obsidian-releases'
	local latest_tag="$REPLY"

	core.print_info 'Downloading and Installing Obsidian AppImage'
	local latest_version="${latest_tag#v}"
	local file='Obsidian.AppImage'
	curl -K "$CURL_CONFIG" -o "$file" "https://github.com/obsidianmd/obsidian-releases/releases/download/$latest_tag/Obsidian-$latest_version.AppImage"
	chmod +x "$file"
	core.print_info "Launching Obsidian AppImage in foreground"
	exec ./"$file"
}

util.if_file_sourced || _setup "$@"
