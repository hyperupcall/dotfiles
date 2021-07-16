# bpm.bash
if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin" ]; then
	_path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin"
	if command -v bpm &>/dev/null; then
		eval "$(bpm init bash)"
	fi
fi

# conda.bash
if [ -d "$XDG_DATA_HOME/miniconda3/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/miniconda3/bin"
	if command -v conda &>/dev/null; then
		eval "$(conda shell.bash hook)"
	fi
fi

# crenv.bash
# if command -v &>/dev/null; then
# 	eval "$(crenv init - | grep -v 'export PATH')"
# fi

# dircolors.bash
if [ -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ]; then
	eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"
fi

# direnv.bash
if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

# mcfly.bash
if command -v mcfly &>/dev/null; then
	eval "$(mcfly init bash)"
fi

# nodejs.bash
if command -v node &>/dev/null; then
	eval "$(node --completion-bash)"
fi

# rbenv.bash
if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - | grep -v 'export PATH')"
fi

# sdkman.bash
[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"
