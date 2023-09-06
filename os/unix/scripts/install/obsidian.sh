#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Obsidian?'; then
		install.obsidian
	fi
}

install.obsidian() {
	util.get_latest_github_tag 'obsidianmd/obsidian-releases'
	local latest_tag="$REPLY"

	util.cd_temp

	core.print_info 'Downloading and Installing Obsidian AppImage'
	local latest_version="${latest_tag#v}"
	local file='Obsidian.AppImage'
	curl -fsSLo "$file" "https://github.com/obsidianmd/obsidian-releases/releases/download/$latest_tag/Obsidian-$latest_version.AppImage"
	chmod +x "$file"
	./"$file"

	popd >/dev/null
}

main "$@"
