# shellcheck shell=bash

if ! [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
		echo "https://edwin.dev OPEN"
fi

# shellcheck disable=SC2088
{
	rm ~/.zlogin && echo '~/.zlogin removed'
	rm ~/.zshrc && echo '~/.zshrc removed'
	rm ~/.zprofile && echo '~/.zprofile removed'
	rm ~/.mkshrc && echo '~/.mkshrc removed'
} 2>/dev/null

# directories existance as a prerequisite for usage
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
)
