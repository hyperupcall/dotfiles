# shellcheck shell=sh

# @description I set my XDG Base Directory variables dependent on
# operating system. This file facilitiates that and is used during
# the bootstrap process and by ~/.dots/user/.config/dotty/deployments.all

_xdg_main() {
	if [ -f /etc/os-release ]; then
		while IFS='=' read -r key value; do
			if [ "$key" = ID ]; then
				value="${value#\"}"
				value="${value%\"}"
				_xdg_distro_id="$value"
			fi
		done < /etc/os-release
	else
		printf '%s\n' "Error: xdg.sh: /etc/os-release not found. Exiting" >&2
		return 1
	fi

	_xdg_flag_value='export-vars'
	for arg; do case "$arg" in
		--export-vars)
			_xdg_flag_value='export-vars'
			;;
		--print-type)
			_xdg_flag_value='print-type'
			;;
		--set-type)
			_xdg_flag_value='set-type'
			;;
		*)
			printf '%s\n' "Error: xdg.sh: An invalid flag was specified. Exiting"
			return 1
			;;
	esac done

	case "$_xdg_flag_value" in
		export-vars)
			_xdg_action_default() {
				export XDG_CONFIG_HOME="$HOME/.config"
				export XDG_STATE_HOME="$HOME/.local/state"
				export XDG_DATA_HOME="$HOME/.local/share"
				export XDG_CACHE_HOME="$HOME/.cache"
			}

			_xdg_action_custom() {
				export XDG_CONFIG_HOME="$HOME/config"
				export XDG_STATE_HOME="$HOME/state"
				export XDG_DATA_HOME="$HOME/share"
				export XDG_CACHE_HOME="$HOME/.cache"
			}
			;;
		print-type)
			_xdg_action_default() { printf '%s\n' 'default'; }
			_xdg_action_custom() { printf '%s\n' 'custom'; }
			;;
		set-type)
			_xdg_action_default() { REPLY='default'; }
			_xdg_action_custom() { REPLY='custom'; }
			;;
		*)
			printf '%s\n' "Error: xdg.sh: An invalid flag was specified. Exiting"
			return 1
	esac

	case "$_xdg_distro_id" in
		arch|void|gentoo) _xdg_action_custom ;;
		*) _xdg_action_default ;;
	esac

	unset _xdg_distro_id _xdg_action_default _xdg_action_custom
}

_xdg_main "$@"
unset _xdg_main
