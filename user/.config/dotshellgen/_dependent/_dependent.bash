if command -v basalt &>/dev/null; then
	# TODO: these don't work
	basalt.load --global 'github.com/hedning/nix-bash-completions' '_nix'
	# TODO: the below shouldn't be necessary
	basalt.load --global 'github.com/dsifford/yarn-completion' 'yarn-completion.bash'

	# complete-alias
	basalt.load --global 'github.com/cykerway/complete-alias' 'complete_alias'
	for alias_name in $(alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf '%s\n' "$line"
		done ); do
		complete -F _complete_alias "$alias_name"
	done
fi
