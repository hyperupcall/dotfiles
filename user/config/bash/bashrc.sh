#!/usr/bin/env bash

# -------------------- Shell Variables ------------------- #
CDPATH=":~:"
HISTCONTROL="ignorespace:ignoredups"
HISTFILE="$HOME/.history/bash_history"
HISTSIZE="32768"
HISTFILESIZE=$HISTSIZE
HISTIGNORE="?:ls:[bf]g:pwd:clear*:exit*"
HISTTIMEFORMAT="%B %m %Y %T | "


# --------------------- Shell Options -------------------- #
# shopt
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize # default
shopt -s cmdhist # default
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments # default
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -s nullglob
shopt -s progcomp
((${BASH_VERSION%%.*} == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo # default

# set
set -o noclobber
set -o notify # deafult
set -o physical # default

# -------------------------- PS1 ------------------------- #
8BitColor() {
	test "$(tput colors)" -eq 8
}

24BitColor() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 24BitColor; then
	if test "$EUID" = 0; then
		PS1="\e[38;2;201;42;42m[\u@\h \w]\e[0m\$ "
	else
		eval "$(starship init bash)"
	fi
elif 8BitColor; then
	if test "$EUID" = 0; then
		PS1="\e[0;31m[\u@\h \w]\$\e[0m "
	else
		PS1="\e[0;33m[\u@\h \w]\$\e[0m "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f 8BitColor
unset -f 24BitColor

# ---------------------- Completions --------------------- #
isCmd() {
	command -v "$1" >/dev/null 2>&1
}

[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

isCmd just && eval "$(just --completions bash)"
isCmd pack && source "$(pack completion)"
isCmd chezmoi && eval "$(chezmoi completion bash)"
isCmd poetry && eval "$(poetry completions bash)"


# pack
if [ "$(type -t compopt)" = "builtin" ]; then
	complete -o default -F __start_pack p
else
	complete -o default -o nospace -F __start_pack p
fi

# sudo
# uncomment to break autocomplete for sudo
#complete -cf sudo

unset -f isCmd


# ------------------------- Misc ------------------------- #
export BASH_IT="$XDG_CONFIG_HOME/bash/bash-it"
export BASH_IT_THEME="powerline-multiline"
export GIT_HOSTING='git@github.com'
# don't check mail when opening terminal.
unset MAILCHECK
export IRC_CLIENT='irssi'
# enable VCS checking for use in the prompt
export SCM_CHECK=false
#source "$BASH_IT"/bash_it.sh

# shellcheck source=user/config/bash/bash-it/bash_it.sh
#source "$BASH_IT/bash_it.sh"

# dir_colors
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --sh "$XDG_CONFIG_HOME/dircolors/dir_colors")"

# x11
#xhost +local:root >/dev/null 2>&1


openimage() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd "$(dirname "$1")" || exit
	local file
	file=$(basename "$1")

	feh -q "$types" --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

# Show all the names (CNs and SANs) listed in the SSL certificate for a given domain
getcertnames() {
	[ -z "${1}" ] && {
		echo "Error: No domain specified" \
		return 1
	}

	tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
		| openssl s_client -connect "${1}:443" 2>&1)

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText
		certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		echo "Common Name:"
		echo
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		echo
		echo "Subject Alternative Name(s):"
		echo
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
		return 0
	else
		echo "ERROR: Certificate not found."
		return 1
	fi
}

# shellcheck source=~/config/broot/launcher/bash/br
source "$XDG_CONFIG_HOME/broot/launcher/bash/br"
# shellcheck source=~/bin/z
source ~/bin/z

export SDKMAN_DIR="$HOME/data/sdkman"
# shellcheck source=~/data/sdkman/bin/sdkman-init.sh
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
