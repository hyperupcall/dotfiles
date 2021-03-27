# shellcheck shell=bash

# TODO: -selection: primary, secondary, clipboard, buffer-cut
_xclip() {
	local i=1 cmd

	# iterate over COMP_WORDS (ending at currently completed word)
	# this ensures we bm_get command completion even after passing flags
	while [[ "$i" -lt "$COMP_CWORD" ]]; do
		local s="${COMP_WORDS[i]}"
		case "$s" in
		# if our current word starts with a '-', it is not a subcommand
		-*) ;;
		# we are completing a subcommand, set cmd
		*)
			cmd="$s"
			break
			;;
		esac
		(( i++ ))
	done

	# check if we're completing 'dotty'
	if [[ "$i" -eq "$COMP_CWORD" ]]; then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		# shellcheck disable=SC2207
		COMPREPLY=($(compgen -o default -W "-i -in -o -out -l -loops -d -display -h -help -selection -noutf8 -target -rmlastnl -version -silent -quiet -verbose" -- "$cur"))
		return
	fi

	# if we're not completing 'xclip', then we're completing a subcommand
	case "$cmd" in
	*)
		COMPREPLY=() ;;
	esac

} && complete -F _xclip xclip
