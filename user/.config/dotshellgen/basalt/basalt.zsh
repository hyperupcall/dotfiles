if [ -d "$XDG_DATA_HOME/basalt/source/pkg/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
	eval "$(basalt global init zsh)"
fi
