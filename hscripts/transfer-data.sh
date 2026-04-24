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
	printf '#%d\n  MOUNTPOINT: (specify manually)\n' $((${#options[@]}-1))

	local answer=
	while :; do
		read -re -p 'Choose directory to put temporary file: ' answer
		if [[ $answer =~ [0-9]+ ]] && ((answer >= 0)) && ((answer < ${#options[@]})); then
			break
		fi
	done

	local device_path_is_manual=false device_path="${options[$answer]}"
	if [ "$device_path" = '__manual__' ]; then
		device_path_is_manual=true
		read -re -p 'Enter directory path: ' device_path
	fi
	device_path=${device_path%/}
	local -A paths=(
		[libreoffice]="$XDG_CONFIG_HOME/libreoffice/4/user"
		[fonts]="$XDG_DATA_HOME/fonts"
		[dbeaver]="$XDG_DATA_HOME/DBeaverData/workspace6/General/Scripts"
		[ankiuserdata]="$XDG_DATA_HOME/Anki2/Default User"
		[ankiaddons]="$XDG_DATA_HOME/Anki2/addons21"
		[applicationsdir]="$HOME/Other/Application Data"
		[devresources]="$HOME/.devresources"
	)
	local -A paths_encrypt=(
		[gnupg]="$HOME/.gnupg"
		[ssh]="$HOME/.ssh"
		[history]="$XDG_STATE_HOME/history"
		[borgkeys]="$XDG_CONFIG_HOME/borg/keys"
		[basalt_token]="$XDG_CONFIG_HOME/basalt/token"
		[woof_token]="$XDG_DATA_HOME/woof/token"
		[scripts_hidden]="$_private_scripts_hidden"
		[setup_private_exec_sh]="$HOME/.dotfiles/config/setup-private-exec.sh"
		[setup_private_pl]="$HOME/.dotfiles/config/setup-private.pl"
		[setup_private_sh]="$HOME/.dotfiles/config/setup-private.sh"
		[dotfiles_git_exclude]="$HOME/.dotfiles/.git/info/exclude"
	)

	if [ "$mode" = save ]; then
		if [ "$device_path_is_manual" = true ]; then
			sudo rm -rf "$device_path/_data"
			sudo mkdir -p "$device_path/_data"
			sudo chown "$USER:$USER" "$device_path/_data"
		fi

		local password= temp_gnupg=
		password=$(LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c 14)
		temp_gnupg=$(mktemp -d --suffix '-gnupg')
		mkdir -p "$temp_gnupg"
		core.print_info "Password: $password"

		local save_pw_answer=
		read -rN1 -p 'Save password to _data/pw.txt? [y/n] ' save_pw_answer
		printf '\n'
		if [[ $save_pw_answer =~ ^[Yy] ]]; then
			mkdir -p "$device_path/_data"
			printf '%s\n' "$password" >"$device_path/_data/pw.txt"
			core.print_info "Password written to $device_path/_data/pw.txt"
		fi

		for name in "${!paths_encrypt[@]}"; do
			local dir="${paths_encrypt[$name]}"
			local encrypted_file="$device_path/_data/$name.asc"

			core.print_info "Encrypting $dir to $encrypted_file"
			mkdir -p "${encrypted_file%/*}"
			tar -C "${dir%/*}" -c "./${dir##*/}" \
				| gpg --homedir "$temp_gnupg" --no-keyring --batch --yes --pinentry-mode loopback --passphrase-fd 3 --cipher-algo AES256 --no-symkey-cache --armor --symmetric 3<<<"$password" \
				| cat >"$encrypted_file"
		done

		for name in "${!paths[@]}"; do
			local dir="${paths[$name]}"
			local dest="$device_path/_data/$name"

			core.print_info "Copying $dir to $dest"
			mkdir -p "${dest%/*}"
			cp -rT "$dir" "$dest"
		done

	elif [ "$mode" = restore ]; then
		local password= pw_file="$device_path/_data/pw.txt"
		if [ -f "$pw_file" ]; then
			password=$(<"$pw_file")
			core.print_info "Using password from $pw_file"
		else
			read -re -p 'Password? ' password
		fi

		local temp_gnupg=
		temp_gnupg=$(mktemp -d --suffix '-gnupg')

		for name in "${!paths_encrypt[@]}"; do
			local dir="${paths_encrypt[$name]}"
			local encrypted_file="$device_path/_data/$name.asc"

			if [ -e "$dir" ]; then
				core.print_warn "File or directory $dir already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_die "Directory must not exist"
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
			local src="$device_path/_data/$name"

			if [ -e "$dir" ]; then
				core.print_warn "File or directory $dir already exists"
				read -rN1 -p 'Remove? [y/n] ' answer
				printf '\n'
				if [[ $answer =~ ^[Yy] ]]; then
					rm -rf "$dir"
				else
					core.print_die "Directory must not exist"
				fi
			fi

			core.print_info "Copying $src to $dir"
			mkdir -p "${dir%/*}"
			cp -rT "$src" "$dir"
		done
	else
		core.print_die "Invalid mode: $mode"
	fi

	core.print_info 'Done! You may need to remove the source directory'
}

util.if_file_sourced || _main "$@"
