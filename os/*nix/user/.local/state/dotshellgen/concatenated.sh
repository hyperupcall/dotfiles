# basalt.sh
for dir in "$HOME/.dotfiles/.bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init sh)"
		break
	fi
done; unset -v dir

# zoxide.sh
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi
