#!/usr/bin/env bash

shopt -s extglob nullglob globstar

warn() {
	printf 'Warning: %s\n' "$1"
}

error() {
	printf 'Error: %s\n' "$1"
	exit 1
}

main() {
	local prefix="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
	local aggregatedBashFile="$prefix/generated/aggregated.bash"
	local aggregateZshFile="$prefix/generated/aggregated.zsh"
	local aggregatedFishFile="$prefix/generated/aggregated.fish"

	mkdir -p "$prefix/generated"
	> "$aggregatedBashFile"
	> "$aggregateZshFile"
	> "$aggregatedFishFile"

	for dir in "$prefix"/programs/*/; do
		for file in "$dir"/*; do
			local fileName="${file##*/}"

			case "$fileName" in
			*.bash)
				local -n outputFile='aggregatedBashFile'
				;;
			*.zsh)
				local -n outputFile='aggregateZshFile'
				;;
			*.fish)
				local -n outputFile='aggregatedFishFile'
				;;
			*)
				warn "Skipping '$fileName'"
				continue
				;;
			esac

			{
				printf '# %s\n' "$fileName"
				cat "$file"
				printf '\n'
			} >> "$outputFile"
		done
	done
}

main "$@"
