#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

main() {
	local save_dir="$_private_backup_home_source"
	local backup_dir="$_private_backup_home_dest"

	printf "Backing up\n  from: %s\n  to:   %s\n" "$save_dir" "$backup_dir"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/Steam/steamapps' \
			--exclude '**/Steam/ubuntu12_32' \
			--exclude '**/Steam/ubuntu12_64' \
			--exclude '**/*.git' \
			--exclude '**/*.hg' \
			--exclude '**/*.svn' \
			--exclude '**/google-fonts-repository' \
			--exclude '**/brave-browser*' \
			--exclude '**/chromium*' \
			--exclude '**/firefox*' \
			--exclude '**/llvm-project*' \
			--exclude '**/gcc*' \
			--exclude '**/android*' \
			--exclude '**/buildroot*' \
			--exclude '**/linux*' \
			--exclude '**/rootfs*' \
			--exclude '**/node_modules' \
			--exclude '**/.npm/_cacache' \
			--exclude '**/pnpm/store' \
			--exclude '**/rustup/toolchains' \
			--exclude '**/cargo/registry' \
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
			--exclude "$XDG_DATA_HOME/flatpak/repo/objects" \
			--exclude "$XDG_DATA_HOME/flatpak/runtime" \
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
			"$backup_dir"::'backup-{now}-{hostname}' \
			"$save_dir"
	fi
}

util.if_file_sourced || _main "$@"
