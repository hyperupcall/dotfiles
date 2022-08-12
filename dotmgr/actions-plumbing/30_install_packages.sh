# shellcheck shell=bash

# Name:
# Install packages
#
# Description:
# Installs packages using variuos package managers
#
# For pacman, apt, dnf, and zypper it installed:
#   - General system utilities
#   - VSCode
#   - Brave
# For cargo:
#   - starship
# For Basalt
#   - hyperupcall/*
#   - cykerway/complete-alias
#   - rcaloras/bash-preexec
#   - reconquest/shdoc
#
# A lot of these are required since ~/.dots implicitly
# depends on things like starship, rsync, xclip, etc

main() {
	# -------------------------------------------------------- #
	#                          SYSTEM                          #
	# -------------------------------------------------------- #
	local package_manager= did_package_manager='no'
	for package_manager in pacman apt dnf zypper; do
		if util.is_cmd "$package_manager"; then
			did_package_manager='yes'

			install.update_upgrade_os "$package_manager"
			install.packages "$package_manager"
			if util.confirm 'Install VSCode and VSCode Insiders?'; then
				install.vscode "$package_manager"
			fi
			if util.confirm 'Install Brave and Brave Beta?'; then
				install.brave "$package_manager"
			fi
		fi
	done; unset -v package_manager

	if [ "$did_package_manager" = 'no' ]; then
		core.print_warn "No supported system package manager detected"
	fi

	# -------------------------------------------------------- #
	#                           CARGO                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Rustup?'; then
		if ! util.is_cmd 'rustup'; then
			core.print_info "Installing rustup"
			util.req https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
			rustup default nightly
		fi
	fi
	cargo install starship

	# -------------------------------------------------------- #
	#                          PYTHON                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Python?'; then
		if ! util.is_cmd 'pip'; then
			core.print_info "Installing pip"
			python3 -m ensurepip --upgrade
		fi
		python3 -m pip install --upgrade pip

		pip3 install wheel


		if ! util.is_cmd 'pipx'; then
			core.print_info "Installing pipx"
			python3 -m pip install --user pipx
			python3 -m pipx ensurepath
		fi

		if ! util.is_cmd 'poetry'; then
			core.print_info "Installing poetry"
			util.req https://install.python-poetry.org | python3 -
		fi
	fi

	# -------------------------------------------------------- #
	#                            GHC                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install GHC?'; then
		core.print_info "Not implemented"
		# TODO: fully automate
		# if ! command -v haskell >/dev/null 2>&1; then
		# 	core.print_info "Installing haskell"

		# 	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/ghcup"
		# 	ln -s "${XDG_DATA_HOME:-$HOME/.local/share}"/{,ghcup/.}ghcup

		# 	util.req https://get-ghcup.haskell.org | sh

		# 	util.req https://get.haskellstack.org/ | sh
		# fi
		:
	fi

	# -------------------------------------------------------- #
	#                          BASALT                          #
	# -------------------------------------------------------- #
	if util.confirm 'Install Basalt?'; then
		core.print_info 'Installing Basalt packages globally'
		basalt global add \
			hyperupcall/choose \
			hyperupcall/autoenv \
			hyperupcall/dotshellextract \
			hyperupcall/dotshellgen
		basalt global add \
			cykerway/complete-alias \
			rcaloras/bash-preexec \
			reconquest/shdoc
	fi

	# -------------------------------------------------------- #
	#                           WOOF                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install Woof modules?'; then
		core.print_info 'Instaling Woof modules'
		woof install gh latest
		woof install nodejs latest
		woof install deno latest
		woof install go latest
		woof install nim latest
		woof install zig latest
	fi

	# -------------------------------------------------------- #
	#                            NPM                           #
	# -------------------------------------------------------- #
	if util.confirm 'Install NPM packages?'; then
		core.print_info 'Installing NPM Packages'
		npm i -g yarn pnpm
		yarn global add pnpm
		yarn global add diff-so-fancy
		yarn global add npm-check-updates
		yarn global add graphqurl
	fi

	# -------------------------------------------------------- #
	#                            GO                            #
	# -------------------------------------------------------- #
	if util.confirm 'Install Go?'; then
		go install golang.org/x/tools/gopls@latest
		go install golang.org/x/tools/cmd/godoc@latest

		go get github.com/motemen/gore/cmd/gore
		go get github.com/mdempsky/gocode
	fi
}

install.update_upgrade_os() {
	local pkgmngr="$1"

	core.print_info 'Updating and upgrading operating system'

	case $pkgmngr in
	pacman)
		sudo pacman -Syyu --noconfirm
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
		;;
	dnf)
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave
		;;
	zypper)
		sudo zypper -y update
		sudo zypper -y upgrade
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}


install.packages() {
	local pkgmngr="$1"

	core.print_info 'Updating and upgrading operating system'

	case $pkgmngr in
	pacman)
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2 bash-completion curl rsync pass
		sudo pacman -Syu --noconfirm pkg-config openssl # for starship
		;;
	apt)
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2 bash-completion curl rsync pass
		sudo apt-get -y install pkg-config libssl-dev # for starship
		;;
	dnf)
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2 bash-completion curl rsync pass
		sudo dnf -y install pkg-config openssl-devel # for starship
		;;
	zypper)
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm bash-completion curl rsync pass
		sudo zypper -y install pkg-config openssl-devel # for starship
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

install.vscode() {
	local pkgmngr="$1"

	core.print_info 'Installing VSCode and VSCode Insiders'

	case $pkgmngr in
	pacman)
		yay -S visual-studio-code-bin visual-studio-code-insiders-bin
		;;
	apt)
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > './packages.microsoft.gpg'
		sudo install -o root -g root -m 644 './packages.microsoft.gpg' '/etc/apt/trusted.gpg.d'
		rm -f './packages.microsoft.gpg'
		printf '%s\n' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
			| sudo tee '/etc/apt/sources.list.d/vscode.list'

		sudo apt-get -y update
		sudo apt-get -y install code code-insiders
		;;
	dnf)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
			| sudo tee '/etc/yum.repos.d/vscode.repo'

		sudo dnf check-update
		sudo dnf -y install code code-insiders
		;;
	zypper)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee '/etc/zypp/repos.d/vscode.repo'

		sudo zypper refresh
		sudo zypper -y install code code-insiders
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

install.brave() {
	local pkgmngr="$1"

	core.print_info 'Installing Brave and Brave Beta'

	case $pkgmngr in
	pacman)
		yay -S brave-browser brave-browser-beta
		;;
	apt)
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-release.list'
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-beta.list'

		sudo apt-get -y update
		sudo apt-get -y install brave-browser brave-browser-beta
		;;
	dnf)
		sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo dnf config-manager --add-repo https://brave-browser-rpm-beta.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

		dnf check-update
		sudo dnf -y install brave-browser brave-browser-beta
		;;
	zypper)
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo zypper -y addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
		sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

		sudo zypper refresh
		sudo zypper -y install brave-browser brave-browser-beta
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

