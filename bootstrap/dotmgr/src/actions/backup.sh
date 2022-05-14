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

action() {
	local backup_dir="/storage/vault/rodinia/Backups/edwin_borg"
	local dir="/storage/ur/storage_home"

	borg create \
		--show-version --show-rc --verbose --stats --progress \
		--exclude '**/node_modules' \
		--exclude '**/__pycache__' \
		--exclude '**/rootfs' \
		--exclude '**/.Trash-1000' \
		--exclude '**/llvm-project' \
		--exclude '**/gcc' \
		"$backup_dir"::'backup-{now}' \
		"$dir"
}
