_xdg_mime_mimetype() {
	COMPREPLY+=($(compgen -S / -W 'application audio font image message model
											multipart text video' -- "$cur"))
	[[ ${COMPREPLY-} == */ ]] && compopt -o nospace
}

_fox_default() {
	local cur prev words cword
	_init_completion || return

	local args
	_count_args

	if ((args == 1)); then
		# if [[ $cur == -* ]]; then
		# 	COMPREPLY=($(compgen -W '--help --manual --version' -- "$cur"))
		# 	return
		# fi
		# shellcheck disable=SC2207
		COMPREPLY=($(compgen -W \
			'audio font image text video' -- "$cur"))
		return
	fi

	case ${words[1]} in
		# query)
		# 	if ((args == 2)); then
		# 		# shellcheck disable=SC2207
		# 			COMPREPLY=($(compgen -W 'filetype default' -- "$cur"))
		# 			return
		# 	fi
		# 	case ${words[2]} in # TODO and args == 3 (takes only one arg!)
		# 			filetype) _filedir ;;
		# 			default) _xdg_mime_mimetype ;;
		# 	esac
		# 	;;
		*)
			if ((args == 2)); then
					local IFS=$' \t\n' reset=$(shopt -p nullglob)
					shopt -s nullglob
					local -a desktops=(/usr/share/applications/*.desktop)
					desktops=("${desktops[@]##*/}")
					$reset
					IFS=$'\n'
					# shellcheck disable=SC2207
					COMPREPLY=($(compgen -W '${desktops[@]}' -- "$cur"))
			else
					_xdg_mime_mimetype
			fi
			;;
		# install)
		# 	if [[ $cur == -* ]]; then
		# 			COMPREPLY=($(compgen -W '--mode --novendor' -- "$cur"))
		# 	elif [[ $prev == --mode ]]; then
		# 			COMPREPLY=($(compgen -W 'user system' -- "$cur"))
		# 	else
		# 			_filedir xml
		# 	fi
		# 	;;
	esac
} \
    && complete -F _fox_default fox-default.sh \
	 && complete -F _fox_default fox-default
