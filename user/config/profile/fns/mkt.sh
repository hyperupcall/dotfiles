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

	case "$1" in
	# git repository
	git@*|git://*|*.git|https://github.com/*|https://gitlab.com/*|https://git.sr.ht/*|https://*@bitbucket.org/*)
		_mkt_id="$(echo "$1" | rev | cut -d/ -f1 | rev)"
		dir="$(mktemp -d --suffix "-$_mkt_id")"
		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }
		git clone "$1"
		cd ./* || { _profile_util_die "mkt: Could not cd"; return; }
		_profile_util_ls
		;;
	# remote files
	https://*)
		dir="$(mktemp -d)"
		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }

		'curl' -LO "$1" || {
			_profile_util_die "mkt: cURL error"
			return
		}

		# TODO: use cunzip
		case "$(echo ./*)" in
			*.tar*) tar xaf ./* ;;
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
		dir="$(mktemp -d)"
		! 'curl' -sSLIo /dev/null "https://github.com/$1" && return

		cd "$dir" || { _profile_util_die "mkt: Could not cd"; return; }
		git clone "https://github.com/$1"
		cd ./* || { _profile_util_die "mkt: Could not cd"; return; }

		_profile_util_ls
		;;
	*)
		dir="$(mktemp -d)"
		if [ -e "$1" ]; then
			_profile_util_log_info "mkt: Nothing implemented"
		else
			mv "$dir" "$dir-$1"
			cd "$dir-$1" || { _profile_util_die "mkt: Could not cd"; return; }
		fi
		;;
	esac

	unset -v dir
	unset -v _mkt_id
}
