# shellcheck shell=bash

subcmd() {
	if util.is_cmd apt; then
		sudo apt -y update
		sudo apt -y upgrade

		sudo apt -y install libssl-dev # for starship
		sudo apt -y install webext-browserpass

		sudo apt -y install rsync xclip
	elif util.is_cmd dnf; then
		sudo dnf -y update
		sudo dnf -y upgrade

		sudo dnf -y install openssl-devel # for starship
		# sudo dnf -y install browserpass

		sudo dnf -y install rsync xclip
	fi

	dotmgr module rust

	if ! util.is_cmd starship; then
		cargo install starship
	fi

	# basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
	# basalt global add cykerway/complete-alias rcaloras/bash-preexec

	if [[ "$(</proc/sys/kernel/osrelease)" =~ 'WSL2' ]]; then
		util.log_info "Detected WSL"

		if util.is_cmd apt; then
			sudo apt -y install socat
		elif util.is_cmd dnf; then
			sudo dnf -y install socat
		fi

		local name='Edwin'
		for file in "/mnt/c/Users/$name/.ssh"/*; do
			if [ "${file##*/}" = 'config' ] || [ "${file##*/}" = 'environment' ]; then
				continue
			fi

			mkdir -vp ~/.ssh
			cp -v "$file" ~/.ssh
		done; unset file

		gpgDir="/mnt/c/Users/$name/.gnupg"
		if [ -d "$gpgDir" ]; then
			gpg --homedir "$gpgDir" --armor --export-secret-key | gpg --import
		else
			util.log_warn "Skipping importing GPG keys as directory does not exist"
		fi
	else
		gpgDir='/storage/ur/storage_other/gnupg'
		if [ -d "$gpgDir" ]; then
			gpg --homedir "$gpgDir" --armor --export-secret-key | gpg --import
		else
			util.log_warn "Skipping importing GPG keys as directory does not exist"
		fi
	fi
}
