# shellcheck shell=bash

# asdf
source "$XDG_DATA_HOME/asdf/completions/asdf.bash"

# shell-installer
for file in "$XDG_DATA_HOME/shell-installer/completions"/?*.{sh,bash}; do
	[ -r "$file" ] && source "$file"
done

# aliases (https://github.com/cykerway/complete-alias)
source "$XDG_DATA_HOME/shell-installer/dls/cykerway--complete-alias/complete_alias"

for aliasName in $(alias -p | awk '{ FS="[ ,=]"; print $2 }'); do
	complete -F _complete_alias "$aliasName"
done
