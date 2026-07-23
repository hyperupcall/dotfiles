#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	local mode=
	while :; do
		local options='save|restore'
		read -re -p "Which mode? ($options): " mode
		if [[ $mode == @($options) ]]; then
			break
		fi
	done

	local -a options=()
	while IFS= read -r line; do
		if [[ $line == *DEBUG:* ]]; then
			local option=${line##*:}
			options+=("${option/%\"]/}")
		else
			printf '%s\n' "$line"
		fi
	done < <(
		lsblk --list --json --output ID,FSSIZE,FSTYPE,MODEL,PATH,NAME,LABEL,MOUNTPOINT | jq -r '
		[
			.blockdevices[] | select(.mountpoint != null and (.mountpoint | test("^/mnt|/media|/run")))
		]
			| to_entries[]
			| debug("\(.key):\(.value.mountpoint)")
			| "#\(.key)\n  ID: \(.value.id[:50])...\n  MOUNTPOINT: \(.value.mountpoint) (\(.value.path))\n  SIZE: \(.value.fssize) (\(.value.fstype))"
		' 2>&1
	)

	options+=('__manual__')
	printf '#%d\n  MOUNTPOINT: (specify manually)\n' $((${#options[@]} - 1))

	local answer=
	while :; do
		read -re -p 'Choose directory for temporary files: ' answer
		if [[ $answer =~ ^[0-9]+$ ]] && ((answer >= 0)) && ((answer < ${#options[@]})); then
			break
		fi
	done

	local device_path_is_manual=false device_path="${options[$answer]}"
	if [ "$device_path" = '__manual__' ]; then
		device_path_is_manual=true
		read -re -p 'Enter directory path: ' device_path
	fi
	local dirpath=${device_path%/}/_data

	if [ ! -f "$HOME/.dotfiles/config/setup-private.sh" ]; then
		local tmp_gnupg_dir=
		tmp_gnupg_dir=$(mktemp -d --suffix='-gnupg')
		gpg --homedir "$tmp_gnupg_dir" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --no-symkey-cache --decrypt "$dirpath/setup_private_sh.tar.gz.asc" 3<<<"$(cat "$dirpath/pw.txt")" | tar -xO >"$HOME/.dotfiles/config/setup-private.sh"
	fi
	source "$HOME/.dotfiles/config/setup-private.sh"

	local -A paths_encrypt=(
		[gnupg]="$HOME/.gnupg"
		[ssh]="$HOME/.ssh"
		[history]="$XDG_STATE_HOME/history"
		[borgkeys]="$XDG_CONFIG_HOME/borg/keys"
		[basalt_token]="$XDG_CONFIG_HOME/basalt/token"
		[woof_token]="$XDG_DATA_HOME/woof/token"
		[scripts_hidden]="$_private_scripts_hidden"
		[setup_private_exec_sh]="$HOME/.dotfiles/config/setup-private-exec.sh"
		[setup_private_py]="$HOME/.dotfiles/config/setup-private.py"
		[setup_private_sh]="$HOME/.dotfiles/config/setup-private.sh"
		[dotfiles_git_exclude]="$HOME/.dotfiles/.git/info/exclude"
	)
	local -A paths=(
		[libreoffice]="$XDG_CONFIG_HOME/libreoffice/4/user"
		[fonts]="$XDG_DATA_HOME/fonts"
		[dbeaver]="$XDG_DATA_HOME/DBeaverData/workspace6/General/Scripts"
		[ankiuserdata]="$XDG_DATA_HOME/Anki2/Default User"
		[ankiaddons]="$XDG_DATA_HOME/Anki2/addons21"
		[applicationsdir]="$HOME/Other/Application Data"
		[devresources]="$HOME/.devhidden"
	)

	if [ "$mode" = save ]; then
		sudo rm -rf "$dirpath"
		sudo mkdir -p "$dirpath"
		sudo chown "$USER:$USER" "$dirpath"

		cp -f ~/.dotfiles/scripts/transfer-data.sh "$dirpath/transfer-data.sh"
		cp -f ~/.dotfiles/bootstrap-linux.sh "$dirpath/bootstrap.sh"
		chmod +x "$dirpath/transfer-data.sh" "$dirpath/bootstrap.sh"

		local password= temp_gnupg=
		password=$(LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c 14)
		temp_gnupg=$(mktemp -d --suffix='-gnupg')
		mkdir -p "$temp_gnupg"
		core.print_info "Password: $password"

		local save_pw_answer=
		read -rN1 -p 'Save password to _data/pw.txt? [y/n] ' save_pw_answer
		printf '\n'
		if [[ $save_pw_answer =~ ^[Yy] ]]; then
			mkdir -p "$dirpath"
			printf '%s\n' "$password" >"$dirpath/pw.txt"
			core.print_info "Password written to $dirpath/pw.txt"
		fi

		for name in "${!paths_encrypt[@]}"; do
			local dir="${paths_encrypt[$name]}"
			local encrypted_file="$dirpath/$name.tar.gz.asc"

			core.print_info "Encrypting $dir to $encrypted_file"
			mkdir -p "${encrypted_file%/*}"
			tar -C "${dir%/*}" -c "./${dir##*/}" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --symmetric 3<<<"$password" \
				| cat >"$encrypted_file"
		done

		for name in "${!paths[@]}"; do
			local dir="${paths[$name]}"
			local src="$dirpath/$name.tar.gz"

			core.print_info "Copying $dir to $src"
			mkdir -p "${src%/*}"
			# The directory may contain symlinks, so copy as tarball so it is always preserved, no matter the file system.
			tar -C "$dir" -cf "$src" .
		done

	elif [ "$mode" = restore ]; then
		local password= pw_file="$dirpath/pw.txt"
		if [ -f "$pw_file" ]; then
			password=$(<"$pw_file")
			core.print_info "Using password from $pw_file"
		else
			read -re -p 'Password? ' password
		fi

		local temp_gnupg=
		temp_gnupg=$(mktemp -d --suffix='-gnupg')

		for name in "${!paths_encrypt[@]}"; do
			local dir="${paths_encrypt[$name]}"
			local encrypted_file="$dirpath/$name.tar.gz.asc"

			if [ "$dir" = scripts_hidden ]; then
				continue
			fi

			if [ -e "$dir" ]; then
				core.print_warn "File or directory $dir already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_warn "Skipping directory $dir"
					continue
				fi
			else
				read -rN1 -p "Copy to $dir? [y/n] " answer
				printf '\n'
				if ! [[ $answer =~ ^[Yy] ]]; then
					core.print_warn "Skipping directory $dir"
					continue
				fi
			fi

			core.print_info "Decrypting $encrypted_file to $dir"
			mkdir -p "${dir%/*}"
			cat "$encrypted_file" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --decrypt 3<<<"$password" \
				| tar -C "${dir%/*}" -x

			# Ensure that no broken symlinks are copied over.
			if [ -d "$dir" ]; then
				local file=
				for file in "$dir"/*; do
					if [ -L "$file" ] && [ ! -e "$file" ]; then
						unlink "$file"
					fi
				done
			fi
		done

		for name in "${!paths[@]}"; do
			local dir="${paths[$name]}"
			local src="$dirpath/$name.tar.gz"

			if [ -e "$dir" ]; then
				core.print_warn "File or directory $dir already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_warn "Skipping directory $dir"
					continue
				fi
			else
				read -rN1 -p "Copy to $dir? [y/n] " answer
				printf '\n'
				if ! [[ $answer =~ ^[Yy] ]]; then
					core.print_warn "Skipping directory $dir"
					continue
				fi
			fi

			core.print_info "Extracting $src to $dir"
			mkdir -p "$dir"
			# The directory may contain symlinks, so copy as tarball so it is always preserved, no matter the file system.
			tar -C "$dir" -xf "$src"
		done
	else
		core.print_die "Invalid mode: $mode"
	fi

	read -rN1 -p "Done! Would you like to unmount ${dirpath%/*} " answer
	printf '\n'
	if [[ $answer =~ ^[Yy] ]]; then
		sudo umount "${dirpath%/*}"
	fi

	core.print_info "Exiting."
}

util.if_file_sourced || _main "$@"
