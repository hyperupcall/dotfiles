# shellcheck shell=bash

main() {
	if util.confirm 'Install Obsidian?'; then
		install.obsidian
	fi
}

install.obsidian() {
	util.get_latest_github_tag 'obsidianmd/obsidian-releases'
	declare latest_tag="$REPLY"

	util.cd_temp

	core.print_info 'Downloading and Installing Obsidian AppImage'
	declare latest_version="${latest_tag#v}"
	declare file='Obsidian.AppImage'
	curl -fsSLo "$file" "https://github.com/obsidianmd/obsidian-releases/releases/download/$latest_tag/Obsidian-$latest_version.AppImage"
	chmod +x "$file"
	./"$file"

	popd >/dev/null
}

main "$@"
