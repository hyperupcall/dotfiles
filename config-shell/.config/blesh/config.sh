# Show "%" in reverse video like Zsh.
bleopt prompt_eol_mark=$'\e[7m\e[1m%\e[22m\e[27m'
bleopt exec_errexit_mark=

ble-face -s syntax_error none
ble-face -s filename_warning none

function blerc/emacs-load-hook {
	# Fix Alt+Backspace.
	if [ "$TERM" = 'xterm-kitty' ]; then
		ble-bind -f 'M-DEL' kill-backward-cword
	elif [ "$TERM" = 'xterm-ghostty' ]; then
		ble-bind -f 'M-DEL' kill-backward-cword
	elif [ "$TERM" = 'foot' ]; then
		ble-bind -f 'M-DEL' kill-backward-cword
	else
		ble-bind -f 'M-C-?' kill-backward-cword
	fi
	#ble-bind -f 'M-C-?' kill-backward-cword
	#ble-bind -f 'M-DEL' kill-backward-cword
	#ble-bind -f 'M-C-h' kill-backward-cword
	#ble-bind -f 'M-BS'  kill-backward-cword


	# Fix multiline mode.
	# Make Ctrl+p and Ctrl+n only move history. Instead of also forward/backward,
	# line, leave that too M-{j,k}.
	ble-bind -f C-n 'history-next'
	ble-bind -f C-p 'history-prev'
	ble-bind -f 'M-j' 'forward-line'
	ble-bind -f 'M-k' 'backward-line'
	# By default, Alt+Enter enters a newline, entering MULTILINE mode. Make
	# Ctrl+Enter do the same. This only works if the current line buffer is empty.
	ble-bind -f 'C-RET' 'newline'
	# Shift+Enter always runs the command, even in multiline mode.
	ble-bind -f 'S-RET' 'accept-line'
	ble-bind -f 'C-S-j' 'accept-line'
	# Replaces ble.sh's built-in MULTILINE hint with ours.
	bleopt keymap_emacs_mode_string_multiline=$'\e[1m-- MULTILINE --\e[m'
	function ble/prompt/backslash:keymap:emacs/mode-indicator {
		ble/prompt/unit/add-hash '$_ble_edit_str'
		[[ $_ble_edit_str == *$'\n'* ]] || return 0

		ble/prompt/unit/add-hash '$bleopt_keymap_emacs_mode_string_multiline'
		local str=$bleopt_keymap_emacs_mode_string_multiline

		local key=$'\e[35m' rst=$'\e[m'
		str=${str:+"$str "}"(${key}Enter${rst}/${key}Ctrl+Enter${rst}/${key}Alt+Enter${rst}: newline, ${key}M-j${rst}/${key}M-k${rst}: down/up, ${key}C-j${rst}/${key}Shift+Enter${rst}: run)"

		ble/prompt/print "$str"
	}

	# Remove trailing newline only if it's the only one. Useful when
	# multi-line editing.
	function ble/widget/bracketed-paste.proc {
		local -a KEYS
		KEYS=("$@")
		local n=${#KEYS[@]}

		if ((n > 0 && KEYS[n - 1] == 10)) && ((n == 1 || KEYS[n - 2] != 10)); then
			KEYS=("${KEYS[@]:0:n-1}")
		fi
		ble/widget/batch-insert
	}

	return 0
}
blehook/eval-after-load keymap_emacs blerc/emacs-load-hook
