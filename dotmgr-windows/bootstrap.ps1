#Requires -Version 5.1

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
	Write-Output 'Installing scoop'

	Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

# Scoop does not like strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
	scoop install git
}

if (!(Test-Path -Path "$HOME/.dotfiles")) {
	git clone 'https://github.com/hyperupcall/dots' "$HOME/.dotfiles"
}

if (!(Test-Path -Path "$HOME/.bootstrap")) {
	New-Item -ItemType Directory "$HOME/.bootstrap" >$null
}

@'
Import-Module "$HOME/.dotfiles/windows/user/Documents/Powershell/Modules/Dotfox"
'@ | Out-File -FilePath "$HOME/.bootstrap/init.ps1"

Write-Host @"
---
. "`$HOME/.bootstrap/init.ps1"
dotfox -Subcommand deploy
---
"@
