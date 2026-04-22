#!/usr/bin/env bash
source ~/.dotfiles/data/setup.sh

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

	local mnt_index=${#options[@]}
	options+=('/mnt/_temp')
	printf '#%d\n  MOUNTPOINT: %s\n' "$mnt_index" "${options[${#options[@]}-1]}"

	local answer=
	while :; do
		read -re -p 'Choose directory to put temporary file: ' answer
		if [[ $answer =~ [0-9]+ ]] && ((answer >= 0)) && ((answer < ${#options[@]})); then
			break
		fi
	done

	local device_path="${options[$answer]}"
	local -A dirs_encrypt=(
		[gnupg]="$HOME/.gnupg"
		[ssh]="$HOME/.ssh"
		[history]="$XDG_STATE_HOME/history"
		[borgkeys]="$XDG_CONFIG_HOME/borg/keys"
	)
	local -A dirs=(
		[libreoffice]="$XDG_CONFIG_HOME/libreoffice/4/user"
		[fonts]="$XDG_DATA_HOME/fonts"
		[dbeaver]="$XDG_DATA_HOME/DBeaverData/workspace6/General/Scripts"
		[scripts-hidden]="$_private_scripts_hidden"
		[ankiuserdata]="$XDG_DATA_HOME/Anki2/Default User"
		[ankiaddons]="$XDG_DATA_HOME/Anki2/addons21"
		[applicationsdir]="$HOME/Other/Application Data"
		[devresources]="$HOME/.devresources"
	)

	if [ "$mode" = save ]; then
		if [ "$device_path" = '/mnt/_temp' ]; then
			sudo rm -rf "$device_path"
			sudo mkdir -p "$device_path"
			sudo chown "$USER:$USER" "$device_path"
		fi

		local password= temp_gnupg=
		password=$(LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c 14)
		temp_gnupg=$(mktemp -d --suffix '-gnupg')
		mkdir -p "$temp_gnupg"
		core.print_info "Password: $password"

		for name in "${!dirs_encrypt[@]}"; do
			local dir="${dirs_encrypt[$name]}"
			local encrypted_file="$device_path/_data/$name.asc"

			core.print_info "Encrypting \"$dir\" to \"$encrypted_file\""
			mkdir -p "${encrypted_file%/*}"
			tar -C "${dir%/*}" -c "./${dir##*/}/" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --symmetric 3<<<"$password" \
				| cat >"$encrypted_file"
		done

		for name in "${!dirs[@]}"; do
			local dir="${dirs[$name]}"
			local dest="$device_path/_dirs/$name"

			core.print_info "Copying \"$dir\" to \"$dest\""
			mkdir -p "${dest%/*}"
			cp -rT "$dir" "$dest"
		done

	elif [ "$mode" = restore ]; then
		local password=
		read -re -p 'Password? ' password

		local temp_gnupg=
		temp_gnupg=$(mktemp -d --suffix '-gnupg')

		for name in "${!dirs_encrypt[@]}"; do
			local dir="${dirs_encrypt[$name]}"
			local encrypted_file="$device_path/_data/$name.asc"

			if [ -e "$dir" ]; then
				core.print_warn "File or directory \"$dir\" already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_die "Directory must not exist"
				fi
			fi

			core.print_info "Decrypting \"$encrypted_file\" to \"$dir\""
			cat "$encrypted_file" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --decrypt 3<<<"$password" \
				| tar -C "${dir%/*}" -x

			# Ensure that no broken symlinks are copied over.
			local file=
			for file in "$dir"/*; do
				if [ -L "$file" ] && [ ! -e "$file" ]; then
					unlink "$file"
				fi
			done

			rm "$encrypted_file"
		done
		rmdir "${encrypted_file%/*}"

		for name in "${!dirs[@]}"; do
			local dir="${dirs[$name]}"
			local src="$device_path/_dirs/$name"

			if [ -e "$dir" ]; then
				core.print_warn "File or directory \"$dir\" already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_die "Directory must not exist"
				fi
			fi

			core.print_info "Copying \"$src\" to \"$dir\""
			mkdir -p "${dir%/*}"
			cp -rT "$src" "$dir"
		done

		if [ "$device_path" = '/mnt/_temp' ]; then
			sudo rmdir "$device_path"
		fi
	else
		core.print_die "Invalid mode: \"$mode\""
	fi
}

util.if_file_sourced || _main "$@"
