if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi
