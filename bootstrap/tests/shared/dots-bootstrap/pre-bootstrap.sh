#!/usr/bin/env bash
set -Eo pipefail

#
# ─── UTIL ───────────────────────────────────────────────────────────────────────
#

die() {
	log_error "$*. Exiting"
	exit 1
}

log_info() {
	if [[ -v NO_COLOR || $TERM = dumb ]]; then
		printf "%s\n" "Info: $*"
	else
		printf "\033[0;34m%s\033[0m\n" "Info: $*"
	fi
}

log_warn() {
	if [[ -v NO_COLOR || $TERM = dumb ]]; then
		printf "%s\n" "Warn: $*"
	else
		printf "\033[1;33m%s\033[0m\n" "Warn: $*" >&2
	fi
}

log_error() {
	if [[ -v NO_COLOR || $TERM = dumb ]]; then
		printf "%s\n" "Error: $*"
	else
		printf "\033[0;31m%s\033[0m\n" "Error: $*" >&2
	fi
}

# create traps so long we aren't sourcing
[[ ${BASH_SOURCE[0]} != "$0" ]] || {
	trap trap_int INT
	trap_int() {
		die 'Received SIGINT'
	}

	trap trap_err ERR
	trap_err() {
		die 'Failure to handle error'
	}
}


ensure() {
	"$@" || die "'$*' failed"
}

#
# ─── MAIN ───────────────────────────────────────────────────────────────────────
#

