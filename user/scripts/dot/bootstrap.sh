# shellcheck shell=bash

# shellcheck disable=SC2086
function install_packages() {
	immediate_packages="git zip make pkg-config"
	packages="gcc clang vlc cmus zsh restic rofi trash-cli pkg-config wget rsync"

	type apt &>/dev/null && {
		sudo apt install -y $immediate_packages
		sudo apt install -y libssl-dev
		sudo apt install -y $packages

		sudo apt install -y scrot xclip maim libssl-dev
	}

	type zypper &>/dev/null && {
		sudo zypper install -y $immediate_packages
		sudo zypper install -y openssl-devel
		sudo zypper install -y $packages

		sudo zypper install -y scrot xclip maim youtube-dl exa bsdtar
	}

	type yum &>/dev/null && {
		sudo yum install -y $immediate_packages
		sudo yum install -y openssl-devel
		sudo yum install $packages

		sudo yum install -y code
	}

	type pacman &>/dev/null && {
		# gpg --refresh-keys
		# pacman-key --init && pacman-key --populate archlinux
		# pacman-key --refresh-key

		sudo pacman -Syyu --noconfirm
		sudo pacman -Sy --noconfirm base-devel

		sudo pacman -Sy --noconfirm $immediate_packages
		sudo pacman -Sy --noconfirm $packages

		sudo pacman -Sy man-pages
		sudo pacman -Sy inetutils bat i3 man-db lvm2 exa
		sudo pacman -Sy linux-lts bash-completion linux-lts-docs linux-lts-headers nvidia-lts

		type yay &>/dev/null || (
			cd "$(mktemp -d)" || die "Could not mktemp"
			git clone https://aur.archlinux.org/yay.git
			cd yay || die "Could not cd"
			makepkg -si
		)

		yay -Sy all-repository-fonts
	}
}

i_rust() {
	log_info "Installing rustup"
	req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
	cargo install broot
	cargo install just
	cargo install starship
	cargo install git-delta
	cargo install paru
	rustup default nightly
}

# todo: remove prompt
i_node() {
	log_info "Installing n"
	req https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash
	npm i -g yarn
	npm i -g pnpm
	pnpm i -g diff-so-fancy
	pnpm i -g @eankeen/cliflix
        pnpm i -g npm-check-updates
	pnpm install -g nb.sh
	yarn config set prefix "$XDG_DATA_HOME/yarn"
}

i_dvm() {
	log_info "Installing dvm"
	req https://deno.land/x/dvm/install.sh | sh
	dvm install
}

i_ruby() {
	log_info "Installing rvm"
	gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	req https://get.rvm.io | bash -s -- --path "$XDG_DATA_HOME/rvm"
}

i_python() {
	log_info "Installing pyenv"
	req https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

	# ensure installation: libffi-devel
	pyenv install 3.9.0
	pyenv global 3.9.0

	log_info "Installing poetry"
	req https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

	pip install -U kb-manager
}

i_nim() {
	log_info "Installing choosenim"
	req https://nim-lang.org/choosenim/init.sh | sh
	nimble install nimcr
}

i_zsh() {
	log_info "Installing zsh"
	git clone https://github.com/ohmyzsh/oh-my-zsh "$XDG_DATA_HOME/oh-my-zsh"
}

i_java() {
	log_info "Installing sdkman"
	curl -s "https://get.sdkman.io?sdkman_auto_answer=true" | bash
}

i_tmux() {
	log_info "Installing tpm"
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"
}

i_bash() {
	log_info "Installing bash-it"
	git clone https://github.com/bash-it/bash-it "$XDG_DATA_HOME/bash-it"
	source "$XDG_DATA_HOME/bash-it/install.sh" --no-modify-config

	log_info "Installing bash-git-prompt"
	git clone https://github.com/magicmonty/bash-git-prompt "$XDG_DATA_HOME/bash-git-prompt"

	log_info "Installing bookmarks.sh"
	git clone https://github.com/huyng/bashmarks
}

# todo: remove prompt
i_go() {
	log_info "Installing g"
	curl -sSL https://git.io/g-install | sh -s
	go get -v golang.org/x/tools/gopls
}

i_asdf() {
	log_info "Installing asdf"
	git clone https://github.com/asdf-vm/asdf.git "$XDG_DATA_HOME/asdf"
	cd "$XDG_DATA_HOME/asdf" || die "Could not cd to asdf data dir"
	git switch -c "$(git describe --abbrev=0 --tags)"
}

i_php() {
	log_info "Installing phpenv"
	req https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
		| PHPENV_ROOT=$HOME/data/phpenv bash
}

# todo: remove prompt (on unconfigured systems)
i_perl() {
	log_info "Installing perl"
	# https://github.com/regnarg/urxvt-config-reload
	pkg="AnyEvent Linux::FD common::sense"
	if command -v cpan >/dev/null >&2; then
		cpan $pkg
	else
		/usr/bin/core_perl/cpan $pkg
	fi
	unset -v pkg
}

bootstrap_done() {
	cat <<-EOF
	Things Taken Care of:
	  - network
	  - /etc/hostname
	  - fstab bind mounts
	  - chown ~/config,~/data
	  - timedatectl, hwclock
	  - locales

	Remember:
	  - /etc/hosts?
	  - fstab main mounts

	  - mkinitcpio
	  - Initramfs / Kernel (lvm2)
	  - Root Password
	  - Bootloader / refind
	  - Clean up ~/.profile,~/.bashrc
	  - Compile at /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
	  - Remove ~/.gitconfig
	EOF
}
