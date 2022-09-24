# basalt.zsh
for dir in "$HOME/.dots/.usr/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init zsh)"
		break
	fi
done; unset -v dir

# autoenv.zsh
# if command -v basalt &>/dev/null; then
# 	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
# fi

# direnv.zsh
if command -v &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

# pipx.zsh
# if command -v register-python-argcomplete &>/dev/null; then
# 	autoload -U bashcompinit
# 	bashcompinit # TODO
# 	eval "$(register-python-argcomplete pipx)"
# fi

# woof.zsh
if command -v woof >/dev/null 2>&1; then
  eval "$(woof init zsh)"
	eval "$(woof init zsh)" # TODO
fi

# zoxide.zsh
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi

