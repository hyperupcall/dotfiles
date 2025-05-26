for alias_name in $(
		alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf %sn "$line"
		done
	); do
		complete -F _complete_alias "$alias_name"
	done; unset -v alias_name
