#Requires -Version 5.1
. ~/.dotfiles/os-windows/data/source.ps1

function main {
	# Ensure developer mode is enabled.
	$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
	if (!(Test-Path -Path $RegistryKeyPath)) {
	    Write-Host "Creating registry directory"
	    gsudo New-Item -Path $RegistryKeyPath -ItemType Directory -Force
	}
	if(!(Test-RegistryKeyValue -Path "$RegistryKeyPath" -Name 'AllowDevelopmentWithoutDevLicense')) {
	    Write-Host "Enabling developer mode"
	    gsudo New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
	}

	# Ensure current user is admin.
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
	    Write-Error "Not Administrator"
	    exit 1
	}

	Ensure-Scoop-Package 'gsudo'
	Import-Module gsudoModule
	gsudo config CacheMode auto
	gsudo Checkpoint-Computer -Description 'Clean Install' -RestorePointType 'MODIFY_SETTINGS'

	scoop config aria2-warning-enabled false
	scoop install vcredist2022 # For starship
	scoop uninstall vcredist2022
	Ensure-Scoop-Package 'cmder'
	Ensure-Scoop-Package 'sublime-text'
	Ensure-Scoop-Package 'kitty'
	Ensure-Scoop-Package 'aria2'
	Ensure-Scoop-Package 'gopass'
	Ensure-Scoop-Package 'starship'
	Ensure-Winget-Package 'Microsoft.PowerShell'
	Ensure-Winget-Package 'Microsoft.VisualStudioCode'
	Ensure-Winget-Package 'Microsoft.PowerToys'
	Ensure-Winget-Package 'Rustlang.Rustup'
	Ensure-Winget-Package 'Neovim.Neovim'
	Ensure-Winget-Package 'PuTTY.PuTTY'
	Ensure-Winget-Package 'Neovide.Neovide'
	Ensure-Winget-Package 'VideoLAN.VLC'
	Ensure-Winget-Package 'VSCodium.VSCodium'
	Ensure-Winget-Package 'Alacritty.Alacritty'
	Ensure-Winget-Package 'FreeCAD.FreeCAD'
	Ensure-Winget-Package 'GnuPG.Gpg4win'
	
	In-VirtualBox
	if (!$?) {
		Write-Host "Would you like to install WSL2?"
		if ($value = Get-YesNoResponse) {
			Write-Host "Installing WSL2..."
			Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
		}
	}

	Assert-ScoopBucket -Name extras
	Assert-ScoopBucket -Name versions
	Assert-ScoopBucket -Name nerd-fonts
	Assert-ScoopBucket -Name php
	Assert-ScoopBucket -Name java

	
	Install-Module Microsoft.PowerShell.PSResourceGet -Repository PSGallery

	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
	iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

	choco install -y Boxstarter
	Set-WindowsExplorerOptions -EnableShowFileExtensions

	Write-Host 'Done.'

}

function Symlink-RelativePath {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$RelativePath,

		[switch]
		$Dry
	)

	$symlinkFile = Join-Path -Path "$HOME" -ChildPath "$relativePath"
	$targetFile = Join-Path -Path "$HOME/.dotfiles/os-windows/user" -ChildPath "$relativePath"

	# Symlink file must either not exist or be a symlink link. With the original dotfox code, this
	# is handled in a more elegant way, but here we just fail. Not worth the trouble for Windows
	if ((Test-Path -Path "$symlinkFile") -and ((Get-Item "$symlinkFile").LinkType -ne 'SymbolicLink')) {
		Write-Error "Path '$symlinkFile' already exists and it is not a symlink"
		return 1
	}

	# The target file must exist
	if (!(Test-Path -Path "$targetFile")) {
		Write-Error "Path '$targetFile' does not exist, but it is expected to"
		return 1
	}

	# Create parent directory of symlink
	$symlinkFileParent = Split-Path -Path "$symlinkFile" -Parent
	if (!(Test-Path -Path "$symlinkFileParent")) {
		New-Item -Type Directory "$symlinkFileParent" >$null
	}

	if ($Dry) {
		Write-Host "Would have symlinked '$symlinkFile' -> '$targetFile'"
	}
 else {
		Write-Host "Symlinking '$symlinkFile' -> '$targetFile'"
		New-Item -ItemType SymbolicLink -Force -Path "$(Split-Path $symlinkFile -Parent)" -Name "$(Split-Path $symlinkFile -Leaf)" -Target "$targetFile"
	}

	return 0
}

function Assert-ScoopBucket {
	[CmdletBinding()]
	Param (
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]
		$Name
	)

	$bucketPath = Join-Path -Path "$HOME/scoop/buckets" -ChildPath "$Name"
	if (!(Test-Path "$bucketPath")) {
		scoop bucket add "$Name"
	}
}

function Assert-ScoopPackage {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("[a-z]+")]
		[String]
		$Name
	)

	$appDir = Join-Path -Path "$HOME/scoop/apps" -ChildPath "$Name"
	if (Test-Path "$appDir") {
		scoop update "$Name"
	}
 else {
		scoop install "$Name"
	}
}

function Test-RegistryKeyValue {

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string]
		# The path to the registry key where the value should be set.  Will be created if it doesn't exist.
		$Path,

		[Parameter(Mandatory = $true)]
		[string]
		# The name of the value being set.
		$Name
	)

	if (!(Test-Path -Path $Path -PathType Container)) {
		return $false
	}

	$properties = Get-ItemProperty -Path $Path
	if (!$properties) {
		return $false
	}

	if (!(Get-Member -InputObject $properties -Name $Name)) {
		return $false
	}

	return $true
}

foreach ($relativePath in @(
		'.config/git/attributes',
		'.config/git/config',
		'Documents/PowerShell/Microsoft.PowerShell_profile.ps1',
		'Documents/PowerShell/Modules/Dots',
		'Documents/WindowsPowershell/Microsoft.PowerShell_profile.ps1'
		'AppData/Roaming/gnupg/gpg-agent.conf'
	)) {
	[void](Symlink-RelativePath -RelativePath "$relativePath")
}

main