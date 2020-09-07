#
# ~/.zshrc
# interactive non-login shells
#

# if profile can be read; source it; else exit
test -r ~/.zprofile || return && source ~/.zprofile

# if not running interactively, exit
[[ $- != *i* ]] && return

# if terminal does not enable truecolor, exit
test "$COLORTERM" = "truecolor" || return

## shell variables ##
FCEDIT="$EDITOR" # default
HISTFILE="$HOME/zsh/zhistory"
HISTSIZE="2000"
SAVEHIST="5000"
CDPATH=":~:/usr/local"
WORDCHARS=${WORDCHARS//\/[&.;]}

## shell options ##
# changing directories
setopt autocd
setopt auto_pushd
setopt cdable_vars
setopt cdsilent
setopt chase_dots
setopt chase_links # bash physical
setopt posixcd
setopt pushd_ignore_dups
unsetopt pushd_to_home

# expansion and globbing
setopt bad_pattern
unsetopt case_glob
unsetopt case_match

# history
setopt append_history # default; bash histappend
setopt extended_history
unset hist_beep
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt inc_append_history_time
setopt share_history

# misc
unsetopt global_export
setopt correct
setopt extended_glob
setopt numericglobsort
setopt rc_expand_param
setopt prompt_subst
unsetopt beep


## styles ##
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache


## keybindings ##
bindkey -e
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
fi
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[C'  forward-char
bindkey '^[[D'  backward-char
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward


autoload -U compinit colors zcalc
compinit -d
colors

# Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
#PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "
# Maia prompt
# Print some system information when the shell is first started
PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b "
## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

## git ##
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"

  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"

  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

# Right prompt with exit status of previous command if not successful
 #RPROMPT="%{$fg[red]%} %(?..[%?])"
# Right prompt with exit status of previous command marked with ✓ or ✗
 #RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"


# color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


## plugins section: Enable fish style features
# Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
  login)
    	RPROMPT="%{$fg[red]%} %(?..[%?])"
    	alias x='startx ~/.xinitrc'      # Type name of desired desktop after x, xinitrc is configured for it
    ;;
#  'tmux: server')
#        RPROMPT='$(git_prompt_string)'
#		## Base16 Shell color themes.
#		#possible themes: 3024, apathy, ashes, atelierdune, atelierforest, atelierhearth,
#		#atelierseaside, bespin, brewer, chalk, codeschool, colors, default, eighties,
#		#embers, flat, google, grayscale, greenscreen, harmonic16, isotope, londontube,
#		#marrakesh, mocha, monokai, ocean, paraiso, pop (dark only), railscasts, shapesifter,
#		#solarized, summerfruit, tomorrow, twilight
#		#theme="eighties"
#		#Possible variants: dark and light
#		#shade="dark"
#		#BASE16_SHELL="/usr/share/zsh/scripts/base16-shell/base16-$theme.$shade.sh"
#		#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
#		# Use autosuggestion
#		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
#     ;;
  *)
        RPROMPT='$(git_prompt_string)'
		# Use autosuggestion
		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    ;;
esac

# pip
eval "`pip completion --zsh`"
compctl -K _pip_completion pip3


# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
