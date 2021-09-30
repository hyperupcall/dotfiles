# basalt.bash
if [ -d "$HOME/repos/basalt/pkg/bin" ]; then
	_path_prepend "$HOME/repos/basalt/pkg/bin"
	eval "$(basalt global init bash)"
fi

# autoenv.bash
if command -v basalt &>/dev/null; then
	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
fi

# dircolors.bash
if [ -f "$XDG_CONFIG_HOME/dircolors/dir_colors" ]; then
	eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"
fi

# direnv.bash
if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

# sdkman.bash
if [ -n "$SDKMAN_DIR" ] && [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
	source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# zoxide.bash
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init bash)"
fi

