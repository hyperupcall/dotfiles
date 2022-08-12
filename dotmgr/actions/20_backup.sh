# shellcheck shell=bash

# Name:
# Borg Backup
#
# Description:
# Performs a backup using Borg Backup
# It ignores the following directories
#   - **/node_modules
#   - **/__pycache__
#   - **/rootfs
#   - **/.Trash-1000
#   - **/llvm-project
#   - **/gcc

main() {
	local backup_dir="/storage/vault/rodinia/Backups/edwin_borg"
	local dir="/storage/ur/storage_home"

	# shellcheck disable=SC2059
	printf "Backing up\n  from: $backup_dir\n  to:   $dir\n"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/node_modules' \
			--exclude '**/__pycache__' \
			--exclude '**/rootfs' \
			--exclude '**/.Trash-1000' \
			--exclude '**/llvm-project' \
			--exclude '**/gcc' \
			--exclude '**/aria2c' \
			--exclude '**/Torrents' \
			--exclude '**/youtube-dl' \
			--exclude '**/Dls' \
			--exclude '**/.git' \
			"$backup_dir"::'backup-{now}' \
			"$dir"
	fi
}
