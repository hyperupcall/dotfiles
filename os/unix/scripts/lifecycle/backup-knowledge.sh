#!/usr/bin/env bash

# Name:
# Borg backup to dropbox
#
# Description
# Backs up Dropbox directory

source "${0%/*}/../source.sh"

main() {
	borg create --show-version --show-rc --verbose --stats --progress /storage/vault/rodinia/Backups/dropbox_dir::backup-{now} ~/Dropbox/KnowledgeQuasipanacea/
}

main "$@"
