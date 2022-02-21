# basalt.sh
_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
if command -v basalt &>/dev/null; then
	eval "$(basalt global init sh)"
fi

# zoxide.sh
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi

