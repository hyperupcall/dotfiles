#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	printf "Backing up\n  from: %s\n  to:   %s\n" "$_private_backup_home_source" "$_private_backup_home_dest"
	if util.confirm; then
		if [ ! -d "$_private_backup_home_dest" ]; then
			core.print_die "Backup directory does not exist"
		fi

		for dir in "$_private_backup_home_source" "$_private_backup_home_source2" "$_private_backup_home_source3"; do
			if [ ! -d "$dir" ]; then
				core.print_die "Directory must exist: $dir"
			fi
		done

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/Steam/steamapps' \
			--exclude '**/Steam/ubuntu12_32' \
			--exclude '**/Steam/ubuntu12_64' \
			--exclude '**/Steam/appcache' \
			--exclude '**/*.git' \
			--exclude '**/*.hg' \
			--exclude '**/*.svn' \
			--exclude '**/google-fonts-repository' \
			--exclude '**/brave-browser*' \
			--exclude '**/chromium*' \
			--exclude '**/firefox*' \
			--exclude '**/mozilla-unified*' \
			--exclude '**/llvm-project*' \
			--exclude '**/gcc*' \
			--exclude '**/android*' \
			--exclude '**/buildroot*' \
			--exclude '**/linux*' \
			--exclude '**/rootfs*' \
			--exclude '**/node_modules' \
			--exclude '**/.npm/_cacache' \
			--exclude '**/pnpm/store' \
			--exclude '**/.venv*' \
			--exclude '**/.rustup/toolchains' \
			--exclude '**/rustup/toolchains' \
			--exclude '**/.cargo/registry' \
			--exclude '**/cargo/registry' \
			--exclude "$HOME/go" \
			--exclude "$HOME/.gopath" \
			--exclude "$HOME/.opam" \
			--exclude '**/mise/installs' \
			--exclude '**/miniforge3/pkgs' \
			--exclude '**/miniforge3/envs' \
			--exclude '**/miniconda3/pkgs' \
			--exclude '**/miniconda3/envs' \
			--exclude '**/.miniforge3/pkgs' \
			--exclude '**/.miniforge3/envs' \
			--exclude '**/.miniconda3/pkgs' \
			--exclude '**/.miniconda3/envs' \
			--exclude '**/__pycache__' \
			--exclude '**/.conan2/p' \
			--exclude '**/conan2/p' \
			--exclude "$XDG_DATA_HOME/gradle/caches" \
			--exclude "$XDG_DATA_HOME/gradle/jdks" \
			--exclude "**/.gradle/caches" \
			--exclude "**/.gradle/jdks" \
			--exclude "$XDG_DATA_HOME/flatpak/repo/objects" \
			--exclude "$XDG_DATA_HOME/flatpak/runtime" \
			--exclude "$XDG_DATA_HOME/flatpak/appstream" \
			--exclude "$XDG_DATA_HOME/Jan" \
			--exclude "$XDG_DATA_HOME/uv" \
			--exclude '**/target' \
			--exclude '**/target-*' \
			--exclude '**/dist' \
			--exclude '**/dist-*' \
			--exclude '**/output' \
			--exclude '**/output-*' \
			--exclude '**/build' \
			--exclude '**/build-*' \
			--exclude '**/.Trash-1000' \
			--exclude "$XDG_DATA_HOME/Trash" \
			--exclude '**/aria2c' \
			--exclude '**/Torrents' \
			--exclude '**/youtube-dl' \
			--exclude '**/.cache' \
			--exclude '**/*.iso' \
			--exclude '**/.data/vscode-extensions' \
			"$_private_backup_home_dest"::'backup-{now:%Y-%m-%d_%H:%M:%S}-{hostname}' \
			"$_private_backup_home_source" \
			"$_private_backup_home_source2" \
			"$_private_backup_home_source3"
	fi
}

util.if_file_sourced || _main "$@"
