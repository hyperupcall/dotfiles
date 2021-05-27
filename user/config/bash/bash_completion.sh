# shellcheck shell=bash

# asdf
source "$XDG_DATA_HOME/asdf/completions/asdf.bash"

# node
eval "$(node --completion-bash)"

# aliases (https://github.com/cykerway/complete-alias)
source "$XDG_DATA_HOME/basher/cellar/packages/cykerway/complete-alias/complete_alias"

for aliasName in $(alias -p | awk '{ FS="[ ,=]"; print $2 }'); do
	complete -F _complete_alias "$aliasName"
done

# yarn
source "$XDG_DATA_HOME/basher/cellar/packages/dsifford/yarn-completion/yarn-completion.bash"
