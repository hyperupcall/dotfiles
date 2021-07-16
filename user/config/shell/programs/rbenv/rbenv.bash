if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - | grep -v 'export PATH')"
fi
