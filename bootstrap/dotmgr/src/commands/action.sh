# shellcheck shell=bash

subcommand() {
	local action="$1"

	if [ -n "$action" ]; then
		# Prevent deinit from being called on EXIT
		unset -f tty.fullscreen_deinit

		if [ -f "$DOTMGR_ROOT_DIR/src/actions/$action.sh" ]; then
			source "$DOTMGR_ROOT_DIR/src/actions/$action.sh"
			if ! shift; then
				print.die 'Failed to shift'
			fi
			action "$@"
		else
			print.die "Could not find action '$action'"
		fi
		exit
	fi

	local left_str='                    |'

	local -i selected=0
	local files=(
		# regular common
		'dotshellgen'
		'dotshellextract'
		'prune_and_resymlink'
		''
		# bootstrapping
		'dotfox_deploy'
		'package_install'
		'mount_setup'
		''
		# regular uncommon
		'secrets_export'
		'secrets_import'
		'extensions_save'
	)

	local -a actions=() descriptions=()
	local file=
	for file in "${files[@]}"; do
		if [ -z "$file" ]; then
			actions+=('')
			descriptions+=('')
			continue
		fi

		local descriptionsi=0
		local mode='default' description=
		local line=
		while IFS= read -r line; do
			if [[ $line == '# Name:' ]]; then
				mode='name'
				continue
			elif [[ $line == '# Description:' ]]; then
				descriptionsi=0
				mode='description'
				continue
			fi

			if [ "$mode" = 'name' ]; then
				actions+=("${line:2}")
				mode='default'
			elif [ "$mode" = 'description' ]; then
				if [ "${line:0:1}" != '#' ]; then
					# while ((${#descriptions} > 0)); then
						# :
					# fi

					descriptions+=("$description")
					mode='default'
				fi


				local esc=
				printf -v esc '\033[%d;%dH' 0 $((${#left_str}+2))

				if [ -z "${line:2}" ]; then
					description+=$'\n'
				else
					# description+="${line:2}"$'\n\033['$((${#left_str}+1))"C"
					# description+=$'\033['"$descriptionsi;"$((${#left_str}+1))"H${line:2}
					description+="${line:2}"
				fi

				descriptionsi=$((descriptionsi++))
			fi
		done < "$DOTMGR_ROOT_DIR/src/actions/$file.sh"; unset -v line
	done; unset -v file

	tty.fullscreen_init
	while :; do
		print_menu "$selected" 'actions' 'descriptions'

		local key=
		if ! read -rsN1 key; then
			print.die 'Failed to read input'
		fi

		case $key in
		j)
			if ((selected < ${#files[@]} - 1)); then
				if [ -z "${actions[$selected+1]}" ]; then
					selected=$((selected+2))
				else
					((++selected))
				fi
			fi
			;;
		k)
			if ((selected > 0)); then
				if [ -z "${actions[$selected-1]}" ]; then
					selected=$((selected-2))
				else
					((selected--))
				fi
			fi
			;;
		e)
			"$EDITOR" "$DOTMGR_ROOT_DIR/src/actions/${files[$selected]}.sh"
			;;
		$'\n'|$'\x0d')
			tty.fullscreen_deinit
			source "$DOTMGR_ROOT_DIR/src/actions/${files[$selected]}.sh"
			action
			exit
			;;
		1|2|3|4|5|6|7|8|9)
			local -i i= adjustedi=-1
			for ((i=0; i < key; ++i)); do
				if [ -z "${files[$i]}" ]; then
					adjustedi=$((adjustedi+1))
				fi

				adjustedi=$((adjustedi+1))
			done
			selected=$adjustedi
			;;
		q) break ;;
		$'\x1b')
			if ! read -rsN1 -t 0.1 key; then
				break
			fi
			;;
		esac
	done
}

tty.fullscreen_init() {
	global_stty_saved="$(stty --save)"
	stty -echo
	tput civis 2>/dev/null # cursor to invisible
	tput sc # save cursor position
	tput smcup 2>/dev/null # save screen contents

	printf '\033[3J' # clear
	read -r global_tty_height global_tty_width < <(stty size)
}

tty.fullscreen_deinit() {
	tput rmcup 2>/dev/null # restore screen contents
	tput rc # restore cursor position
	tput cnorm 2>/dev/null # cursor to normal
	if [ -z "$global_stty_saved" ]; then
		stty sane
		print.warn "Variable 'global_stty_saved' is empty. Falling back to 'stty sane'"
	else
		stty "$global_stty_saved"
	fi
}

print_menu() {
	# print margin
	local i=
	for ((i = 0; i < global_tty_height; ++i)); do
		printf '\033[%d;%dH' "$i" 0 # tput cup 0 0
		printf "%s" "$left_str"
	done; unset -v i
	printf '\033[%d;%dH' "$global_tty_height" 0
	printf 'q: quit    j: Down    k: Up    Enter: Select    e: Edit'

	# print actions
	printf '\033[%d;%dH' 0 0 # tput cup 0 0
	local i= reali=0
	for ((i=0; i<${#actions[@]}; ++i)); do
		if [ -z "${actions[$i]}" ]; then
			printf '\n'
			continue
		fi

		if ((i == selected)); then
			printf '\033[0;34m'
		fi

		printf '%s\033[0m\n' "$((reali+1)): ${actions[$i]}"
		((++reali))
	done; unset -v i reali

	# reset description
	local i=
	for ((i=0; i<${#actions[@]}; ++i)); do
		printf '\033[%d;%dH' "$i" $((${#left_str}+1)) # tput cup
		printf '\033[K' # tput el
	done; unset -v i

	# print description
	printf '\033[%d;%dH' 0 $((${#left_str}+2)) # tput cup
	# shellcheck disable=SC2059
	printf "${descriptions[$selected]}"
}

find_mnt_usb() {
	local usb_partition_uuid="$1"

	local block_dev="/dev/disk/by-uuid/$usb_partition_uuid"
	if [ ! -e "$block_dev" ]; then
		print.die "USB Not plugged in"
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
			print.die "Directory '/mnt' must not already be a mountpoint"
		fi

		util.run sudo mount "$block_dev" /mnt

		if ! block_dev_target="$(findmnt -no TARGET "$block_dev")"; then
			print.die "Automount failed"
		fi
	fi

	REPLY=$block_dev_target
}
