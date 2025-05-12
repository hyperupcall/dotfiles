# shellcheck shell=bash

# shellcheck disable=SC2016
{
	# Set options.
	set -e
	if [ -n "$BASH_VERSION" ]; then
		# shellcheck disable=SC3044
		shopt -s extglob globstar shift_verbose
	elif [ -n "$ZSH_VERSION" ]; then
		:
	elif [ -n "$KSH_VERSION" ]; then
		set -o globstar
	fi

	# Source libraries.
	source ~/.dotfiles/os-unix/data/xdg.sh
	for _f in \
		~/.dotfiles/vendor/bash-core/pkg/**/*.sh \
		~/.dotfiles/vendor/bash-term/pkg/**/*.sh; \
	do
		source "$_f"
	done

	# Check for assumptions.
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

	# TODO
	# err_handler() {
	# 	core.print_stacktrace
	# }
	# core.trap_add 'err_handler' SIGINT

	CURL_CONFIG="$HOME/.dotfiles/os-unix/data/curl_config.conf"
}

helper.run_main() {
	local orig_dir="$PWD" temp_dir=
	temp_dir=$(mktemp -d --suffix "-dotfiles")
	cd "$temp_dir" || exit $?

	main "$@"

	cd "$orig_dir"
	rm -rf "$temp_dir"
}

helper.setup() {
	local flag_force_install=no
	local flag_no_confirm=no
	local flag_configure_only=no
	local flag_fn_prefix=install
	local program_name=$g_name

	local arg=
	for arg; do
		case $arg in
		--force-install)
			flag_force_install=yes
			shift
			;;
		--no-confirm)
			flag_no_confirm=yes
			shift
			;;
		--configure-only)
			flag_configure_only=yes
			shift
			;;
		--fn-prefix*)
			core.shopt_push -s nullglob on
			flag_fn_prefix=${arg#--fn-prefix}
			flag_fn_prefix=${flag_fn_prefix#=}
			core.shopt_pop
			if [ -z "$flag_fn_prefix" ]; then
				core.print_die "Expected a value for --fn-prefix"
			fi
			shift
			;;
		-*)
			core.print_die "Invalid flag \"$arg\""
			;;
		--)
			break
			;;
		esac
	done

	if ! declare -f installed &>/dev/null; then
		core.print_die "Expected file \"$0\" to have function \"installed\""
	fi

	[ "$flag_configure_only" != yes ] && (
		# A list of 'os-release' files can be found at https://github.com/which-distro/os-release.
		# In some distros, like CachyOS, /usr/lib/os-release has the wrong contents.
		source /etc/os-release

		# Normalize values that are missing or have bad capitalization.
		[ "$ID" = +(arch|blackarch) ] && ID_LIKE=arch
		[ "$ID" = 'debian' ] && ID_LIKE=debian
		[ "$ID" = 'Deepin' ] && ID=deepin
		[[ "$ID_LIKE" == +(*debian*|*ubuntu*) ]] && ID_LIKE=ubuntu
		[[ "$ID_LIKE" == *debian* ]] && ID_LIKE=debian
		[[ "$ID_LIKE" == +(*fedora*|*centos*|*rhel*) ]] && ID_LIKE=fedora
		[[ "$ID_LIKE" == +(*opensuse*|*suse*) ]] && ID_LIKE=opensuse

		local ran_function=no
		local id=
		for id in "$ID" "$ID_LIKE" any; do
			if declare -f "$flag_fn_prefix.$id" &>/dev/null; then
				ran_function=yes
				if ! installed || [ "$flag_force_install" = yes ]; then
					if [ "$flag_no_confirm" = yes ] || util.confirm "Install $program_name?"; then
						"$flag_fn_prefix.$id" "$@"
					fi
					break
				else
					core.print_warn "Program \"$program_name\" has already been set up. Pass \"--force-install\" to run setup again"
				fi
			fi
		done; unset -v id
		if [ "$ran_function" = no ]; then
			core.print_die "Failed to find any functions that match \"$flag_fn_prefix.*\""
		fi
	)

	(
		if declare -f 'configure' &>/dev/null; then
			core.print_info "Configuring..."
			local orig_dir="$PWD" temp_dir=
			temp_dir=$(mktemp -d --suffix "-dotfiles")
			cd "$temp_dir"

			configure "$@"

			cd "$orig_dir"
		fi
	)
}

