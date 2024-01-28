#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Obsidian?'; then
		install.obsidian
	fi
}

install.obsidian() {
	helper.assert_app_image_launcher_installed

	util.get_latest_github_tag 'obsidianmd/obsidian-releases'
	local latest_tag="$REPLY"

	util.cd_temp

	core.print_info 'Downloading and Installing Obsidian AppImage'
	local latest_version="${latest_tag#v}"
	local file='Obsidian.AppImage'
	util.req -o "$file" "https://github.com/obsidianmd/obsidian-releases/releases/download/$latest_tag/Obsidian-$latest_version.AppImage"
	chmod +x "$file"
	nohup 2>/dev/null ./"$file" & # TODO (does not work)

	popd >/dev/null
}

main "$@"
