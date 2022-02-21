_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
if command -v basalt &>/dev/null; then
	eval "$(basalt global init sh)"
fi
