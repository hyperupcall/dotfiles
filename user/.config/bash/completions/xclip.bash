# shellcheck shell=bash

# TODO: BUG: after completing option, if click space and <tab> will rewrite the
# current option

# TODO: BUG: since xclip affects files, should only offer option autocomplete
# if type dash

_xclip() {
	COMPREPLY=()
	global_readline_debug

	local cur="${COMP_WORDS[COMP_CWORD]}"
	local bef="${COMP_WORDS[COMP_CWORD-1]}"
	if [[ $bef == "-selection" ]]; then
		[[ $cur = -* ]] && cur=""

		readarray -t COMPREPLY < <(compgen -o default -W "primary secondary clipboard buffer-cut" -- "$cur")
		return
	fi


	local cur="${COMP_WORDS[COMP_CWORD]}"
	readarray -t COMPREPLY < <(compgen -o default -W "-i -in -o -out -l -loops -d -display -h -help -selection -noutf8 -target -rmlastnl -version -silent -quiet -verbose" -- "$cur")
}

complete -F _xclip xclip
