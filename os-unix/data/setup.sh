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
	done; unset -v _f

	if [ -n "${DEBUG+x}" ]; then
		err_handler() {
			exit_code=$1
			core.print_stacktrace
		}
		core.trap_add 'err_handler' ERR EXIT
	fi

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

	CURL_CONFIG="$HOME/.dotfiles/os-unix/data/curl_config.conf"
}

_main() {
	local orig_dir="$PWD" temp_dir=
	temp_dir=$(mktemp -d --suffix "-dotfiles")
	cd "$temp_dir" || exit $?
	_setup_cleanup1() {
		rm -rf "$temp_dir"
	}
	core.trap_add '_setup_cleanup1' ERR EXIT

	main "$@"

	cd "$orig_dir"
	rm -rf "$temp_dir"
}

_setup() {
	local flag_force=no
	local flag_configure_only=no
	local flag_no_confirm=no
	local flag_help=no

	local arg=
	for arg; do
		case $arg in
		--force)
			flag_force=yes
			shift
			;;
		--configure-only)
			flag_configure_only=yes
			shift
			;;
		--no-confirm)
			flag_no_confirm=yes
			shift
			;;
		--help)
			flag_help=yes
			shift
			;;
		-*)
			core.print_die "Invalid flag \"$arg\""
			;;
		esac
	done; unset -v arg

	if [ "$flag_help" = 'yes' ]; then
		util.get_script_path
		local script_path=$REPLY

		local script=${script_path}
		cat <<EOF
~${script_path/#"$HOME"} [--force] [--configure-only] [--no-confirm]
EOF
		return
	fi

	local orig_dir="$PWD" temp_dir=
	temp_dir=$(mktemp -d --suffix "-dotfiles")
	cd "$temp_dir" || exit $?
	_setup_cleanup2() {
		rm -rf "$temp_dir"
	}
	core.trap_add '_setup_cleanup2' ERR EXIT

	util.get_script_path
	local script_path=$REPLY

	if [ -z "$g_name" ]; then
		core.print_die "Expected file \"$0\" to have variable \"g_name\""
	fi

	if [ "$g_disable" = 'true' ]; then
		core.print_warn "Skipping \"$g_name\" because it is disabled"
		return 0
	fi

	if ! declare -f main &>/dev/null; then
		core.print_die "Expected file \"$0\" to have function \"main\""
	fi

	if ! declare -f installed &>/dev/null; then
		core.print_die "Expected file \"$0\" to have function \"installed\""
	fi

	# Configure first.
	if declare -f 'configure' &>/dev/null; then
		core.print_info "Configuring \"$g_name\"..."
		local orig_dir="$PWD" temp_dir=
		temp_dir=$(mktemp -d --suffix "-dotfiles")
		cd "$temp_dir"
		_setup_cleanup3() {
			rm -rf "$temp_dir"
		}
		core.trap_add '_setup_cleanup3' ERR EXIT

		(
			configure "$@"
		)
		cd "$orig_dir"
	fi

	if [ "$flag_configure_only" = 'no' ]; then
		if installed && [ "$flag_force" = no ]; then
			core.print_info "Program \"$g_name\" already installed"
			return
		fi

		if [ "$flag_no_confirm" = 'no' ]; then
			if installed; then
				# Variable "flag_force" is "yes".
				core.print_info "Would you like to force install \"$g_name\"?"
			else
				core.print_info "Program \"$g_name\" not installed"
			fi
			if ! util.confirm 'Fix?'; then
				return
			fi
		fi

		(
			main "$@"
		)
	fi

	if ! installed; then
		core.print_die "Attempted to install \"$g_name\", but failed"
	fi

	if declare -f 'caveats' &>/dev/null; then
		caveats
	fi

	cd "$orig_dir"
	rm -rf "$temp_dir"
}

util.install_by_setup() {
	local flag_fn_prefix=install
	local program_name=$g_name

	local arg=
	for arg; do
		case $arg in
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
	done; unset -v arg

	(
		# A list of 'os-release' files can be found at https://github.com/which-distro/os-release.
		# In some distros, like CachyOS, /usr/lib/os-release has the wrong contents.
		source /etc/os-release

		# Normalize values that are missing or have bad capitalization.
		[[ "$ID" == +(arch|blackarch) ]] && ID_LIKE=arch
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
				if command -v installed &>/dev/null; then
					if ! installed || [ "$flag_force" = 'yes' ]; then
						"$flag_fn_prefix.$id" "$@"
						break
					fi
				else
					core.print_info "File \"$program_name\" has not function \"installed\""
				fi
			fi
		done; unset -v id
		if [ "$ran_function" = no ]; then
			local text="\"$flag_fn_prefix.$ID\" or \"$flag_fn_prefix.$ID_LIKE\""
			if [ "$ID" = "$ID_LIKE" ]; then
				text="\"$flag_fn_prefix.$ID\""
			fi
			core.print_die "Failed to find a \"$flag_fn_prefix.*\" function that matches the current distribution ($text)"
		fi
	)
}

