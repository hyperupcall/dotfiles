# shellcheck shell=bash

_xclip() {
	COMPREPLY=()
	global_readline_debug

	local cmd

	# iterate over COMP_WORDS (ending at currently completed word)
	local i=1
	while [[ "$i" -lt "$COMP_CWORD" ]]; do
		local str="${COMP_WORDS[i]}"
		case "$str" in
		# special case for -selection
		-selection)
			cmd="$str"
			break
			;;
		esac
		(( i++ ))
	done

	case "$cmd" in
	-selection)
		local cur="${COMP_WORDS[COMP_CWORD]}"

		for i in "${!COMP_WORDS[@]}"; do
			local word="${COMP_WORDS[i]}"

			if [[ $word == "-selection" ]]; then
				local nextWord="${COMP_WORDS[i+1]}"

				# test to see if the next word is blank (-selection has been completed,
				# but we have not typed anything after that

				# also test to see if we are currently completing -selection, by testing if
				# two indexes after -selection is out of bounds of the completion array.
				# if it is, it means we are currently completing -selection
				# TODO (bug): if we have the command typed, but go back to -selection and change
				# it, autocomplete will not work

				if [[ -z $nextWord ]] || [[ $((i+2)) -ge ${#COMP_WORDS[@]} ]]; then
					readarray -t COMPREPLY < <(compgen -o default -W "primary secondary clipboard buffer-cut" -- "$cur")
					return
				fi
			fi
		done
		;;
	esac

	# check if we're completion command name
	if [[ "$i" -eq "$COMP_CWORD" ]]; then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		readarray -t COMPREPLY < <(compgen -o default -W "-i -in -o -out -l -loops -d -display -h -help -selection -noutf8 -target -rmlastnl -version -silent -quiet -verbose" -- "$cur")
		return
	fi
}

complete -F _xclip xclip
