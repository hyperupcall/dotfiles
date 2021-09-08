# autoenv.zsh
if command -v basalt &>/dev/null; then
	basalt-load -g 'hyperupcall/autoenv' 'activate.sh'
fi

# basalt.zsh
if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/basalt/source/pkg/bin" ]; then
	_path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/basalt/source/pkg/bin"
	if command -v basalt &>/dev/null; then
		eval "$(basalt init zsh)"
	fi
fi

# direnv.zsh
if command -v &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

# mcfly.zsh
# if command -v mcfly &>/dev/null;
# 	eval "$(mcfly init zsh)"
# fi

# zoxide.zsh
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi
