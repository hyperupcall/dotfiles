#!/usr/bin/env bats

set -o vi
source readline.sh

@test "_readline_util_get_line" {
	readonly -a gits=(
		"git"
		"'git'"
		"\\git"
	)

	for git in "${gits[@]}"; do
		local -a lines=(
			"$git status -s"
			" $git status -s"
			"sudo $git status -s"
			" sudo $git status -s"
		)

		for line in "${lines[@]}"; do
			line="$(_readline_util_get_line "$line")"

			# echo "line: '$line'" >&3

			[[ $line == "git status -s" ]]
		done
	done

}

@test "_readline_util_get_cmd" {
	local result

	declare -A lineCmds=(
		["git status"]="git"
		["git"]="git"
		["exa -ls"]="exa"
	)

	for key in "${!lineCmds[@]}"; do
		expectedCmd="${lineCmds["$key"]}"
		actualCmd="$(_readline_util_get_cmd "$key")"

		# echo "KEY: $key" >&3
		# echo "EXPECTEDCMD: $expectedCmd" >&3
		# echo "ACTUALCMD: $actualCmd" >&3
		# echo >&3

		[[ $expectedCmd == "$actualCmd" ]]
	done
}


@test "_readline_util_get_man" {
	local result

	declare -A lineCmds=(
		["git status --short"]="git-status"
		["zfs mount -a"]="zfs-mount"
		["lsblk --fs"]="lsblk"
		["lsblk -f"]="lsblk"
		["qemu-system-x86_64"]="qemu"
	)

	for key in "${!lineCmds[@]}"; do
		expectedCmd="${lineCmds["$key"]}"
		actualCmd="$(_readline_util_get_man "$key")"

		# echo "KEY: $key" >&3
		# echo "EXPECTEDCMD: $expectedCmd" >&3
		# echo "ACTUALCMD: $actualCmd" >&3
		# echo >&3

		[[ $expectedCmd == "$actualCmd" ]]
	done
}
