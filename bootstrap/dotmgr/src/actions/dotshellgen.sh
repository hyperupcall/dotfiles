# shellcheck shell=bash

# Name:
# dotshellgen
#
# Description:
# Generates shell scripts for different shells from a nicer structure
#
# More specifically, it concatenates files from a hierarchy located at "$XDG_CONFIG_HOM/dotshellgen" into a single file for each shell. The result is saved at "$XDG_STATE_HOME/dotshellgen"

action() {
	local flag_clear='no'
	local arg=
	for arg; do case $arg in
		-h|--help) printf '%s\n' "Usage: [-h|--help] [--clear]"; return ;;
		--clear) flag_clear='yes'
	esac done


	local dotshellgen_config_dir="$XDG_CONFIG_HOME/dotshellgen"
	local dotshellgen_state_dir="$XDG_STATE_HOME/dotshellgen"
	mkdir -p "$dotshellgen_config_dir" "$dotshellgen_state_dir"

	local concatenated_bash_file="$dotshellgen_state_dir/concatenated.bash"
	local concatenated_zsh_file="$dotshellgen_state_dir/concatenated.zsh"
	local concatenated_fish_file="$dotshellgen_state_dir/concatenated.fish"
	local concatenated_sh_file="$dotshellgen_state_dir/concatenated.sh"

	if [ "$flag_clear" = 'yes' ]; then
		rm -f "$concatenated_bash_file" "$concatenated_zsh_file" "$concatenated_fish_file" "$concatenated_sh_file"
		warn 'Cleared all generated files'
		return
	fi

	# Nuke all concatenated files
	> "$concatenated_bash_file" :
	> "$concatenated_zsh_file" :
	> "$concatenated_fish_file" :
	> "$concatenated_sh_file" :

	declare -a pre=() post=() disabled=()
	source "$dotshellgen_config_dir/config.sh"

	local dirname=
	for dirname in "${pre[@]}"; do
		for file in "$dotshellgen_config_dir/$dirname"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dirname

	local dir=
	for dir in "$dotshellgen_config_dir"/*/; do
		local dirname="${dir%/}"; dirname=${dirname##*/}

		if is_in_array 'pre' "$dirname"; then
			continue
		fi
		if is_in_array 'post' "$dirname"; then
			continue
		fi

		if is_in_array 'disabled' "$dirname"; then
			continue
		fi

		local file=
		for file in "$dir"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dir

	local dirname=
	for dirname in "${post[@]}"; do
		for file in "$dotshellgen_config_dir/$dirname"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dirname

	printf '%s\n' 'Done.'
}

warn() {
	printf 'Info: %s\n' "$1"
}

warn() {
	printf 'Warning: %s\n' "$1"
}

error() {
	printf 'Error: %s\n' "$1"
	exit 1
}

is_in_array() {
	local array_name="$1"
	local value="$2"

	local -n array="$array_name"

	local item=
	for item in "${array[@]}"; do
		if [ "$item" = "$value" ]; then
			return 0
		fi
	done; unset -v item

	return 1
}

concat() {
	local file="$1"

	local file_name="${file##*/}"

	case "$file_name" in
	*.bash)
		local -n output_file='concatenated_bash_file'
		;;
	*.zsh)
		local -n output_file='concatenated_zsh_file'
		;;
	*.fish)
		local -n output_file='concatenated_fish_file'
		;;
	*.sh)
		local -n output_file='concatenated_sh_file'
		;;
	*)
		warn "Skipping '$file_name'"
		return
		;;
	esac

	{
		printf '# %s\n' "$file_name"
		cat "$file"
		printf '\n'
	} >> "$output_file"
}
