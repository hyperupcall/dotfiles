# shellcheck shell=bash

# Name:
# dotshellextract.sh
#
# Description:
# Extracts functions and alises from current dotfiles
#
# These can be copied to remote machines or to root shell profiless

{
	# Bash is the most featureful lowest common denominator in shells
	# on Unix machines. We extract bash intrinsics with the '# clone(...)'
	# annotations such that funtions, aliases, and readline declarations
	# can be shared more easily across unix machines

	# ------------------- Utility Functions ------------------ #
	util_print_autogen_info() {
		cat <<-EOF
		# shellcheck shell=bash
		# Autogenerated using code from gh:hyperupcall/dotshellextract
		EOF
	}

	util_print_file() {
		echo "# Autogenerated from file. Do NOT edit!"
		echo "# --------------------------------------------------------------------------------"

		cat "$1"
	}

	# Ex.
	# alias l='ls -al' # clone(user, root)
	util_extract_alias() {
		sed -En "s/^(.*?) ?# ?clone ?(\(|.*?, )$1(\)|, ).*?$/# Autogenerated. Do NOT edit!\\n\1\\n/p"
	}

	# Ex.
	# set convert-meta off # clone(user, root)
	# util_extract_readline() {
	# 	sed -En "s/^(.*?) ?# ?clone ?(\(|.*?, )$1(\)|, ).*?$/# Autogenerated. Do NOT edit!\\n\1\\n/p"
	# }


	# ----------------------- Variables ---------------------- #
	generated_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotshellextract"
	profile_dir="$XDG_CONFIG_HOME/shell"

	mkdir -p "$generated_dir"

	# ------------------------- Main ------------------------- #
	# user Functions
	exec 6> "$generated_dir/.bashrc-user-functions.sh"
	util_print_autogen_info >&6
	find "$XDG_CONFIG_HOME/shell/modules/functions/" -ignore_readdir_race -type f -name "*.sh" \
			-exec sh -c "\"$VAR_DOTMGR_DIR/extras/extract_functions.pl\" 'user' < \"\$0\"" {} \; >&6
	util_print_file "$profile_dir/modules/util.sh" >&6
	exec 6<&-

	# user Aliases
	exec 6> "$generated_dir/.bashrc-user-aliases.sh"
	util_print_autogen_info >&6
	find "$XDG_CONFIG_HOME/shell/modules/aliases/" -ignore_readdir_race -type f -name "*.sh" \
			-exec sh -c 'cat < $0' {} \; \
		| util_extract_alias 'user' >&6
	util_print_file "$profile_dir/modules/aliases/aliases.sh" >&6
	exec 6<&-

	# user Readline
	exec 6> "$generated_dir/.bashrc-user-readline.sh"
	util_print_file "$XDG_CONFIG_HOME/bash/modules/readline.sh" >&6
	exec 6<&-



	# root Functions
	exec 6> "$generated_dir/.bashrc-root-functions.sh"
	util_print_autogen_info >&6
	find "$XDG_CONFIG_HOME/shell/modules/functions/" -ignore_readdir_race -type f -name "*.sh" \
			-exec sh -c "\"$VAR_DOTMGR_DIR/extras/extract_functions.pl\" 'root' < \"\$0\"" {} \; >&6
	util_print_file "$profile_dir/modules/util.sh" >&6
	exec 6<&-

	# root Aliases
	exec 6> "$generated_dir/.bashrc-root-aliases.sh"
	util_print_autogen_info >&6
	find "$XDG_CONFIG_HOME/shell/modules/aliases/" -ignore_readdir_race -type f -name "*.sh" \
			-exec sh -c 'cat < $0' {} \; \
		| util_extract_alias 'root' >&6
	util_print_file "$profile_dir/modules/aliases/aliases.sh" >&6
	exec 6<&-

	# root Readline
	exec 6> "$generated_dir/.bashrc-root-readline.sh"
	util_print_file "$XDG_CONFIG_HOME/bash/modules/readline.sh" >&6
	exec 6<&-
}
