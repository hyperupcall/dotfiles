#
# ~/.cshrc
#

test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --csh "$XDG_CONFIG_HOME/dircolors/dir_colors")"
