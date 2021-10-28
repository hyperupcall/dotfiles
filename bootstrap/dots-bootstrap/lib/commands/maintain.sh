# shellcheck shell=bash

util_get_file() {
	if [[ ${1::1} == / ]]; then
		REPLY="$1"
	else
		REPLY="$HOME/$1"
	fi
}

# ensure file removed
must_rm() {
	util_get_file "$1"; local file="$REPLY"

	if [ -f "$file" ]; then
		if rm "$file"; then
			printf '%s\n' "$file REMOVED"
		fi
	fi
}

must_rm_dir() {
	util_get_file "$1"; local dir="$REPLY"

	if [ -d "$dir" ]; then
		if rmdir "$dir"; then
			printf '%s\n' "$dir REMOVED"
		fi
	fi
}

# ensure directory exists
must_dir() {
	if [ ! -d "$1" ]; then
		mkdir -p "$1"
		if [ "${1: -1}" != / ]; then
			set -- "$1/"
		fi
		printf '%s\n' "'$1' CREATED"
	fi
}

# ensure file exists
must_file() {
	if [ ! -f "$1" ]; then
		touch "$1"
		printf '%s\n' "'$1' CREATED"
	fi
}

# ensure a symlink points to a particular directory
must_link() {
	util_get_file "$1"; local src="$REPLY"
	util_get_file "$2"; local link="$REPLY"

	if [ -L "$link" ]; then
		if [ "$(readlink "$link")" != "$src" ]; then
			if ln -sfT "$src" "$link"; then
				printf '%s\n' "$link RE-SYMLINKED TO $src"
			else
				printf '%s\n' "FAILED must_link $link"
			fi
		fi
	else
		if [ -d "$link" ]; then
			rmdir "$link"
		fi

		if ln -sT "$src" "$link"; then
			printf '%s\n' "$link SYMLINKED TO $src"
		else
			printf '%s\n' "FAILED must_link $link"
		fi
	fi
}


#
# ─── MAIN ───────────────────────────────────────────────────────────────────────
#

# remove potentially autogenerated dotfiles
must_rm .bash_history
must_rm .flutter
must_rm .flutter_tool_state
must_rm .gitconfig
must_rm .gmrun_history
must_rm .inputrc
must_rm .lesshst
must_rm .mkshrc
must_rm .pulse-cookie
must_rm .pam_environment
must_rm .pythonhist
must_rm .sqlite_history
must_rm .viminfo
must_rm .wget-hsts
must_rm .zlogin
must_rm .zshrc
must_rm .zprofile
must_rm .zcompdump
must_rm "$XDG_CONFIG_HOME/zsh/.zcompdump"
must_rm_dir Desktop
must_rm_dir Documents
must_rm_dir Pictures
must_rm_dir Videos

# check to see if these directories exist (they shouldn't)
check_dot .elementary
check_dot .ghc # fixed in later releases
check_dot .npm
check_dot .old # used in bootstrap.sh
check_dot .profile-tmp # used in pre-bootstrap.sh
check_dot .scala_history_jline3

# check to see if programs are automatically installed
check_bin dash
check_bin lesspipe.sh
check_bin xclip
check_bin exa
check_bin rsync

# for programs that require a directory to exists before using it
must_dir "$XDG_STATE_HOME/history"
must_dir "$XDG_DATA_HOME/maven"
must_dir "$XDG_DATA_HOME"/vim/{undo,swap,backup}
must_dir "$XDG_DATA_HOME"/nano/backups
must_dir "$XDG_DATA_HOME/zsh"
must_dir "$XDG_DATA_HOME/X11"
must_dir "$XDG_DATA_HOME/xsel"
must_dir "$XDG_DATA_HOME/tig"
must_dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
must_dir "$XDG_DATA_HOME/gq/gq-state" # $GQ_STATE
must_dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
must_file "$XDG_CONFIG_HOME/yarn/config"
must_file "$XDG_DATA_HOME/tig/history"


# vscode save extensions
exts="$(code --list-extensions)"
if [[ $(wc -l <<< "$exts") -gt 10 ]]; then
	cat <<< "$exts" > ~/.dots/state/vscode-extensions.txt
fi

"${XDG_CONFIG_HOME:-$HOME/.config}/shell/scripts/generate-local-shellrcs.sh"
"${XDG_CONFIG_HOME:-$HOME/.config}/shell/scripts/generate-remote-shellrcs.sh"

# misc
if ! [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
		printf '%s\n' "https://edwin.dev OPEN"
fi