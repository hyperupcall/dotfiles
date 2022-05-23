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

action() {
	# -------------------------------------------------------- #
	#                          PACMAN                          #
	# -------------------------------------------------------- #
	if util.is_cmd 'pacman'; then
		core.print_info 'Updating, upgrading, and installing packages'
		sudo pacman -Syyu --noconfirm

		install.generic 'pacman'
		install.vscode 'pacman'
		install.brave 'pacman'
	# -------------------------------------------------------- #
	#                            APT                           #
	# -------------------------------------------------------- #
	elif util.is_cmd 'apt'; then
		core.print_info 'Updating, upgrading, and installing packages'
		sudo apt-get -y update && sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https

		install.generic 'apt'
		install.vscode 'apt'
		install.brave 'apt'
	# -------------------------------------------------------- #
	#                            DNF                           #
	# -------------------------------------------------------- #
	elif util.is_cmd 'dnf'; then
		core.print_info 'Updating, upgrading, and installing packages'
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave

		install.generic 'dnf'
		install.vscode 'dnf'
		install.brave 'dnf'
	# -------------------------------------------------------- #
	#                          ZYPPER                          #
	# -------------------------------------------------------- #
	elif util.is_cmd 'zypper'; then
		core.print_info 'Updating, upgrading, and installing packages'
		sudo zypper -y update && sudo zypper -y upgrade

		install.generic 'zypper'
		install.vscode 'zypper'
		install.brave 'zypper'
	fi

	# -------------------------------------------------------- #
	#                           CARGO                          #
	# -------------------------------------------------------- #
	dotmgr module rust
	if ! util.is_cmd 'starship'; then
		core.print_info 'Installing starship'
		cargo install starship
	fi

	# -------------------------------------------------------- #
	#                          BASALT                          #
	# -------------------------------------------------------- #
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

	# -------------------------------------------------------- #
	#                           WOOF                           #
	# -------------------------------------------------------- #
	core.print_info 'Instaling Woof packages globally'
	woof install gh latest
	woof install nodejs latest
	woof install deno latest
	woof install go latest
	woof install nim latest
	woof install zig latest

	# -------------------------------------------------------- #
	#                            NPM                           #
	# -------------------------------------------------------- #
	npm i -g yarn
	yarn global add pnpm
	yarn global add diff-so-fancy
	yarn global add npm-check-updates
	yarn global add graphqurl

	# -------------------------------------------------------- #
	#                            GO                            #
	# -------------------------------------------------------- #
	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/tools/cmd/godoc@latest

	go get github.com/motemen/gore/cmd/gore
	go get github.com/mdempsky/gocode
}

msg() {
	core.print_info "Running function '${FUNCNAME[1]}' with method $method"

	if [ "$1" = 'bad' ]; then
		core.print_die "Method '$method' not recognized"
	fi
}

install.generic() {
	local method="$1"

	case $method in
	pacman) msg
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2 bash-completion curl rsync pass
		sudo pacman -Syu --noconfirm pkg-config openssl # for starship
		;;
	apt) msg
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2 bash-completion curl rsync pass
		sudo apt-get -y install pkg-config libssl-dev # for starship
		;;
	dnf) msg
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2 bash-completion curl rsync pass
		sudo dnf -y install pkg-config openssl-devel # for starship
		;;
	zypper) msg
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm bash-completion curl rsync pass
		sudo zypper -y install pkg-config openssl-devel # for starship
		;;
	*)
		msg 'bad'
		;;
	esac
}

install.vscode() {
	local method="$1"

	case $method in
	pacman) msg
		yay -S visual-studio-code-bin
		;;
	apt) msg
		curl -fsSLo- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > './packages.microsoft.gpg'
		sudo install -o root -g root -m 644 './packages.microsoft.gpg' '/etc/apt/trusted.gpg.d'
		rm -f './packages.microsoft.gpg'
		printf '%s\n' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
			| sudo tee '/etc/apt/sources.list.d/vscode.list'

		sudo apt-get -y update
		sudo apt-get -y install code code-insiders
		;;
	dnf) msg
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
			| sudo tee '/etc/yum.repos.d/vscode.repo'

		sudo dnf check-update
		sudo dnf -y install code code-insiders
		;;
	zypper) msg
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee '/etc/zypp/repos.d/vscode.repo'

		sudo zypper refresh
		sudo zypper -y install code code-insiders
		;;
	*)
		msg 'bad'
		;;
	esac
}

install.brave() {
	local method="$1"

	case $method in
	pacman) msg
		yay -S brave-browser
		;;
	apt) msg
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-release.list'
		sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
		printf '%s\n' "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
			| sudo tee '/etc/apt/sources.list.d/brave-browser-beta.list'

		sudo apt-get -y update
		sudo apt-get -y install brave-browser brave-browser-beta
		;;
	dnf) msg
		sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo dnf config-manager --add-repo https://brave-browser-rpm-beta.s3.brave.com/x86_64/
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

		dnf check-update
		sudo dnf -y install brave-browser brave-browser-beta
		;;
	zypper) msg
		sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
		sudo zypper -y addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
		sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
		sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

		sudo zypper refresh
		sudo zypper -y install brave-browser brave-browser-beta
		;;
	*)
		msg 'bad'
		;;
	esac
}

