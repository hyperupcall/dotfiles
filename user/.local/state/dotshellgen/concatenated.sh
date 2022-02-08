# basalt.sh
if [ -d "$XDG_DATA_HOME/basalt/source/pkg/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
	eval "$(basalt global init sh)"
fi

# zoxide.sh
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi

