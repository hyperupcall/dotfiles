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
	source ~/.dotfiles/os/unix/scripts/xdg.sh
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

# -------------------------------------------------------- #
#                     HELPER FUNCTIONS                     #
# -------------------------------------------------------- #
helper.run_for_distro() {
	# TODO: actually write
	# TODO: arch but make it work with derivatives by default
	if declare -f 'install.debian' &>/dev/null; then
		install.debian "$@"
	elif declare -f 'install.ubuntu' &>/dev/null; then
		install.ubuntu "$@"
	elif declare -f 'install.fedora' &>/dev/null; then
		install.fedora "$@"
	elif declare -f 'install.opensuse' &>/dev/null; then
		install.opensuse "$@"
	elif declare -f 'install.arch' &>/dev/null; then
		install.arch "$@"
	else
		core.print_fatal "Distribution not supported"
	fi
}

helper.install_and_configure() {
	local id="$1"
	local name="$2"
	local flag_force_install=no

	local arg=
	for arg; do
		case $arg in
			--force-install) flag_force_install=yes ;;
		esac
	done

	if declare -f install."$id" &>/dev/null; then
		if ! declare -f installed &>/dev/null || ! installed || [ "$flag_force_install" = yes ]; then
			if util.confirm "Install $name?"; then
				install."$id"
			fi
		else
			core.print_info "$name already installed. Pass --force-install to run install again"
		fi
	else
		core.print_info "$name has no install function"
	fi

	core.print_info "Configuring $name"
	configure."$id"
}

pkg.add_apt_key() {
	local source_url=$1
	local dest_file="$2"

	if [ ! -f "$dest_file" ]; then
		core.print_info "Downloading and writing key to $dest_file"
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
		core.print_die "Failed to cd to '$1'"
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

util.requires_bin() {
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

util.clone_in_dotfiles() {
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
			# shellcheck disable=SC2034
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

util.get_package_manager() {
	for package_manager in pacman apt dnf zypper; do
		if util.is_cmd "$package_manager"; then
			REPLY="$package_manager"

			return
		fi
	done

	core.print_die 'Failed to get the system package manager'
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
		core.print_die 'Failed to determine package manager'
	fi
}

util.get_latest_github_tag() {
	unset -v REPLY; REPLY=
	local repo="$1"

	if [ ! -f ~/.dotfiles/.data/github_token ]; then
		core.print_die "Error: File not found: ~/.dotfiles/.data/github_token"
	fi

	core.print_info "Getting latest version of: $repo"

	local token=
	token="$(<~/.dotfiles/.data/github_token)"
	local url="https://api.github.com/repos/$repo/releases/latest"
	local tag_name=
	tag_name=$(curl -fsSLo- -H "Authorization: token: $token" "$url" | jq -r '.tag_name')

	REPLY=$tag_name
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
		core.print_die "Failed to determine OS id"
	fi
}
