source "$XDG_DATA_HOME"/basalt/store/packages/github.com/rcaloras/bash-preexec\@*/bash-preexec.sh

# Executes after command is read, but before command execution.
preexec() {
	:
}

# Executes before each prompt.
precmd() {
	# For cdp().
	# shellcheck disable=SC2034
	_shell_cdp_dir="$PWD"
}
