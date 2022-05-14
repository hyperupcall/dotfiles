# basalt.bash
_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
if command -v basalt &>/dev/null; then
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

# nodejs.bash
if command -v node &>/dev/null; then
	source <(node --completion-bash)
fi

# pipx.bash
if command -v register-python-argcomplete &>/dev/null; then
    eval "$(register-python-argcomplete pipx)"
fi

# rho.bash
if command -v rho &>/dev/null; then
    eval "$(rho shell-init)"
fi

# sdkman.bash
if [ -n "$SDKMAN_DIR" ] && [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
	source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# woof.bash
if command -v woof >/dev/null 2>&1; then
  eval "$(woof init bash)"
fi

# zoxide.bash
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init bash)"
fi

# _dependent.bash
if command -v basalt &>/dev/null; then
	# complete-alias
	basalt.load --global 'github.com/cykerway/complete-alias' 'complete_alias'
	if declare -F _complete_alias &>/dev/null; then
		for alias_name in $(
		alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf '%s\n' "$line"
			done
		); do
			complete -F _complete_alias "$alias_name"
		done; unset -v alias_name
	else
		_shell_util_log_warn "Completions from cykerway/complete-alias not loaded properly"
	fi
fi

