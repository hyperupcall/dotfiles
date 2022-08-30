# shellcheck shell=bash

# Name:
# Sync Passwords
#
# Description:
# Syncs local password-store to dropbox. This script is needed because
# Dropbox does not follow symlinks.

main() {
	if util.confirm "Copy password store to dropbox?"; then
		cp -r "${PASSWORD_STORE_DIR:-$HOME/password-store}/" "$HOME/Dropbox"
	fi
}
