# shellcheck shell=bash

subcmd() {
	if util.is_cmd apt; then
		util.log_info 'Updating, upgrading, and installing packages'
		sudo apt -y update
		sudo apt -y upgrade

		sudo apt -y install libssl-dev # for starship
		sudo apt -y install webext-browserpass

		sudo apt -y install rsync xclip
	elif util.is_cmd dnf; then
		util.log_info 'Updating, upgrading, and installing packages'
		sudo dnf -y update
		sudo dnf -y upgrade

		sudo dnf -y install openssl-devel # for starship
		# sudo dnf -y install browserpass

		sudo dnf -y install rsync xclip
	fi

	dotmgr module rust
	if ! util.is_cmd starship; then
		util.log_info 'Installing starship'
		cargo install starship
	fi

	util.log_info 'Installing Basalt packages globally'
	basalt global add hyperupcall/choose hyperupcall/autoenv hyperupcall/dotshellextract hyperupcall/dotshellgen
	basalt global add cykerway/complete-alias rcaloras/bash-preexec

	if [[ "$(</proc/sys/kernel/osrelease)" =~ 'WSL2' ]]; then
		util.log_info "Copying SSH keys from windows side"
		local name='Edwin'
		for file in "/mnt/c/Users/$name/.ssh"/*; do
			if [ ! -f "$file" ]; then
				continue
			fi

			if [[ "${file##*/}" = @(config|environment|known_hosts) ]]; then
				continue
			fi

			mkdir -vp ~/.ssh
			cp -v "$file" ~/.ssh
		done; unset file

		local gpgDir="/mnt/c/Users/$name/AppData/Roaming/gnupg"
		if [ -d "$gpgDir" ]; then
			gpg --homedir "$gpgDir" --armor --export-secret-key | gpg --import
		else
			util.log_warn "Skipping importing GPG keys as directory does not exist"
		fi
	else
		local gpgDir='/storage/ur/storage_other/gnupg'
		if [ -d "$gpgDir" ]; then
			gpg --homedir "$gpgDir" --armor --export-secret-key | gpg --import
		else
			util.log_warn "Skipping importing GPG keys as directory does not exist"
		fi
	fi
}
