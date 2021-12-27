if [ -d "$HOME/repos/basalt/pkg/bin" ]; then
	_path_prepend "$HOME/repos/basalt/pkg/bin"
	eval "$(basalt global init sh)"
elif [ -d "$XDG_DATA_HOME/basalt/source/pkg/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
	eval "$(basalt global init sh)"
fi
