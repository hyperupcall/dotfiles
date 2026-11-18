#!/usr/bin/env bash
source ~/.dotfiles/config/setup.sh

main() {
	local dir=
	for dir in ~/.dev ~/.dotfiles "$XDG_DATA_HOME/password-store"; do
		if [ ! -d "$dir" ]; then
			core.print_error 'Expected directory to exist'
			exit 1
		fi

		local output=
		output=$(git -C "$dir" status --porcelain)
		if [ -n "$output" ]; then
			core.print_error "Expected working tree for \"$dir\" to be clean, but is not"
			printf '%s\n' "$output" >&2
			exit 1
		fi

		local upstream_ref= unpushed_count=
		upstream_ref=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
		if [ -z "$upstream_ref" ]; then
			core.print_error "Expected an upstream branch for \"$dir\", but found none"
			exit 1
		fi
		unpushed_count=$(git -C "$dir" rev-list --count "$upstream_ref..HEAD")
		if ((unpushed_count)); then
			core.print_error "Expected all commits in \"$dir\" to be pushed, but found $unpushed_count extra local commits"
			git -C "$dir" log --oneline "$upstream_ref..HEAD" >&2
			exit 1
		fi
	done
	unset -v dir
}

util.if_file_sourced || _main "$@"
