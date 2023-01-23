#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Use-BMain() {
	New-Item -ItemType Directory -Force "$HOME/.bootstrap" >$null

	# Install essential commands
	Use-BInstallUpdates
	if (Use-BIsCmd scoop) {
		Use-BLog 'Already installed Scoop'
	}
	else {
		Use-BLog 'Installing Scoop'

		Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
		Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
	}
	Use-BInstallCmd 'sudo'
	Use-BInstallCmd 'git'
	Use-BInstallCmd 'neovim'

	# Install Cargo, Rust
	Use-BInstallCmd 'rust'

	# Install hyperupcall/dotfiles
	Use-BCloneRepo 'https://github.com/hyperupcall/dotfiles' "$HOME/.dotfiles"
	Push-Location ~/.dotfiles
		git remote set-url origin 'git@github.com:hyperupcall/dotfiles'
	Pop-Location

	# Install hyperupcall/dotmgr
	Use-BCloneRepo 'github.com/hyperupcall/dotmgr' "$HOME/.dotfiles/.data/dotmgr-src"
	Push-Location ~/.dotfiles/.data/dotmgr-src
		git remote set-url origin 'git@github.com:hyperupcall/dotmgr'
		cargo build
		if (!($?)) {
			Use-BDie 'Failed to build dotmgr'
		}
	Pop-Location
	New-Item -Type Directory -Force -Path ~/.dotfiles/.data/bin >$null
	New-Item -Type SymbolicLink -Force -Path ~/.dotfiles/.data/bin/dotmgr.exe -Value "$HOME/.dotfiles/.data/dotmgr-src/target/debug/dotmgr.exe" >$null

	# Export variables
	Write-Output @"
`$Env:NAME = 'Edwin Kofler'
`$Env:EMAIL = 'edwin@kofler.dev'
`$Env:EDITOR = 'nvim'
`$Env:VISUAL = "`$Env:EDITOR"
`$Env:Path = "`$HOME/.dotfiles/.data/bin;`$Env:Path"
"@ | Out-File -FilePath ~/.bootstrap/bootstrap-out.ps1

	# Next Steps
	Write-Host @"
---
. "`$HOME/.bootstrap/init.ps1"
dotfox -Subcommand deploy
---
"@
}

function Use-BDie([string]$message) {
	Use-BError "$message"
	[Console]::Error.WriteLine("=> Exiting")
	exit 1
}

function Use-BError([string]$message) {
	[Console]::Error.WriteLine("=> Error: $message")
}

function Use-BLog([string]$message) {
	Write-Output "=> Info: $message"
}

function Use-BIsCmd([string]$command) {
	Get-Command "$command" -ErrorAction SilentlyContinue
}

function Use-BInstallUpdates() {
	scoop update
}

function Use-BInstallCmd([string]$command) {
	scoop info "$command" >$null
	if ($?) {
		Use-BLog "Already installed $command"
	}
	else {
		Use-BLog "Installing $command"

		scoop install "$command"

		scoop info "$command" >$null
		if (!($?)) {
			Use-BDie "Automatic installation of $command failed"
		}
	}
}

function Use-BCloneRepo([string]$uri, [string]$directory) {
	if (Test-Path -Path $directory) {
		Use-BLog "Already cloned $uri"
	}
	else {
		Use-BLog "Cloning $uri"
		git clone --quiet "https://$uri" "$directory"
	}
}

# -------------------------------------------------------- #
#                           START                          #
# -------------------------------------------------------- #

Use-BMain
