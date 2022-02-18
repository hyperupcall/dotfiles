# shellcheck shell=bash
util.ensure_bin deno
util.ensure_bin dvm
util.ensure_bin vr

if ! command -v 'deno' &>/dev/null; then
	print.info "Installing dvm"
	util.req https://deno.land/x/dvm/install.sh | sh
	dvm install
fi
