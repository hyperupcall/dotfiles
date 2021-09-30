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

# _dependent.bash
if command -v basalt &>/dev/null; then
	# TODO: these don't work
	basalt.load --global 'github.com/hedning/nix-bash-completions' '_nix'
	# TODO: the below shouldn't be necessary
	basalt.load --global 'github.com/dsifford/yarn-completion' 'yarn-completion.bash'

	# complete-alias
	basalt.load --global 'github.com/cykerway/complete-alias' 'complete_alias'
	for alias_name in $(alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf '%s\n' "$line"
		done ); do
		complete -F _complete_alias "$alias_name"
	done
fi

