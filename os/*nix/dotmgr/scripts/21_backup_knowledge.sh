# shellcheck shell=bash

# Name:
# Borg backup to dropbox
#
# Description
# Backs up Dropbox directory

{
	borg create --show-version --show-rc --verbose --stats --progress /storage/vault/rodinia/Backups/dropbox_dir::backup-{now} ~/Dropbox/KnowledgeQuazipanacea/
}
