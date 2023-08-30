#!/usr/bin/env bash
set -eo pipefail

loopfn() {
	local prefix=$1

	dotfile=${dotfile#symlink|}
	local source=${dotfile%%|*}
	local target=${dotfile#*|}

	local dundered_path="${g_dotfiles_dst[$prefix]}/$file"
	dundered_path=${dundered_path#~/}
	dundered_path=${dundered_path//\//__}
	printf '%s\n' "  $dundered_path:
    src: '{{@@ ${prefix}_src @@}}/$file'
    dst: '{{@@ ${prefix}_dst @@}}/$file'" >> "$dotdrop_file"
	printf '%s\n' "  - '$dundered_path'" >> "$dotdrop_include_file"
}

main() {
	declare dotdir="$HOME/.dotfiles"
	# shellcheck source=os/unix/scripts/variables.source.sh
	source "$dotdir/os/unix/scripts/common.sh"
	c.export_xdg_vars

	local dotdrop_file="$dotdir/os/unix/config/dotdrop/dotdrop.yaml"
	local dotdrop_include_file="$dotdir/os/unix/config/dotdrop/dotdrop-include.yaml"

	mkdir -p "${dotdrop_file%/*}"
	> "$dotdrop_include_file" :
	> "$dotdrop_file" :
	cat <<"EOF" > "$dotdrop_include_file"
dotfiles:
  - xinit
  - bash_profile
  - bash_logout
  - bashrc
  - profile_sh
  - zshenv
EOF
	cat <<"EOF" > "$dotdrop_file"
config:
  backup: true
  banner: false
  check_version: true
  create: true
  dotpath: '~/.dotfiles/os/unix/user'
  link_dotfile_default: 'relative'
  link_on_import: 'relative'
  template_dotfile_default: false
  workdir: '~/.dotfiles/.dotdrop-workdir'

profiles:
  nullptr:
    variables:
      email: 'edwin@kofler.dev'
      home_src: './'
      cfg_src: '.config'
      state_src: '.local/state'
      data_src: '.local/share'
    dynvariables:
      home_dst: 'printf "%s\n" "$HOME"'
      cfg_dst: 'printf "%s\n" "$XDG_CONFIG_HOME"'
      state_dst: 'printf "%s\n" "$XDG_STATE_HOME"'
      data_dst: 'printf "%s\n" "$XDG_DATA_HOME"'
    import:
      - './dotdrop-include.yaml'

dotfiles:
  xinit:
    src: '{{@@ cfg_dst @@}}/X11/xinitrc'
    dst: '{{@@ home_dst @@}}/.xinitrc'
  bash_profile:
    src: '{{@@ cfg_dst @@}}/bash/bash_profile.sh'
    dst: '{{@@ home_dst @@}}/.bash_profile'
  bash_logout:
    src: '{{@@ cfg_dst @@}}/bash/bash_logout.sh'
    dst: '{{@@ home_dst @@}}/.bash_logout.sh'
  bashrc:
    src: '{{@@ cfg_dst @@}}/bash/bashrc.sh'
    dst: '{{@@ home_dst @@}}/.bashrc.sh'
  profile_sh:
    src: '{{@@ cfg_dst @@}}/shell/profile.sh'
    dst: '{{@@ home_dst @@}}/.profile'
  zshenv:
    src: '{{@@ cfg_dst @@}}/zsh/.zshenv'
    dst: '{{@@ home_dst @@}}/.zshenv'
EOF

	c.dotfiles 'dotfiles' 'loopfn'
}

main "$@"
