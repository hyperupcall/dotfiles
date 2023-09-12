# shellcheck shell=bash

# shellcheck disable=SC2016
{
	set -e
	shopt -s extglob globstar shift_verbose

	# Source all the things
	source ~/.dotfiles/xdg.sh
	for _f in \
		"${0%/*}/../../vendor/bash-core/pkg"/**/*.sh \
		"${0%/*}/../../vendor/bash-term/pkg"/**/*.sh; do
		source "$_f"
	done; unset -v _f

	# Assert environment
	if [ -z "$XDG_CONFIG_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_CONFIG_HOME is empty' >&2
		exit 1
	fi
	if [ -z "$XDG_DATA_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_DATA_HOME is empty' >&2
		exit 1
	fi
	if [ -z "$XDG_STATE_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_STATE_HOME is empty' >&2
		exit 1
	fi
}

{
	export VAR_DOTMGR_DIR="$HOME/.dotfiles/os/unix"

	#
	# desktop
	if [ "$(</sys/class/dmi/id/chassis_type)" = '3' ]; then
		export VAR_PROFILE='desktop'
		export VAR_REPOS_DIR="$HOME/repos"
	#
	# laptop
	elif [ "$(</sys/class/dmi/id/chassis_type)" = '9' ]; then
		export VAR_PROFILE='desktop'
		export VAR_REPOS_DIR=$HOME/Documents
	fi
}

# -------------------------------------------------------- #
#                     HELPER FUNCTIONS                     #
# -------------------------------------------------------- #
helper.assert_app_image_launcher_installed() {
	if command -v appimagelauncherd; then
		return 0
	else
		core.print_error "This scripts depends on the installation of AppImageLauncher"
		exit 1
	fi
}

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


util.die() {
	exit 1
}

util.req() {
	curl --proto '=https' --tlsv1.2 -#Lf "$@"
}

util.run() {
	core.print_info "Executing '$*'"
	if "$@"; then
		return $?
	else
		return $?
	fi
}

util.cd_temp() {
	local dir=
	dir=$(mktemp -d)

	pushd "$dir" >/dev/null || exit
}

util.ensure() {
	if "$@"; then :; else
		core.print_die "'$*' failed (code $?)"
	fi
}

util.ensure_bin() {
	if ! command -v "$1" &>/dev/null; then
		core.print_die "Command '$1' does not exist"
	fi
}

util.is_cmd() {
	if command -v "$1" &>/dev/null; then
		return $?
	else
		return $?
	fi
}

util.clone() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir" ]; then
		core.print_info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir"
	fi
}

util.install_pkg() {
	local cmd="$1"

	if util.is_cmd 'pacman'; then
		util.ensure sudo pacman -S --noconfirm "$cmd"
	elif util.is_cmd 'apt-get'; then
		util.ensure sudo apt-get -y install "$cmd"
	elif util.is_cmd 'dnf'; then
		util.ensure sudo dnf -y install "$cmd"
	elif util.is_cmd 'zypper'; then
		util.ensure sudo zypper -y install "$cmd"
	elif util.is_cmd 'eopkg'; then
		util.ensure sudo eopkg -y install "$cmd"
	elif iscmd 'brew'; then
		util.ensure brew install "$cmd"
	else
		util.die 'Failed to determine package manager'
	fi

	if ! util.is_cmd 'jq'; then
		core.print_die 'Automatic installation of jq failed'
	fi
}

util.clone_in_dots() {
	unset -v REPLY; REPLY=
	local repo="$1"

	local dir="$HOME/.dotfiles/.data/repos/${repo##*/}"
	util.clone "$repo" "$dir"

	REPLY=$dir
}


util.confirm() {
	local message="${1:-Confirm?}"

	local input=
	until [[ "$input" =~ ^[yn]$ ]]; do
		read -rN1 -p "$message "
		input=${REPLY,,}
	done
	printf '\n'

	if [ "$input" = 'y' ]; then
		return 0
	else
		return 1
	fi
}

util.get_path() {
	if [[ ${1::1} == / ]]; then
		REPLY="$1"
	else
		REPLY="$HOME/$1"
	fi
}

util.get_package_manager() {
	for package_manager in pacman apt dnf zypper; do
		if util.is_cmd "$package_manager"; then
			REPLY="$package_manager"

			return
		fi
	done

	core.print_die 'Failed to get the system package manager'
}

util.get_os_id() {
	unset -v REPLY; REPLY=

	while IFS='=' read -r key value; do
		if [ "$key" = 'ID' ]; then
			REPLY=$value
		fi
	done < /etc/os-release; unset -v line

	if [ -z "$REPLY" ]; then
		core.print_error "Failed to determine OS id"
		exit 1
	fi
}

util.get_latest_github_tag() {
	unset -v REPLY; REPLY=
	local repo="$1"

	core.print_info "Getting latest version of: $repo"

	# FIXME: this is going to be rate limited
	local url="https://api.github.com/repos/$repo/releases/latest"
	local tag_name=
	tag_name=$(curl -fsSLo- "$url" | jq -r '.tag_name')

	REPLY=$tag_name
}

util.run_script() {
	local dir="$HOME/.dotfiles/os/unix/dotmgr/$1"
	local glob_pattern="$2"

	local -a files=("$dir/"*"$glob_pattern"*)
	if (( ${#files[@]} == 0 )); then
		core.print_error "Failed to find a file matching '$glob_pattern' in dir '$dir'"
		if ! util.confirm 'Continue?'; then
			exit 1
		fi
	elif (( ${#files[@]} > 1 )); then
		core.print_error "Failed to find a single file matching '$glob_pattern' in dir '$dir' (multiple matches found)"
		if ! util.confirm 'Continue?'; then
			exit 1
		fi
	else
		core.print_info "Executing ${files[0]}"
		{
			FORCE_COLOR=3 source "${files[0]}"
		} \
			4>&1 1> >(
				while IFS= read -r line; do
					printf "  %s\n" "$line" >&4
				done; unset -v line
			) \
			5>&2 2> >(
				while IFS= read -r line; do
					printf "  %s\n" "$line" >&5
				done; unset -v line
			)
	fi
}
