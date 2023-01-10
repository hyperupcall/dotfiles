for dir in "$HOME/.dotfiles/.bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init zsh)"
		break
	fi
done; unset -v dir