main() {
	# the temporary profile we source before executing dots-bs.sh to
	# get the core variable
	declare -gr GLOBAL_TEMPORARY_PROFILE=~/.profile-tmp

	for arg; do
		if [[ $arg =~ -h|--help ]]; then
			cat <<-EOF
			Usage:
				<sudo> pre-bootstrap.sh <args>

			Arguments:
			  -h, --help
			    Show help menu

			Behavior:
			  When executed as root
			  - Network
			  - Install sudo
			  - Create user

			  When executed as a user
			  - Install git, jq
			  - Set XDG_CONFIG_HOME, XDG_DATA_HOME
			  - Install bm, shell_installer
			  - Clone eankeen/dots
			EOF
			exit
		fi
	done


	#
	# ─── AS ROOT ────────────────────────────────────────────────────────────────────
	#

	if ((EUID == 0)); then
		if [ -z "$GLOBAL_MAIN_USERNAME" ]; then
			read -rep 'Username? '

			if [ -z "$REPLY" ]; then
				die "Input for 'username' is blank"
			fi

			declare -gr GLOBAL_MAIN_USERNAME="$REPLY"
		else
			declare -gr GLOBAL_MAIN_USERNAME="$GLOBAL_MAIN_USERNAME"
		fi

		# Password for 'root' only used during testing
		# - Wherever it is used, a check for the 'GLOBAL_DEV' variable must be checked first
		declare -gr GLOBAL_MAIN_PASSWORD="password"

		# Setup network
		if ! [ -f /etc/systemd/network/90-main.network ]; then
			log_info 'Configuring systemd-networkd and systemd-resolved'

			cat > /etc/systemd/network/90-main.network <<-EOF
			[Match]
			Name=en*

			[Network]
			Description=Main Network
			DHCP=yes
			DNS=1.1.1.1
			EOF
		fi

		systemctl daemon-reload
		systemctl enable --now systemd-networkd.service
		systemctl enable --now systemd-resolved.service
		sleep 1

		if ! ping google.com -c1 -W2 &>/dev/null; then
			die 'ping failed. Ensure you are connected to the internet before continuing'
		fi

		# Ensure 'sudo' is installed
		if ! command -v sudo &>/dev/null; then
			log_info 'Installing sudo'

			if command -v pacman &>/dev/null; then
				pacman -S --noconfirm sudo
			elif command -v apt-get &>/dev/null; then
				apt-get -y install sudo
			elif command -v dnf &>/dev/null; then
				dnf -y install sudo
			elif command -v zypper &>/dev/null; then
				zypper -y install sudo
			fi
		fi

		if ! command -v sudo &>/dev/null; then
			die 'Automatic installation of sudo failed'
		fi

		# Ensure main user exists
		if grep -q "$GLOBAL_MAIN_USERNAME" /etc/passwd; then
			log_info "'$GLOBAL_MAIN_USERNAME' already exists in /etc/passwd"
		else
			log_info "Ensuring '$GLOBAL_MAIN_USERNAME' user exists"
			useradd -m "$GLOBAL_MAIN_USERNAME"
		fi

		# Ensure user is in group 'sudo'
		if grep -q sudo /etc/group; then
			log_info "Group 'sudo' already exists"
		else
			log_info "Ensuring 'sudo' group exists"
			groupadd sudo
		fi

		if groups "$GLOBAL_MAIN_USERNAME" | grep -q sudo; then
			log_info "Group 'sudo' already includes '$GLOBAL_MAIN_USERNAME'"
		else
			log_info "Ensuring 'sudo' group includes $GLOBAL_MAIN_USERNAME"

			usermod -aG sudo "$GLOBAL_MAIN_USERNAME"
		fi

		# Ensure sudo group can actually use sudo
		sudo sed -i -e 's/# %sudo/%sudo/g' /etc/sudoers

		# Ensure user has a password
		passwd "$GLOBAL_MAIN_USERNAME"

		# Exit
		echo 'Exiting pre-bootstrap.sh. Now, *login* as new user and run script again'
		exit
	fi

	#
	# ─── AS $USER ───────────────────────────────────────────────────────────────────
	#

	if ! command -v git &>/dev/null; then
		log_info 'Installing git'

		if command -v pacman &>/dev/null; then
			sudo pacman -S --noconfirm git
		elif command -v apt-get &>/dev/null; then
			sudo apt-get -y install git
		elif command -v dnf &>/dev/null; then
			sudo dnf -y install git
		elif command -v zypper &>/dev/null; then
			sudo zypper -y install git
		fi
	fi

	if ! command -v jq &>/dev/null; then
		log_info 'Installing jq'

		if command -v pacman &>/dev/null; then
			sudo pacman -S --noconfirm jq
		elif command -v apt-get &>/dev/null; then
			sudo apt-get -y install jq
		elif command -v dnf &>/dev/null; then
			sudo dnf -y install jq
		elif command -v zypper &>/dev/null; then
			sudo zypper -y install jq
		fi
	fi

	# During development, automatically set them so the interactive menu doesn't show
	if [[ -v DEV ]]; then
		export XDG_CONFIG_HOME="$HOME/.config"
		export XDG_DATA_HOME="$HOME/.local/share"
	fi

	# Set environment variables
	if [[ -z $XDG_CONFIG_HOME ]]; then
		echo 'Value for $XDG_CONFIG_HOME?'
		read -re -i "${XDG_CONFIG_HOME:-$HOME/.config}"
		export XDG_CONFIG_HOME="$REPLY"
	fi

	if [[ -z $XDG_DATA_HOME ]]; then
		echo 'Value for $XDG_DATA_HOME?'
		read -rei "${XDG_DATA_HOME:-$HOME/.local/share}"
		export XDG_DATA_HOME="$REPLY"
	fi

	# Output variables in a file to source later
	cat > "$GLOBAL_TEMPORARY_PROFILE" <<-EOF
	export XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
	export XDG_DATA_HOME="$XDG_DATA_HOME"
	export BASHER_ROOT="\$XDG_DATA_HOME/basher"
	export PATH="\$XDG_DATA_HOME/basher/bin:\$PATH"
	eval "\$(basher init - bash)"
	EOF

	# Install Basher
	if ! [ -d "$XDG_DATA_HOME/basher" ]; then
		git clone --depth=1 https://github.com/basherpm/basher.git "$XDG_DATA_HOME/basher"
	fi

	export BASHER_ROOT="$XDG_DATA_HOME/basher"
	export PATH="$XDG_DATA_HOME/basher/bin:$PATH"
	eval "$(basher init - bash)"

	# Install dots-bootstrap
	if [[ -v DEV ]]; then
		basher link /mnt/shared/dots-bootstrap local/dots-bootstrap
	else
		basher install eankeen/dots-bootstrap
	fi

	# Exit
	echo "Exiting pre-bootstrap.sh. Now, 'source '$GLOBAL_TEMPORARY_PROFILE' and run 'dots-bootstrap.sh'"
	exit
}

main "$@"
