# shellcheck shell=bash

# -------------------------------------------------------- #
#                     HELPER FUNCTIONS                     #
# -------------------------------------------------------- #
must.rm() {
	util.get_path "$1"
	local file="$REPLY"

	if [ -f "$file" ]; then
		local output=
		if output=$(rm -f -- "$file" 2>&1); then
			core.print_info "Removed file '$file'"
		else
			core.print_warn "Failed to remove file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.rmdir() {
	util.get_path "$1"
	local dir="$REPLY"

	if [ -d "$dir" ]; then
		local output=
		if output=$(rmdir -- "$dir" 2>&1); then
			core.print_info "Removed directory '$dir'"
		else
			core.print_warn "Failed to remove directory '$dir'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.dir() {
	local d=
	for d; do
		util.get_path "$d"
		local dir="$REPLY"

		if [ ! -d "$dir" ]; then
			local output=
			if output=$(mkdir -p -- "$dir" 2>&1); then
				core.print_info "Created directory '$dir'"
			else
				core.print_warn "Failed to create directory '$dir'"
				printf '  -> %s\n' "$output"
			fi
		fi
	done; unset -v d
}

must.file() {
	util.get_path "$1"
	local file="$REPLY"

	if [ ! -f "$file" ]; then
		local output=
		if output=$(mkdir -p -- "${file%/*}" && touch -- "$file" 2>&1); then
			core.print_info "Created file '$file'"
		else
			core.print_warn "Failed to create file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.link() {
	util.get_path "$1"
	local src="$REPLY"

	util.get_path "$2"
	local target="$REPLY"

	if [ -z "$1" ]; then
		core.print_warn "must.link: First parameter is emptys"
		return
	fi

	if [ -z "$2" ]; then
		core.print_warn "must.link: Second parameter is empty"
		return
	fi

	# Skip if already is correct
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		return
	fi

	# If it is an empty directory (and not a symlink) automatically remove it
	if [ -d "$target" ] && [ ! -L "$target" ]; then
		local children=("$target"/*)
		if (( ${#children[@]} == 0)); then
			rmdir "$target"
		else
			core.print_warn "Skipping symlink from '$src' to '$target' (target a non-empty directory)"
			return
		fi
	fi
	if [ ! -e "$src" ]; then
		core.print_warn "Skipping symlink from '$src' to $target (source directory not found)"
		return
	fi

	local output=
	if output=$(ln -sfT "$src" "$target" 2>&1); then
		core.print_info "Symlinking '$src' to $target"
	else
		core.print_warn "Failed to symlink from '$src' to '$target'"
		printf '  -> %s\n' "$output"
	fi
}
