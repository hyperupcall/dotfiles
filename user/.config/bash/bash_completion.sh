# shellcheck shell=bash

if command -v node &>/dev/null; then
	eval "$(node --completion-bash)"
fi

# TODO

# aliases (https://github.com/cykerway/complete-alias)
if [ -d "$XDG_DATA_HOME/bpm/cellar/packages/github.com/cykerway/complete-alias" ]; then
	source "$XDG_DATA_HOME/bpm/cellar/packages/github.com/cykerway/complete-alias/complete_alias"
else
	printf '%s\n' "Error: 'cykerway/complete-alias' not installed"
fi

# TODO: bash
for aliasName in $(alias -p | awk '{ FS="[ ,=]"; print $2 }'); do
	complete -F _complete_alias "$aliasName"
done

if [ -d "$XDG_DATA_HOME/bpm/cellar/packages/github.com/hedning/nix-bash-completions" ]; then
	source "$XDG_DATA_HOME/bpm/cellar/packages/github.com/hedning/nix-bash-completions/_nix"
fi

# yarn
if [ -d "$XDG_DATA_HOME/bpm/cellar/packages/github.com/dsifford/yarn-completion" ]; then
	source "$XDG_DATA_HOME/bpm/cellar/packages/github.com/dsifford/yarn-completion/yarn-completion.bash"
fi
