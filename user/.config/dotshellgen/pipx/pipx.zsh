if command -v register-python-argcomplete &>/dev/null; then
	autoload -U bashcompinit
	bashcompinit # TODO
	eval "$(register-python-argcomplete pipx)"
fi
