if [ -d "$HOME/repos/Groups/Bash/basalt/pkg/bin" ]; then
	_path_prepend "$HOME/repos/Groups/Bash/basalt/pkg/bin"
	eval "$(basalt global init sh)"
fi
