# shellcheck shell=bash

# Name:
# Idempotent Setup
#
# Description:
# Idempotently configures the desktop. This includes:
# - Ensures mount to /storage/ur
# - Strip ~/.bashrc, etc. dotfiles from random appendage
# - Symlinks ~/.ssh, etc. software not mananged by dotfox
# - Symlinks directories to ~/.dots/.home

main() {
	dotmgr.get_profile
	local profile="$REPLY"

	dotmgr.call '10_dirs.sh'
	dotmgr.call '11_dconf.sh'

	dotmgr.call '12_dot_funcalias_extractor.sh'
	dotmgr.call '13_dot_shell_generator.sh'
	dotmgr.call '14_dotfox_deploy.sh'

	if util.is_cmd VBoxManage; then
		VBoxManage setproperty machinefolder '/storage/vault/rodinia/VirtualBox_Machines'
	fi

	# TODO
	if command -v file_server &>/dev/null; then
		deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
	fi

	# FIXME
	# cmd cp "$XDG_SHARE_HOME"/password-store/* "$HOME/Dropbox/password-store"
	# echo nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	# TODO: ~/.config/docker ($DOCKER_HOME?)/config.json : { "credsStore": "secretservice" } (and download binary)
}


# -------------------------------------------------------- #
#                     HELPER FUNCTIONS                     #
# -------------------------------------------------------- #
must_rm() {
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

must_rmdir() {
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

must_dir() {
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

must_file() {
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

must_link() {
	util.get_path "$1"
	local src="$REPLY"

	util.get_path "$2"
	local link="$REPLY"

	if [ -z "$1" ]; then
		core.print_warn "must_link: First parameter is emptys"
		return
	fi

	if [ -z "$2" ]; then
		core.print_warn "must_link: Second parameter is empty"
		return
	fi

	# Skip if already is correct
	if [ -L "$link" ] && [ "$(readlink "$link")" = "$src" ]; then
		return
	fi

	# If it is an empty directory (and not a symlink) automatically remove it
	if [ -d "$link" ] && [ ! -L "$link" ]; then
		local children=("$link"/*)
		if (( ${#children[@]} == 0)); then
			rmdir "$link"
		else
			core.print_warn "Skipping symlink from '$src' to '$link'"
			return
		fi
	fi
	if [ ! -e "$src" ]; then
		core.print_warn "Skipping symlink from '$src' to $link"
		return
	fi

	local output=
	if output=$(ln -sfT "$src" "$link" 2>&1); then
		core.print_info "Symlinking '$src' to $link"
	else
		core.print_warn "Failed to symlink from '$src' to '$link'"
		printf '  -> %s\n' "$output"
	fi
}

util.get_path() {
	if [[ ${1::1} == / ]]; then
		REPLY="$1"
	else
		REPLY="$HOME/$1"
	fi
}
