# shellcheck shell=bash

dotmgr-sudo() {
	exec sudo --preserve-env='HOME' "$DOTMGR_ROOT/bin/dotmgr"
}
