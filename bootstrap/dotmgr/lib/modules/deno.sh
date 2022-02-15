# shellcheck shell=bash
util.ensure_bin deno
util.ensure_bin dvm
util.ensure_bin vr

hash deno &>/dev/null || {
	util.log_info "Installing dvm"
	util.req https://deno.land/x/dvm/install.sh | sh
	dvm install
}
