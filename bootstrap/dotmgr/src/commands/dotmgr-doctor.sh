# shellcheck shell=bash

dotmgr-doctor() {
	util.ensure_profile_read

	printf '%s\n' "REPO_DIR_REPLY: $REPO_DIR_REPLY"
}
