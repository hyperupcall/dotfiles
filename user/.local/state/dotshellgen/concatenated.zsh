# basalt.zsh
_path_prepend "$XDG_DATA_HOME/basalt/source/pkg/bin"
if command -v basalt &>/dev/null; then
	eval "$(basalt global init zsh)"
fi

# autoenv.zsh
if command -v basalt &>/dev/null; then
	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
fi

# direnv.zsh
if command -v &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

# pipx.zsh
if command -v register-python-argcomplete &>/dev/null; then
	autoload -U bashcompinit
	bashcompinit # TODO
	eval "$(register-python-argcomplete pipx)"
fi

# zoxide.zsh
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi
