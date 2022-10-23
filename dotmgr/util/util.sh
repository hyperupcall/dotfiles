# shellcheck shell=bash

util.die() {
	exit 1
}

util.req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
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

	pushd "$dir" >/dev/null
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

util.update_and_upgrade() {
	if util.is_cmd 'pacman'; then
		sudo pacman -Syyu --noconfirm
	elif util.is_cmd 'apt-get'; then
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
	elif util.is_cmd 'dnf'; then
		sudo dnf -y update
	elif util.is_cmd 'zypper'; then
		sudo zypper -y update
		sudo zypper -y upgrade
	elif util.is_cmd 'eopkg'; then
		: # TODO
	elif iscmd 'brew'; then
		util.ensure brew install "$cmd"
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
	fi
}

util.clone_in_dots() {
	local repo="$1"

	util.clone "$repo" "$HOME/.dots/.repos/${repo##*/}"
}

util.assert_prereq() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_STATE_HOME" ]; then
		# shellcheck disable=SC2016
		core.print_die '$XDG_STATE_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi
}

util.confirm() {
	local message="${1:-Confirm?}"

	local input=
	until [[ "$input" =~ ^[yn]$ ]]; do
		read -rN1 -p "$message "
		input=${REPLY@L}
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
