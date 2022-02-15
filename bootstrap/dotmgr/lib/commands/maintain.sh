# shellcheck shell=bash

find_mnt_usb() {
	local usb_partition_uuid=$1

	local block_dev="/dev/disk/by-uuid/$usb_partition_uuid"
	if [ ! -e "$block_dev" ]; then
		util.die "USB Not plugged in"
	fi

	local block_dev_target=
	if ! block_dev_target="$(findmnt -no TARGET "$block_dev")"; then
		# 'findmnt' exits failure if cannot find block device. We account
		# for that case with '[ -z "$block_dev_target" ]' below
		:
	fi

	# If the USB is not already mounted
	if [ -z "$block_dev_target" ]; then
		if mountpoint -q /mnt; then
			util.die "Directory '/mnt' must not already be a mountpoint"
		fi

		util.run sudo mount "$block_dev" /mnt

		if ! block_dev_target="$(findmnt -no TARGET "$block_dev")"; then
			util.die "Automount failed"
		fi
	fi

	REPLY=$block_dev_target
}

subcmd() {
	while :; do
		printf '%s' "What would you like to do?
(0): Quit
(1): Encrypt secrets
       This exports gpg keys, ssh keys, and the pass database to your 'secrets' USB. Everything is
       encrypted with a passphrase. This script Just Works, whether or not the USB is already mounted
(2): Import secrets
       This imports your GPG keys. It imports it from your shared drive mounted
       under /storage
(3): Prune and symlinks
       Prunes the homefolder for improper dotfiles like '~/.bash_history'. It also makes directories
       required for things to work properly like '~/.config/yarn/config'. Lastly, it also symlinks
       directories that are out of the scope of dotfox. More specifically, this symlinks the XDG user
       directories, ~/.ssh, ~/.config/BraveSoftware, etc. to the shared drive mounted under /storage
(4): Save VSCode extensions
(5): dotshellextract (TODO)
(6): dotshellgen (TODO)
> "
		if ! IFS= read -rN1; then
			die "Failed to get input"
		fi
		printf '\n'

		case "$REPLY" in
			$'\x04'|0|q) exit 0 ;;
			1) do_export_secrets ;;
			2) do_import_secrets ;;
			3) do_prune_and_symlink ;;
			4) do_extensions ;;
			*) printf '%s\n' "Invalid option. Try again"
		esac
	done
}

