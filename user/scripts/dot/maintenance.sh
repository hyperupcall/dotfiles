# shellcheck shell=bash

if ! [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
		echo "https://edwin.dev OPEN"
fi

# shellcheck disable=SC2088
dot_rm() {
	rm ~/"$1" && echo "~/$1 removed"
}

dot_check() {
	# shellcheck disable=SC2088
	test -e ~/"$1" && echo "~/$1 exists?"
}


{
	dot_rm .zlogin
	dot_rm .zshrc
	dot_rm .zprofile
	dot_rm .mkshrc
	dot_rm .bash_history

	dot_check .gnupg
	dot_check .pulse-cookie
	dot_check .scala_history_jline3
} 2>/dev/null

# directories existence as a prerequisite for usage
(
	m() {
		[ -d "$1" ] || {
			mkdir -p "$1"
			echo "$1" created
		}
	}

	m "$XDG_DATA_HOME/maven"
	m "$XDG_DATA_HOME"/vim/{undo,swap,backup}
	m "$XDG_DATA_HOME"/nano/backups
	m "$XDG_DATA_HOME/zsh"
)
