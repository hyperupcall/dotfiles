#!/usr/bin/env bash
source ~/.dotfiles/os-unix/data/setup.sh

main() {
	local -n save_dirs='_private_save_dirs'
	local backup_dir="$_private_backup_vault_dest"

	# Build array with -e before each directory
	local dirs_with_flags=()
	for dir in "${save_dirs[@]}"; do
		dirs_with_flags+=(-e "$dir")
	done

	printf "Backing up various directories in '$_private_backup_vault_source' to '%s'\n" "$backup_dir"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/Records/Backups/**' \
			--exclude '**/*.git' \
			--exclude '**/*.hg' \
			--exclude '**/*.svn' \
			--exclude '**/node_modules' \
			--exclude '**/target' \
			"$backup_dir"::'backup-{now}-{hostname}' \
			"${dirs_with_flags[@]}"
	fi
}

util.if_file_sourced || _main "$@"