do_export_secrets() {
	util.ensure_bin expect
	util.ensure_bin age
	util.ensure_bin age-keygen

	sudo -v

	find_mnt_usb '6044-5CC1' # WET
	local block_dev_target=$REPLY

	# Now, file system is mounted at "$block_dev_target"

	local password=
	password="$(LC_ALL=C tr -dc '[:alnum:][:digit:]' </dev/urandom | head -c 12; printf '\n')"
	util.log_info "Password: $password"

	# Copy over ssh keys
	local -r sshDir="$HOME/.ssh"
	local -a sshKeys=(environment config github github.pub)
	if [ -d "$sshDir" ]; then
		exec 4> >(sudo tee "$block_dev_target/ssh-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			cd "$sshDir"
			tar -c ${sshKeys[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			util.die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		util.log_warn "Skipping copying ssh keys"
	fi

	# Copy over gpg keys
	local -r fingerprints=('6EF89C3EB889D61708E5243DDA8EF6F306AD2CBA' '4C452EC68725DAFD09EC57BAB2D007E5878C6803')
	local gpgDir="$HOME/.gnupg"
	if [ -d "$gpgDir" ]; then
		exec 4> >(sudo tee "$block_dev_target/gpg-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			gpg --export-secret-keys --armor ${fingerprints[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			util.die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		util.log_warn "Skipping copying gpg keys"
	fi
}

do_import_secrets() {
	local -r fingerprints=('6EF89C3EB889D61708E5243DDA8EF6F306AD2CBA' '4C452EC68725DAFD09EC57BAB2D007E5878C6803')

	if [ ! -e '/proc/sys/kernel/osrelease' ]; then
		util.die "File '/proc/sys/kernel/osrelease' not found"
	fi

	if [[ "$(</proc/sys/kernel/osrelease)" =~ 'WSL2' ]]; then
		# WSL
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
			gpg --homedir "$gpgDir" --armor --export-secret-key "${fingerprints[@]}" | gpg --import
		else
			util.log_warn "Skipping importing GPG keys as directory does not exist"
		fi
	else
		# Not WSL
		local gpgDir='/storage/ur/storage_other/gnupg'
		if [ -d "$gpgDir" ]; then
			gpg --homedir "$gpgDir" --armor --export-secret-key "${fingerprints[@]}" | gpg --import
		else
			util.log_warn "Skipping importing GPG keys from /storage/ur subdirectory"

			find_mnt_usb '6044-5CC1' # WET
			local block_dev_target=$REPLY

		fi
	fi
}

do_prune_and_symlink() {
	util_get_file() {
		if [[ ${1::1} == / ]]; then
			REPLY="$1"
		else
			REPLY="$HOME/$1"
		fi
	}

	must_rm() {
		util_get_file "$1"
		local file="$REPLY"

		if [ -f "$file" ]; then
			if rm -f "$file"; then
				util.log_info "Removed file '$file'"
			else
				util.log_warn "Failed to remove file '$file'"
			fi
		fi
	}

	must_rmdir() {
		util_get_file "$1"
		local dir="$REPLY"

		if [ -d "$dir" ]; then
			if rmdir "$dir"; then
				util.log_info "Removed directory '$dir'"
			else
				util.log_warn "Failed to remove directory '$dir'"
			fi
		fi
	}

	must_dir() {
		util_get_file "$1"
		local dir="$REPLY"

		if [ ! -d "$dir" ]; then
			if mkdir -p "$dir"; then
				util.log_info "Created directory '$dir'"
			else
				util.log_warn "Failed to create directory '$dir'"
			fi
		fi
	}

	must_file() {
		util_get_file "$1"
		local file="$REPLY"

		if [ ! -f "$file" ]; then
			if mkdir -p "${file%/*}" && touch "$file"; then
				util.log_info "Created file '$file'"
			else
				util.log_warn "Failed to create file '$file'"
			fi
		fi
	}

	must_link() {
		util_get_file "$1"
		local src="$REPLY"

		util_get_file "$2"
		local link="$REPLY"

		if [ -d "$link" ] && [ ! -L "$link" ]; then
			local children=("$link"/*)
			if (( ${#children[@]} == 0)); then
				rmdir "$link"
			else
				util.log_warn "Skipping symlink from '$src' to '$link'"
				return
			fi
		fi
		if [ ! -e "$src" ]; then
			util.log_warn "Failed to symlink '$src' to $link"
			return
		fi

		if ln -sfT "$src" "$link"; then
			util.log_info "Symlinking '$src' to $link"
		else
			util.log_warn "Failed to symlink '$src' to '$link'"
		fi
	}

	check_dot() {
		if [ -e "$HOME/$1" ]; then
			util.log_warn "File or directory '$1' exists"
		fi
	}

	if ! [[ -v 'XDG_CONFIG_HOME' && -v 'XDG_DATA_HOME' && -v 'XDG_STATE_HOME' ]]; then
		printf '%s\n' "Error: XDG Variables must be set"
		exit 1
	fi


	if ! [[ -v 'XDG_CONFIG_HOME' && -v 'XDG_DATA_HOME' && -v 'XDG_STATE_HOME' ]]; then
		printf '%s\n' "Error: XDG Variables must be set"
		exit 1
	fi

	# Remove appended items to dotfiles
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-$HOME}/.zshrc" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		util.log_info "Cleaning '$file'"

		local file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done < "$file"; unset line

		printf '%s' "$file_string" > "$file"
	done; unset file

	# Create symlinks
	declare storage_home='/storage/ur/storage_home'
	declare storage_other='/storage/ur/storage_other'
	must_link "$storage_home/Dls" "$HOME/Dls"
	must_link "$storage_home/Docs" "$HOME/Docs"
	must_link "$storage_home/Music" "$HOME/Music"
	must_link "$storage_home/Pics" "$HOME/Pics"
	must_link "$storage_home/Vids" "$HOME/Vids"
	must_link "$storage_other/mozilla" "$HOME/.mozilla"
	must_link "$storage_other/ssh" "$HOME/.ssh"
	must_link "$storage_other/BraveSoftware" "$XDG_CONFIG_HOME/BraveSoftware"
	must_link "$storage_other/calcurse" "$XDG_CONFIG_HOME/calcurse"
	must_link "$storage_other/fonts" "$XDG_CONFIG_HOME/fonts"
	must_link "$storage_other/password-store" "$XDG_DATA_HOME/password-store"

	must_link "$HOME/.dots/user/scripts" "$HOME/scripts"
	must_link "$HOME/Docs/Programming/challenges" "$HOME/challenges"
	must_link "$HOME/Docs/Programming/experiments" "$HOME/experiments"
	must_link "$HOME/Docs/Programming/git" "$HOME/git"
	must_link "$HOME/Docs/Programming/repos" "$HOME/repos"
	must_link "$HOME/Docs/Programming/workspaces" "$HOME/workspaces"
	must_link "$XDG_CONFIG_HOME/X11/Xmodmap" "$HOME/.Xmodmap"

	# Create directories for programs that require a directory to exist to use it
	must_dir "$XDG_STATE_HOME/history"
	must_dir "$XDG_DATA_HOME/maven"
	must_dir "$XDG_DATA_HOME"/vim/{undo,swap,backup}
	must_dir "$XDG_DATA_HOME"/nano/backups
	must_dir "$XDG_DATA_HOME/zsh"
	must_dir "$XDG_DATA_HOME/X11"
	must_dir "$XDG_DATA_HOME/xsel"
	must_dir "$XDG_DATA_HOME/tig"
	must_dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
	must_dir "$XDG_CONFIG_HOME/less" # $LESSKEY
	must_dir "$XDG_DATA_HOME/gq/gq-state" # $GQ_STATE
	must_dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
	must_dir "$XDG_DATA_HOME/nvm"
	must_file "$XDG_CONFIG_HOME/yarn/config"
	must_file "$XDG_DATA_HOME/tig/history"


	# Remove autogenerated dotfiles
	must_rm .bash_history
	must_rm .flutter
	must_rm .flutter_tool_state
	must_rm .gitconfig
	must_rm .gmrun_history
	must_rm .inputrc
	must_rm .lesshst
	must_rm .mkshrc
	must_rm .pulse-cookie
	must_rm .pythonhist
	must_rm .sqlite_history
	must_rm .viminfo
	must_rm .wget-hsts
	must_rm .zlogin
	must_rm .zshrc
	must_rm .zprofile
	must_rm .zcompdump
	must_rm "$XDG_CONFIG_HOME/zsh/.zcompdump"
	must_rmdir Desktop
	must_rmdir Documents
	must_rmdir Pictures
	must_rmdir Videos


	# check to see if these directories exist (they shouldn't)
	check_dot .elementary
	check_dot .ghc # Fixed in later releases
	check_dot .npm
	check_dot .scala_history_jline3

	# Miscellaneous
	chmod 0700 ~/.gnupg

	# Remove broken symlinks
	for file in "$HOME"/*; do
		if [ -L "$file" ] && [ ! -e "$file" ]; then
			unlink "$file"
		fi
	done; unset file
}

do_extensions() {
	exts="$(code --list-extensions)"
	if [[ $(wc -l <<< "$exts") -gt 10 ]]; then
		cat <<< "$exts" > ~/.dots/state/vscode-extensions.txt
	fi
}
