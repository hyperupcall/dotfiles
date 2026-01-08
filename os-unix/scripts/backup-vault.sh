#!/usr/bin/env bash

source ~/.dotfiles/vendor/setup.sh/setup.sh

main() {
	local save_dirs=(
		'/storage/vault/_Data'
		'/storage/vault/Applications'
		'/storage/vault/Computing'
		'/storage/vault/Documents & Resources'
		'/storage/vault/Gaming'
		'/storage/vault/Pictures & Videos'
		'/storage/vault/Reading - Books'
		'/storage/vault/Reading - Papers'
		'/storage/vault/Reading - Specifications'
		'/storage/vault/Records'
	)
	local backup_dir='/storage/secondary/Backups/vault'

	printf "Backing up various directories in '/storage/vault' to '%s'\n" "$backup_dir"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			"$backup_dir"::'backup-{now}-{hostname}' \
			"${save_dirs[@]}"
	fi
}

util.if_file_sourced || _main "$@"
