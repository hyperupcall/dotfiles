# shellcheck shell=bash

# shellcheck disable=SC2016
{
	# Set options
	set -e
	if [ -n "$BASH_VERSION" ]; then
		# shellcheck disable=SC3044
		shopt -s extglob globstar shift_verbose
	fi

	# Source libraries
	source ~/.dotfiles/xdg.sh
	for _f in \
		"${BASH_SOURCE[0]%/*}/../vendor/bash-core/pkg"/**/*.sh \
		"${BASH_SOURCE[0]%/*}/../vendor/bash-term/pkg"/**/*.sh; do
		source "$_f"
	done; unset -v _f

	# Assumption checks
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

	err_handler() {
		core.print_stacktrace
	}
	core.trap_add 'err_handler' SIGINT
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

pkg.add_apt_key() {
	local source_url=$1
	local dest_file="$2"

	if [ ! -f "$dest_file" ]; then
		sudo mkdir -p "${dest_file%/*}"
		util.req "$source_url" \
			| sudo tee "$dest_file" >/dev/null
	fi
}

pkg.add_apt_repository() {
	local source_line="$1"
	local dest_file="$2"

	sudo mkdir -p "${dest_file%/*}"
	sudo rm -f "${dest_file%.*}.list"
	sudo rm -f "${dest_file%.*}.sources"
	printf '%s\n' "$source_line" | sudo tee "$dest_file" >/dev/null
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
		local children=
		children=("$target"/*)
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

util.cd() {
	if ! cd "$1"; then
		core.print_error "Failed to cd to '$1'"
		exit 1
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

		git_remote=$(git -C "$dir" remote)
		if [ "$git_remote" = 'origin' ]; then
			git -C "$dir" remote rename origin me
		fi
		unset -v git_remote
	fi
}

util.install_packages() {
	if util.is_cmd 'pacman'; then
		util.ensure sudo pacman -S --noconfirm "$@"
	elif util.is_cmd 'apt-get'; then
		util.ensure sudo apt-get -y install "$@"
	elif util.is_cmd 'dnf'; then
		util.ensure sudo dnf -y install "$@"
	elif util.is_cmd 'zypper'; then
		util.ensure sudo zypper -y install "$@"
	elif util.is_cmd 'eopkg'; then
		util.ensure sudo eopkg -y install "$@"
	elif iscmd 'brew'; then
		util.ensure brew install "$@"
	else
		util.die 'Failed to determine package manager'
	fi
}

util.clone_in_dots() {
	unset -v REPLY; REPLY=
	local repo="$1"

	local dir="$HOME/.dotfiles/.data/repos/${repo##*/}"
	util.clone "$repo" "$dir" "${@:2}"

	REPLY=$dir
}


util.confirm() {
	local message=${1:-Confirm?}

	local input=
	until [[ "$input" =~ ^[yn]$ ]]; do
		read -rN1 -p "$message "
		if [ -n "$BASH_VERSION" ]; then
			input=${REPLY,,}
		elif [ -n "$KSH_VERSION" ]; then
			typeset -M toupper input="$REPLY"
		else
			input=$(printf '%s\n' "$REPLY" | tr '[:upper:]' '[:lower:]')
		fi
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

	# shellcheck disable=SC1007
	local key= value=
	while IFS='=' read -r key value; do
		if [ "$key" = 'ID' ]; then
			REPLY=$value
		fi
	done < /etc/os-release; unset -v key value

	if [ -z "$REPLY" ]; then
		core.print_error "Failed to determine OS id"
		exit 1
	fi
}

util.get_latest_github_tag() {
	unset -v REPLY; REPLY=
	local repo="$1"

	core.print_info "Getting latest version of: $repo"

	local token="$(<~/.dotfiles/.data/github_token)"
	local url="https://api.github.com/repos/$repo/releases/latest"
	local tag_name=
	tag_name=$(curl -fsSLo- -H "Authorization: token: $token" "$url" | jq -r '.tag_name')

	REPLY=$tag_name
}
