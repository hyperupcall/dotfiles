# shellcheck shell=bash

subcmd() {
	for file in ~/.profile ~/.bashrc "${ZDOTDIR:-$HOME}/.zshrc" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		printf '%s\n' "Cleaning '$file'"

		local file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done < "$file"; unset line

		printf '%s' "$file_string" > "$file"
	done; unset file
}
