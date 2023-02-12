# shellcheck shell=bash

# Name:
# dotshellgen.sh
#
# Description:
# Generates shell scripts for different shells from a nicer directory hierarchy
#
# More specifically, it concatenates files from a hierarchy located at
# "$XDG_CONFIG_HOM/dotshellgen" into a single file for each shell. The result
# is saved at "$XDG_STATE_HOME/dotshellgen"

main() {
	# ------------------- Utility Functions ------------------ #
	is_in_array() {
		declare array_name="$1"
		declare value="$2"

		declare -n array="$array_name"

		declare item=
		for item in "${array[@]}"; do
			if [ "$item" = "$value" ]; then
				return 0
			fi
		done; unset -v item

		return 1
	}

	concat() {
		declare file="$1"

		declare file_name="${file##*/}"

		case "$file_name" in
		*.bash)
			declare -n output_file='concatenated_bash_file'
			;;
		*.zsh)
			declare -n output_file='concatenated_zsh_file'
			;;
		*.fish)
			declare -n output_file='concatenated_fish_file'
			;;
		*.sh)
			declare -n output_file='concatenated_sh_file'
			;;
		*)
			# core.print_warn "Skipping '$file_name'"
			return
			;;
		esac

		{
			printf '# %s\n' "$file_name"
			cat "$file"
			printf '\n'
		} >> "$output_file"
	}

	declare flag_clear='no'
	declare arg=
	for arg; do case $arg in
		-h|--help) printf '%s\n' "Usage: [-h|--help] [--clear]"; return ;;
		--clear) flag_clear='yes'
	esac done


	declare dotshellgen_config_dir="$XDG_CONFIG_HOME/dotshellgen"
	declare dotshellgen_state_dir="$XDG_STATE_HOME/dotshellgen"
	mkdir -p "$dotshellgen_config_dir" "$dotshellgen_state_dir"

	declare concatenated_bash_file="$dotshellgen_state_dir/concatenated.bash"
	declare concatenated_zsh_file="$dotshellgen_state_dir/concatenated.zsh"
	declare concatenated_fish_file="$dotshellgen_state_dir/concatenated.fish"
	declare concatenated_sh_file="$dotshellgen_state_dir/concatenated.sh"

	if [ "$flag_clear" = 'yes' ]; then
		rm -f "$concatenated_bash_file" "$concatenated_zsh_file" "$concatenated_fish_file" "$concatenated_sh_file"
		core.print_warn 'Cleared all generated files'
		return
	fi

	# Nuke all concatenated files
	> "$concatenated_bash_file" :
	> "$concatenated_zsh_file" :
	> "$concatenated_fish_file" :
	> "$concatenated_sh_file" :

	declare -a pre=() post=() disabled=()
	source "$dotshellgen_config_dir/config.sh"

	declare dirname=
	for dirname in "${pre[@]}"; do
		for file in "$dotshellgen_config_dir/$dirname"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dirname

	declare dir=
	for dir in "$dotshellgen_config_dir"/*/; do
		declare dirname="${dir%/}"; dirname=${dirname##*/}

		if is_in_array 'pre' "$dirname"; then
			continue
		fi
		if is_in_array 'post' "$dirname"; then
			continue
		fi

		if is_in_array 'disabled' "$dirname"; then
			continue
		fi

		declare file=
		for file in "$dir"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dir

	declare dirname=
	for dirname in "${post[@]}"; do
		for file in "$dotshellgen_config_dir/$dirname"/*; do
			concat "$file"
		done; unset -v file
	done; unset -v dirname

	printf '%s\n' 'Done.'
}

main "$@"
