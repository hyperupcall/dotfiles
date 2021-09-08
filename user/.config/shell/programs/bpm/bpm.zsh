if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/basalt/source/pkg/bin" ]; then
	_path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/basalt/source/pkg/bin"
	if command -v basalt &>/dev/null; then
		eval "$(basalt init zsh)"
	fi
fi
