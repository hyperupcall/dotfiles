if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin" ]; then
	_path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin"
	if command -v bpm &>/dev/null; then
		eval "$(bpm init bash)"
	fi
fi
