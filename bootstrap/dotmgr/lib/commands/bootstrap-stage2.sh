# shellcheck shell=bash

subcmd() {
	if command -v apt &>/dev/null; then
		sudo apt -y update
		sudo apt -y upgrade

		sudo apt -y install libssl-dev
		sudo apt -y webext-browserpass

		sudo apt -y install rsync xclip
	elif command -v dnf &>/dev/null; then
		sudo dnf -y update
		sudo dnf -y upgrade

		sudo dnf -y install openssl-devel
		# sudo dnf -y install browserpass

		sudo dnf -y install rsync xclip

	fi


	dotmgr module rust
	cargo install starship

	basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
	basalt global add cykerway/complete-alias rcaloras/bash-preexec

	# TODO
	# - ssh keys
	# - gpg keys
	# - symlinking, /storage/ur mounting, if applicable
	# --- in ~/.bashrc, etc.
	declare dir="$1"

	# TODO
	: "${dir:=/storage/ur/storage_other/gnupg}"

	gpg --homedir "$dir" --armor --export-secret-key | gpg --import

	# check to see if programs are automatically installed
	check_bin dash
	# check_bin lesspipe.sh
	check_bin xclip
	check_bin exa
	check_bin rsync

	# misc
	if ! [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
			printf '%s\n' "https://edwin.dev OPEN"
	fi
}
