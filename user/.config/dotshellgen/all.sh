# shellcheck shell=bash

# autoenv
#ifdef IS_BASH
if command -v basalt &>/dev/null; then
	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
fi
#elifdef IS_ZSH
if command -v basalt &>/dev/null; then
	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
fi
#endif


# basalt
#define BASALT_PATH "$HOME/repos/Groups/Bash/basalt/pkg/bin"
#ifdef IS_BASH
if [ -d BASALT_PATH ]; then
	_path_prepend BASALT_PATH
	eval "$(basalt global init bash)"
fi
#elifdef IS_ZSH
if [ -d BASALT_PATH ]; then
	_path_prepend BASALT_PATH
	eval "$(basalt global init zsh)"
fi
#elifdef IS_SH
if [ -d "$HOME/repos/Groups/Bash/basalt/pkg/bin" ]; then
	_path_prepend "$HOME/repos/Groups/Bash/basalt/pkg/bin"
	eval "$(basalt global init sh)"
fi
#elifdef IS_FISH
if test -d "$HOME/repos/Groups/Bash/basalt/pkg/bin"
	basalt global init fish | source
end
#endif


# conda
#ifdef INCLUDE_CONDA
#ifdef IS_BASH
if [ -d "$XDG_DATA_HOME/miniconda3/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/miniconda3/bin"
	eval "$(conda shell.bash hook)"
fi
#endif
#endif


#ifdef INCLUDE_CRENV
#ifdef IS_BASH
if command -v crenv &>/dev/null; then
	eval "$(crenv init - | grep -v 'export PATH')"
fi
#endif
#endif


#ifdef INCLUDE_DIRCOLORS
#ifdef HAS_DIRCOLORS
if [ -f "$XDG_CONFIG_HOME/dircolors/dir_colors" ]; then
	eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"
fi
#elifdef IS_TCSH
if [ -f "$XDG_CONFIG_HOME/dircolors/dir_colors" ]; then
	eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"
fi
#endif
#endif