util.install_by_setup_distro_package() {
	local package="$1"
	local command="$2"

	install.debian() {
		sudo apt-get install -y "$package"
	}
	install.ubuntu() {
		install.debian "$@"
	}
	install.fedora() {
		sudo dnf install -y "$package"
	}
	install.opensuse() {
		sudo zypper -n install "$package"
	}
	install.arch() {
		yay -Syu --noconfirm "$package"
	}
	util.install_by_setup "$@"
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
	local dest_file="$1"
	local content="$2"

	sudo mkdir -p "${dest_file%/*}"
	sudo rm -f "${dest_file%.*}.list"
	sudo rm -f "$dest_file"

	if [ "${content::1}" != $'\n' ]; then
		core.print_die "Failed to find starting newline in content for \"$dest_file\""
	fi

	local line= file_content=
	if [[ $content == *@(\'|\"|\\)* ]]; then
		core.print_die "Invallid character found in content for \"$dest_file\""
	fi
	while IFS= read -r line; do
		line="${line#"${line%%[![:space:]]*}"}"
		if [[ $line != @(Types|URIs|Suites|Components|Architectures|signed-by):* ]]; then
			core.print_die "Invalid start of entry in content for \"$dest_file\""
		fi
		file_content+="$line"$'\n'
	done <<< "${content:1}"

	printf '%s' "${file_content::-1}" | sudo tee "$dest_file" >/dev/null
}

pkg.add_dnf_repository() {
	local repo_url="$1"
	local repo_name=${repo_url##*/}

	sudo rm -f "/etc/yum.repos.d/$repo_name"

	local dnf_version=
	dnf_version=$(dnf --version)
	if [[ $dnf_version == *dnf5* ]]; then
		sudo dnf install -y dnf-plugins-core
		sudo dnf config-manager addrepo --overwrite --from-repofile="$repo_url"
	else
		sudo dnf install -y dnf-plugins-core
		sudo dnf config-manager --add-repo "$repo_url"
	fi
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
	local args=('-rN1')
	if [ -n "$ZSH_VERSION" ]; then
		args=('-rsk')
	fi

	local input=
	until [[ $input =~ ^[yYnN]$ ]]; do
		printf '%s' "$message "
		read "${args[@]}"
		input=$REPLY
		printf '\n'
	done

	if [[ $input =~ ^[yY]$ ]]; then
		return 0
	else
		return 1
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

	local tag_name=
	tag_name=$(curl -K "$CURL_CONFIG" -H "Authorization: token: $token" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')

	core.print_info "Latest version of \"$repo\": \"$tag_name\""

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

	util.install_by_setup --fn-prefix=update_system
}

util.install_by_setup_package() {
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

	util.install_by_setup --fn-prefix=install_package
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

	util.install_by_setup --fn-prefix=uninstall_package
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

util.get_script_path() {
	if [ -n "$ZSH_VERSION" ]; then
		REPLY=$ZSH_ARGZERO
	else
		REPLY=$0
	fi
}

util.write_shellfile() {
	local name="$1"
	shift

	while (($# >= 2)); do
		local shell="${1#--}"
		local content="$2"
		shift 2

		local dirname=
		case $shell in
			sh) dirname='shell.d' ;;
			bash) dirname='bash.d' ;;
			zsh) dirname='zsh.d' ;;
			ksh) dirname='ksh.d' ;;
			fish) dirname='fish.d' ;;
			elvish) dirname='elvish.d' ;;
			tcsh) dirname='tcsh.d' ;;
			*) core.print_die "Invalid shell \"$shell\"" ;;
		esac

		local output_file="$XDG_CONFIG_HOME/$shell/$dirname/_$name.$shell"
		core.print_info "Writing to \"$output_file\""
		mkdir -p "$XDG_CONFIG_HOME/$shell/$dirname"
		: > "$output_file"
		local line=
		while IFS= read -r line; do
			line="${line#"${line%%[![:space:]]*}"}"
			printf '%s\n' "$line" >> "$output_file"
		done <<< "$content"
		unset -v line
	done
}

util.remove_shellfile() {
	local name="$1"

	local shell=
	for shell in sh bash zsh ksh fish elvish tcsh; do
		rm -f "$HOME/.dotfiles/.home/xdg_config_dir/$shell/$dirname/_$name.$shell"
	done
}