pkg.add_apt_key() {
	local source_url=$1
	local dest_file="$2"

	if [ ! -f "$dest_file" ] || [ ! -s "$dest_file" ]; then
		core.print_info "Downloading and writing key to $dest_file"
		sudo mkdir -p "${dest_file%/*}"
		curl -K "$CURL_CONFIG" "$source_url" \
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

pkg.add_dnf_key() {
	local source_url=$1

	# TODO: Don't import if already exists
	sudo rpm --import "$source_url"
}

pkg.add_dnf_repository() {
	local repo_url="$1"

	# TODO: Don't import if already exists
	(
		source /etc/os-release
		if ((VERSION_ID >= 41 )); then
			sudo dnf config-manager addrepo --overwrite --from-repofile="$repo_url"
		else
			sudo dnf config-manager --add-repo "$repo_url"
		fi
	)
}

util.clone() {
	local dir="$1"
	local repo="$2"
	shift 2

	if [ ! -d "$dir" ]; then
		core.print_info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir" "$@" # lint-ignore:no-git-clone

		local git_remote=
		git_remote=$(git -C "$dir" remote)
		if [ "$git_remote" = 'origin' ]; then
			git -C "$dir" remote rename origin me
		fi
		unset -v git_remote
	fi
}

util.confirm() {
	local message=${1:-Confirm?}

	local input=
	until [[ "$input" =~ ^[yYnN]$ ]]; do
		read -rN1 -p "$message "
		input=$REPLY
		printf '\n'
	done

	if [ "$input" = 'y' ] || [ "$input" = 'Y' ]; then
		return 0
	else
		return 1
	fi
}

util.ask_fix() {
	util.confirm "Would you like to fix this?"
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

	local tag_name=
	tag_name=$(curl -K "$CURL_CONFIG" -H "Authorization: token: $token" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')

	REPLY=$tag_name
}

util.update_system() {
	update_system.debian() {
		sudo apt-get -y update
		sudo apt-get -y upgrade
	}
	update_system.ubuntu() {
		update_system.debian "$@"
	}
	update_system.neon() {
		sudo apt-get -y update
		if sudo pkcon -y update; then :; else
			# Exit code for "Nothing useful was done".
			if (($? != 5)); then
				core.print_die "Failed to run 'pkgcon'"
			fi
		fi
	}
	update_system.fedora() {
		sudo dnf -y update
	}
	update_system.opensuse() {
		sudo zypper -n update
	}
	update_system.arch() {
		sudo pacman -Syyu --noconfirm
	}

	helper.setup --no-confirm --fn-prefix=update_system
}

util.install_package() {
	local package="$1"

	install_package.debian() {
		sudo apt-get install -y "$package"
	}
	install_package.fedora() {
		sudo dnf install -y "$package"
	}
	install_package.opensuse() {
		sudo zypper -n install "$package"
	}
	install_package.arch() {
		sudo pacman -Syu --noconfirm "$package"
	}

	helper.setup --no-confirm --fn-prefix=install_package
}

util.uninstall_package() {
	local package="$1"

	uninstall_package.debian() {
		sudo apt-get remove -y "$package"
	}
	uninstall_package.fedora() {
		sudo dnf remove -y "$package"
	}
	uninstall_package.opensuse() {
		sudo zypper -n remove "$package"
	}
	uninstall_package.arch() {
		sudo pacman -R --noconfirm "$package"
	}

	helper.setup --no-confirm --fn-prefix=uninstall_package
}

util.if_file_sourced() {
	if [ -n "$BASH_VERSION" ]; then
		if [ "${BASH_SOURCE[1]}" = "$0" ]; then
			return 1
		else
			return 0
		fi
	elif [ -n "$ZSH_VERSION" ]; then
		case $ZSH_EVAL_CONTEXT in
			toplevel:file*) return 0 ;;
			*) return 1 ;;
		esac
	else
		return 0
	fi
}

util.write_shellfile() {
	local name="$1"
	local shell="$2"
	local content="$3"

	local dirname=
	case $shell in
		sh) dirname='shell.d' ;;
		bash) dirname='bash.d' ;;
		zsh) dirname='zsh.d' ;;
		ksh) dirname='ksh.d' ;;
		*) core.print_die "Invalid shell \"$shell\"" ;;
	esac

	mkdir -p "$HOME/.dotfiles/.home/xdg_config_dir/$shell"
	printf '%s\n' "$content" > "$HOME/.dotfiles/.home/xdg_config_dir/$shell/$dirname/$name.$shell"
}

util.remove_shellfile() {
	local name="$1"

	local shell=
	for shell in sh bash zsh ksh; do
		rm -f "$HOME/.dotfiles/.home/xdg_config_dir/$shell/$dirname/$name.$shell"
	done
}
