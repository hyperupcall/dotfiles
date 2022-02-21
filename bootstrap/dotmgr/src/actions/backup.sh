# shellcheck shell=bash

# Name:
# backup
#
# Description:
# Performs a backup using Borg Backup

action() {
	return 0
	borg create --show-version --show-rc --verbose --stats --progress --exclude '**/.Trash-1000' --exclude '**/llvm-project' --exclude '**/gcc' --exclude ~/Docs/Programming/git --exclude '**/node_modules' --exclude '**/__pycache__' --exclude '**/rootfs' /storage/vault/rodinia/Backups/edwin_borg::'backup-{now}' /storage/ur/storage_home/
}
