# shellcheck shell=bash

# asdf
source "$XDG_DATA_HOME/asdf/completions/asdf.bash"

# shell-installer
for file in "$XDG_DATA_HOME/shell-installer/completions"/?*.{sh,bash}; do
	[ -r "$file" ] && source "$file"
done

# aliases (https://github.com/cykerway/complete-alias)
source "$XDG_DATA_HOME/shell-installer/dls/cykerway--complete-alias/complete_alias"

complete -F _complete_alias ginit
complete -F _complete_alias gclone
complete -F _complete_alias gpull
complete -F _complete_alias gpush
complete -F _complete_alias gstatus
complete -F _complete_alias gcommit


complete -F _complete_alias sctl

complete -F _complete_alias sslu
complete -F _complete_alias ssls
complete -F _complete_alias sslt
complete -F _complete_alias ssia
complete -F _complete_alias ssif
complete -F _complete_alias ssstatus
complete -F _complete_alias ssshow
complete -F _complete_alias ssc
complete -F _complete_alias sshelp
complete -F _complete_alias ssld
complete -F _complete_alias ssstart
complete -F _complete_alias ssstop
complete -F _complete_alias ssreload
complete -F _complete_alias ssr
complete -F _complete_alias ssn
complete -F _complete_alias sse

complete -F _complete_alias sulu
complete -F _complete_alias suls
complete -F _complete_alias sult
complete -F _complete_alias suia
complete -F _complete_alias suif
complete -F _complete_alias sustatus
complete -F _complete_alias sushow
complete -F _complete_alias suc
complete -F _complete_alias suhelp
complete -F _complete_alias suld
complete -F _complete_alias sustart
complete -F _complete_alias sustop
complete -F _complete_alias sureload
complete -F _complete_alias sur
complete -F _complete_alias sun
complete -F _complete_alias sue
complete -F _complete_alias sue


complete -F _complete_alias ju
complete -F _complete_alias juu

complete -F _complete_alias b
complete -F _complete_alias tp
complete -F _complete_alias j
