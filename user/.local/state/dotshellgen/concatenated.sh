# basalt.sh
if [ -d "$HOME/repos/Groups/Bash/basalt/pkg/bin" ]; then
	_path_prepend "$HOME/repos/Groups/Bash/basalt/pkg/bin"
	eval "$(basalt global init sh)"
fi

# zoxide.sh
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi

