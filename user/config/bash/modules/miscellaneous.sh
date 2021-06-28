# shellcheck shell=bash

# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# even though we `source /etc/profile` at beginnning of script, this is still needed since we now
# only have BASH_COMPLETION_USER_DIR and BASH_COMPLETION_USER_FILE set
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# basher
eval "$(basher init - bash | grep -v 'export PATH')"

# bashmarks
# [ -r ~/.local/bin/bashmarks.sh ] && source ~/.local/bin/bashmarks.sh

# conda
# eval "$("$XDG_DATA_HOME/miniconda3/bin/conda" shell.bash hook)"
# _path_prepend "$XDG_DATA_HOME/miniconda3/bin"

# dircolors
[ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ] && eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# direnv
eval "$(direnv hook bash)"

# bash-preexec
source "$(basher package-path rcaloras/bash-preexec)/bash-preexec.sh"

preexec() {
	# after command is read, before command execution
	:
}

precmd() {
	# before each prompt

	# for cdp()
	# shellcheck disable=SC2034
	_shell_cdp_dir="$PWD"
}

# sdkman
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"
