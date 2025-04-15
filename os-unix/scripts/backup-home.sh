#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	local save_dir="$HOME"
	local backup_dir="/storage/vault/rodinia/Backups/backup_storage_home"

	printf "Backing up\n  from: %s\n  to:   %s\n" "$save_dir" "$backup_dir"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/Downloads' \
			--exclude '**/brave-browser*' \
			--exclude '**/chromium*' \
			--exclude '**/firefox*' \
			--exclude '**/llvm-project*' \
			--exclude '**/gcc*' \
			--exclude '**/android*' \
			--exclude '**/buildroot*' \
			--exclude '**/linux*' \
			--exclude '**/rootfs*' \
			--exclude '**/rustup/toolchains' \
			--exclude '**/cargo/registry' \
			--exclude '**/mise/installs' \
			--exclude '**/pnpm/store' \
			--exclude '**/__pycache__' \
			--exclude '**/.npm/_cacache' \
			--exclude '**/.conan2/p' \
			--exclude '**/node_modules' \
			--exclude '**/target' \
			--exclude '**/dist' \
			--exclude '**/output' \
			--exclude '**/build' \
			--exclude '**/.Trash-1000' \
			--exclude '**/aria2c' \
			--exclude '**/Torrents' \
			--exclude '**/youtube-dl' \
			--exclude '**/google-fonts-repository' \
			--exclude '**/*.git' \
			--exclude '**/.git' \
			--exclude '**/.hg' \
			--exclude '**/.svn' \
			--exclude '**/.cache' \
			"$backup_dir"::'backup-{now}' \
			"$save_dir"
	fi
}

util.if_file_sourced || main "$@"
