#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

main() {
	local -n save_dirs='_private_backup_vault_save_dirs'
	local backup_dir="$_private_backup_vault_dest"

	printf "Backing up various directories in '$_private_backup_vault_source' to '%s'\n" "$backup_dir"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/*.git' \
			--exclude '**/*.hg' \
			--exclude '**/*.svn' \
			--exclude '**/node_modules' \
			--exclude '**/target' \
			--exclude "${_private_backup_vault_ignore_globs[@]}" \
			"$backup_dir"::'backup-{now}' \
			"${save_dirs[@]}"
	fi
}

util.if_file_sourced || _main "$@"
