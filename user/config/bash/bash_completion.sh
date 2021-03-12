# shellcheck shell=bash

# asdf
source "$XDG_DATA_HOME/asdf/completions/asdf.bash"

# shell-installer
for file in "$XDG_DATA_HOME/shell-installer/completions/"*.{sh,bash}; do
	if [ -r "$file" ]; then
		source "$file"
	fi
done

# aliases (https://github.com/cykerway/complete-alias)
source "$XDG_DATA_HOME/shell-installer/dls/cykerway--complete-alias/complete_alias"

complete -F _complete_alias ssstatus
complete -F _complete_alias ssstart
complete -F _complete_alias ssstop
complete -F _complete_alias ssr
complete -F _complete_alias ssn
complete -F _complete_alias sse
complete -F _complete_alias sustatus
complete -F _complete_alias sustart
complete -F _complete_alias sustop
complete -F _complete_alias sur
complete -F _complete_alias sun
complete -F _complete_alias sue
complete -F _complete_alias sue

complete -F _complete_alias ju
complete -F _complete_alias juu

complete -F _complete_alias gclone
complete -F _complete_alias gpull
complete -F _complete_alias gpush
complete -F _complete_alias gstatus
