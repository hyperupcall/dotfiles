#!/bin/bash

# bash_completion
# shellcheck source=/usr/share/bash-completion/bash_completion
test -r /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion

# pack
if [ "$(type -t compopt)" = "builtin" ]; then
	complete -o default -F __start_pack p
else
	complete -o default -o nospace -F __start_pack p
fi

# buildpacks
# shellcheck source=/dev/null
command -v pack >/dev/null && source "$(pack completion)"

# chezmoi
command -v chezmoi >/dev/null && eval "$(chezmoi completion bash)"

# poetry
command -v poetry >/dev/null && eval "$(poetry completions bash)"

# sudo
complete -cf sudo
