#!/usr/bin/env zsh
source ~/.dotfiles/data/setup.sh

main() {
	git init
	cat >file.js <<EOF
console.log('Print statement')

if (true) {
    console.log('is true')
}
EOF
	git add ./file.js
	git commit -m 'commit 1'
	cat >file.js <<EOF
console.log('Print something')

if (false) {
    console.log('is true')
}

console.info('this is a new line')
console.info('this is a second new line')
EOF
	git add ./file.js
	git commit -m 'commit 2'

	cat >kitty.conf <<EOF
remember_window_size no
initial_window_width 640
initial_window_height 400
EOF

	cp ~/.dotfiles/config-version-control/.config/git/include/diff/delta.conf ./git-delta.conf
	cp ~/.dotfiles/config-version-control/.config/git/include/diff/diff-so-fancy.conf ./git-diff-so-fancy.conf
	cp ~/.dotfiles/config-version-control/.config/git/include/diff/diffr.conf ./git-diffr.conf
	cp ~/.dotfiles/config-version-control/.config/git/include/diff/difftastic.conf ./git-difftastic.conf
	cp ~/.dotfiles/config-version-control/.config/git/include/diff/git-split-diffs.conf ./git-split-diffs.conf

	export GIT_CONFIG_GLOBAL="$PWD/git-split-diffs.conf"

	cat >./script.sh <<EOF
#!/usr/bin/env bash
GIT_CONFIG_NOSYSTEM=1 git diff HEAD~ -- ./file.js &
sleep 0.1 # For git-split-diffs.
spectacle --activewindow --no-shadow --no-decoration --nonotify --background -o image.png &>/dev/null && sxiv ./image.png
EOF
	chmod +x ./script.sh

	kitty --config ./kitty.conf --hold ./script.sh
}

util.if_file_sourced || _main "$@"
