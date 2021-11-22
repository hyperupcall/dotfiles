# shellcheck shell=bash
check_bin deno
check_bin dvm
check_bin vr

hash deno &>/dev/null || {
	util.log_info "Installing dvm"
	util.req https://deno.land/x/dvm/install.sh | sh
	dvm install
}
