# shellcheck shell=bash

# Name:
# Borg backup to dropbox
#
# Description
# Backs up Dropbox directory

main() {
	borg create --show-version --show-rc --verbose --stats --progress /storage/vault/rodinia/Backups/dropbox_dir::backup-{now} ~/Dropbox/KnowledgeQuasipanacea/
}

main "$@"
