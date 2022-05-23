# shellcheck shell=bash

dotmgr-info() {
	util.ensure_profile_read

	printf '%s\n' "REPO_DIR_REPLY: $REPO_DIR_REPLY"
}
