# shellcheck shell=bash

check_bin asf

[ ! -d "$XDG_DATA_HOME/asdf" ] && {
	util.log_info "Installing asdf"
	git clone https://github.com/asdf-vm/asdf.git "$XDG_DATA_HOME/asdf"

	cd "$XDG_DATA_HOME/asdf" || util.die "Could not cd to asdf data dir"
	git switch -c "$(git describe --abbrev=0 --tags)"
}
