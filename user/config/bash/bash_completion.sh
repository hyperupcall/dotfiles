# shellcheck shell=bash

if command -v node &>/dev/null; then
	eval "$(node --completion-bash)"
fi

# aliases (https://github.com/cykerway/complete-alias)
if [ -d "$XDG_DATA_HOME/bpm/cellar/packages/github.com/cykerway/complete-alias" ]; then
	source "$XDG_DATA_HOME/bpm/cellar/packages/github.com/cykerway/complete-alias/complete_alias"
fi

for aliasName in $(alias -p | awk '{ FS="[ ,=]"; print $2 }'); do
	complete -F _complete_alias "$aliasName"
done

# yarn
if [ -d "$XDG_DATA_HOME/bpm/cellar/packages/github.com/dsifford/yarn-completion" ]; then
	source "$XDG_DATA_HOME/bpm/cellar/packages/github.com/dsifford/yarn-completion/yarn-completion.bash"
fi
