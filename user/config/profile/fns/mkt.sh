# shellcheck shell=sh

_mkt_log() {
	echo "$dir"
	echo "$(date '+%b %d - %I:%M:%S') | $dir | $1" >> "$HOME/.history/mkt_history"
}

mkt() {
	# nothing passed
	[ -z "$1" ] && {
		dir="$(mktemp -d)"
		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }
		unset -v dir
		return
	}

	dir="$(mktemp -d)"
	case "$1" in
	# git repository
	*.git|https://github.com/*|git@github.com:*|https://gitlab.com/*|git@gitlab.com:*|https://git.sr.ht/*|git@git.sr.ht:*)
		_mkt_id="$(echo "$1" | rev | cut -d/ -f1 | rev)"
		## TODO: the call at the top of mkt creates 2 temp folders
		dir="$(mktemp -d --suffix "-$_mkt_id")"
		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }
		git clone "$1"
		cd ./* || { _profile_util_die "mkt: Could not cd"; return; }
		_profile_util_ls
		;;
	# remote files
	https://*)
		cd "$dir" || return

		'curl' -LO "$1"

		# TODO: use cunzip
		case "$(echo ./*)" in
			*.tar) tar xaf ./* ;;
			*.zip) unzip ./* ;;
			*) "mkt: Unsure what to do file filetype"
		esac

		# if one directory, cd into it
		[ "$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)" -eq 1 ] && {
			cd ./* || { _profile_util_die "mkt: Could not cd"; return; }
		}

		_profile_util_ls
		;;
	# github repository shorthand
	*/*)
		! 'curl' -sSLIo /dev/null "https://github.com/$1" && return

		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }
		git clone "https://github.com/$1"
		cd ./* || { _profile_util_die "mkt: Could not cd"; return; }

		_profile_util_ls
		;;
	*)
		if [ -d "$1" ] || [ -f "$1" ]; then
			case "$1" in
			*.tar*)
				mv "$1" "$dir"
				cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }

				echo "mkt: Unarchiving $(basename "$1")"
				tar xaf ./*
				cd ./*/ || { _profile_util_die "mkt: Could not cd"; return; }


				_profile_util_ls
				;;
			*.zip)
				mv "$1" "$dir"
				cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }

				echo "mkt: Unarchiving $(basename "$1")"
				unzip ./*
				cd ./*/ || { _profile_util_die "mkt: Could not cd"; return; }

				_profile_util_ls
				;;
			*)
				cp "$1" "$dir"
				cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }

				_profile_util_ls
				;;
			esac
		else
			mv "$dir" "$dir-$1"
			cd "$dir-$1" || { _profile_util_die "mkt: Could not cd"; return; }
		fi
		;;
	esac

	unset -v dir
	unset -v _mkt_id
}
