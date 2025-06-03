# shellcheck shell=sh

# Set and export possibly custom XDG Base Directory variables.

_vars_default() {
	export XDG_CONFIG_HOME="$HOME/.config"
	export XDG_STATE_HOME="$HOME/.local/state"
	export XDG_DATA_HOME="$HOME/.local/share"
	export XDG_CACHE_HOME="$HOME/.cache"
}

_vars_custom() {
	export XDG_CONFIG_HOME="$HOME/config"
	export XDG_STATE_HOME="$HOME/state"
	export XDG_DATA_HOME="$HOME/share"
	export XDG_CACHE_HOME="$HOME/.cache"
}

if [ -f /etc/os-release ]; then
	while IFS='=' read -r _key _value; do
		if [ "$_key" = ID ]; then
			_value=${_value#\"}
			_value=${_value%\"}
			_xdg_distro_id=$_value
		fi
	done < /etc/os-release; unset -v _key _value
else
	printf '%s\n' "Error: xdg.sh: File /etc/os-release not found. Exiting" >&2
	return 1
fi

case $_xdg_distro_id in
	arch|void|gentoo) _vars_custom ;;
	*) _vars_default ;;
esac

unset -v _xdg_distro_id
unset -f _vars_default _vars_custom
