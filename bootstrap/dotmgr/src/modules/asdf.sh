# shellcheck shell=bash

util.ensure_bin asf

[ ! -d "$XDG_DATA_HOME/asdf" ] && {
	print.info "Installing asdf"
	git clone https://github.com/asdf-vm/asdf.git "$XDG_DATA_HOME/asdf"

	cd "$XDG_DATA_HOME/asdf" || print.die "Could not cd to asdf data dir"
	git switch -c "$(git describe --abbrev=0 --tags)"
}
