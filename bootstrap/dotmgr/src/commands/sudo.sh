# shellcheck shell=bash

subcommand() {
	exec sudo --preserve-env='HOME' "$DOTMGR_ROOT/bin/dotmgr"
}
