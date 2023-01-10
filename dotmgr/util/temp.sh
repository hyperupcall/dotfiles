# shellcheck shell=bash

dotmgr.get_profile() {
	unset -v REPLY; REPLY=

	_util.get_user_dotmgr_dir
	local user_dotmgr_dir="$REPLY"

	_util.get_user_profile "$user_dotmgr_dir"
	REPLY=$REPLY
}

dotmgr.call() {
	_util.get_user_dotmgr_dir
	local user_dotmgr_dir="$REPLY"

	if (( $# == 1 )); then
		local dir="$user_dotmgr_dir/actions-plumbing"
		local filename="$1"
	elif (( $# == 2)); then
		local dir="$user_dotmgr_dir/$1"
		local filename="$2"
	fi

	if ((EUID == 0)); then
		dir="$dir-sudo"
	fi

	local -a files=("$dir/"*"$filename"*)
	if (( ${#files[@]} == 0 )); then
		core.print_error "Failed to find file matching '$filename' in dir '$dir'"
		if ! util.confirm 'Continue?'; then
			exit 1
		fi
	else
		core.print_info "Executing ${files[0]}"
		FORCE_COLOR=3 _util.source_and_run_main "${files[0]}" "$@" \
			4>&1 1> >(
				while IFS= read -r line; do
					printf "  %s\n" "$line" >&4
				done; unset -v line
			) \
			5>&2 2> >(
				while IFS= read -r line; do
					printf "  %s\n" "$line" >&5
				done; unset -v line
			)
	fi
}
