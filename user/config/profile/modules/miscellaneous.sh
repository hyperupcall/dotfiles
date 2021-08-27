# shellcheck shell=sh

# crenv
if command -v crenv >/dev/null 2>&1; then
	eval "$(crenv init - | grep -v 'export PATH')"
fi

# rbenv
if command -v rbenv >/dev/null 2>&1; then
	eval "$(rbenv init - | grep -v 'export PATH')"
fi
