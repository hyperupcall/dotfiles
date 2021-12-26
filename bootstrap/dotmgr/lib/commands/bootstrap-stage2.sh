# shellcheck shell=bash

subcmd() {
	if [ ! -e '/proc/sys/kernel/osrelease' ]; then
		util.die "File '/proc/sys/kernel/osrelease' not found"
	fi

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
