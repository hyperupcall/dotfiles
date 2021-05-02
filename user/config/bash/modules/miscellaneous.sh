# shellcheck shell=bash

# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# even though we `source /etc/profile` at beginnning of script, this is still needed since we now
# only have BASH_COMPLETION_USER_DIR and BASH_COMPLETION_USER_FILE set
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# bashmarks
# [ -r ~/.local/bin/bashmarks.sh ] && source ~/.local/bin/bashmarks.sh

# dircolors
[ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ] && eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# completion debugging
_global_completion_debug() {
	echo
	echo "----- debug start -----"
	echo "#COMP_WORDS=${#COMP_WORDS[@]}"
	echo "COMP_WORDS=("
	for x in "${COMP_WORDS[@]}"; do
		echo "  '$x'"
	done
	echo ")"
	echo "COMP_CWORD=${COMP_CWORD}"
	echo "COMP_LINE='${COMP_LINE}'"
	echo "COMP_POINT=${COMP_POINT}"
	echo "cur: '${COMP_WORDS[COMP_CWORD]}'"
	echo "COMP_KEY=${COMP_KEY}"
	echo "COMP_TYPE=${COMP_TYPE}"
	echo "----- debug end -----"
}

# direnv
eval "$(direnv hook bash)"

# TODO: put last executed command in title
# preexec / precmd
preexec() {
	:
}

precmd() {
	:
}
