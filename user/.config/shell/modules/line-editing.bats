#!/usr/bin/env bats

set -o vi
source line-editing.sh

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
			_readline_util_get_line "$line"

			# echo "line: '$line'" >&3

			[[ $REPLY == "git status -s" ]]
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
		_readline_util_get_cmd "$key"
		actualCmd="$REPLY"

		# echo "KEY: $key" >&3
		# echo "EXPECTEDCMD: $expectedCmd" >&3
		# echo "ACTUALCMD: $actualCmd" >&3
		# echo >&3

		[[ $expectedCmd == "$actualCmd" ]]
	done
}


@test "_readline_util_try_show_man" {
	local result
	export DEBUG_LINE_EDITING=

	declare -A lineCmds=(
		["git status --short"]="git-status"
		["zfs mount -a"]="zfs-mount"
		["lsblk --fs"]="lsblk"
		["lsblk -f"]="lsblk"
		["qemu-system-x86_64"]="qemu"
		["restic --repo cache"]="restic-cache"
	)

	for key in "${!lineCmds[@]}"; do
		expectedCmd="${lineCmds["$key"]}"
		actualCmd="$(_readline_util_show_man "$key")"

		# echo "KEY: $key" >&3
		# echo "EXPECTEDCMD: $expectedCmd" >&3
		# echo "ACTUALCMD: $actualCmd" >&3
		# echo >&3

		[[ $expectedCmd == "$actualCmd" ]]
	done
}
