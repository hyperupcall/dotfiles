#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

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
			options+=("${option/%\"]}")
		else
			printf '%s\n' "$line"
		fi
	done < <(
		lsblk --list --json --output ID,FSSIZE,FSTYPE,MODEL,PATH,NAME,LABEL,MOUNTPOINT \
			| jq -r '
		[
			.blockdevices[] |
			select(.mountpoint != null and (.mountpoint | test("^/mnt|/media|/run")))
		]
			| to_entries[]
			| debug("\(.key):\(.value.mountpoint)")
			| "#\(.key)\n  ID: \(.value.id[:50])...\n  MOUNTPOINT: \(.value.mountpoint) (\(.value.path))\n  SIZE: \(.value.fssize) (\(.value.fstype))"
		' 2>&1
	)

	local answer=
	while :; do
		read -re -p 'Choose #: ' answer
		if [[ $answer =~ [0-9]+ ]] && ((answer >= 0)) && ((answer < ${#options[@]})); then
			break
		fi
	done

	local device_path="${options[$choice]}"
	local -A dirs=(
		[gnupg]="$HOME/.gnupg"
		[ssh]="$HOME/.ssh"
	)

	if [ "$mode" = save ]; then
		local pasword= temp_gnupg=
		password=$(LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c 14)
		temp_gnupg=$(mktemp -d --suffix '-gnupg')
		mkdir -p "$temp_gnupg"
		core.print_info "Password: $password"
		for name in "${!dirs[@]}"; do
			local dir="${dirs[$name]}"
			local encrypted_file="$device_path/$name.asc"

			core.print_info "Encrypting \"$dir\" to \"$encrypted_file\""
			tar -C "${dir%/*}" -c "./${dir##*/}/" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --symmetric 3<<< "$password" \
				| cat > "$encrypted_file"
		done

		core.print_info "Ejecting \"$device_path\""
		if [ "$device_path" = '/mnt' ]; then
			sudo umount "$device_path"
		else
			umount "$device_path"
		fi
	elif [ "$mode" = restore ]; then
		local password=
		read -re -p 'Password? ' password
		for name in "${!dirs[@]}"; do
			local dir="${dirs[$name]}"
			local encrypted_file="$device_path/$name.asc"

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
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --decrypt 3<<< "$password" \
				| tar -C "${dir%/*}" -x
		done
	else
		core.print_die "Invalid mode: \"$mode\""
	fi
}

util.if_file_sourced || main "$@"
