function Dotmgr() {
	[CmdletBinding(DefaultParameterSetName = 'Symlink')]
	param (
		# Subcommand to run
		[Parameter(ParameterSetName = 'Symlink', Mandatory = $true)]
		[ValidateSet('bootstrap-stage1', 'bootstrap', 'transfer')]
		[String]
		$Subcommand,

		# Print help
		[Parameter(ParameterSetName = 'Help')]
		[Switch]
		$Help
	)

	Set-StrictMode -Version Latest
	$ErrorActionPreference = 'Stop'
	$ErrorView = 'ConciseView'

	if ($Help) {
		Get-Help "$($MYINVOCATION.InvocationName)"
		return
	}

	if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
		Write-Host "Windows versions under 10 is not supported"
		return 1
	}

	& "command-$Subcommand"
}

function command-bootstrap-stage1() {
	winget install --id Microsoft.Powershell --source winget
}

function command-bootstrap() {
	$__dirname = Split-Path -Parent "$PSCommandPath"

	winget install --id GNUPG.Gpg4win --source winget
	winget install --id PuTTY.PuTTY --source winget
	winget install --id Microsoft.PowerToys --source winget

	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

	Ensure-ScoopBucket -Name extras
	Ensure-ScoopBucket -Name versions
	Ensure-ScoopBucket -Name php
	Ensure-ScoopBucket -Name nerd-fonts
	Ensure-ScoopBucket -Name java
	Ensure-ScoopBucket -Name games

	return
	Get-Content "$(Join-Path -Path "$__dirname" -ChildPath 'packages.conf')" | ForEach-Object {
		if (!$_) {
			return
		}

		if ($_.StartsWith("#")) {
			return
		}

		$octothorpIndex = $_.IndexOf('#')
		if ($octothorpIndex -lt 0) {
			$line = $_.Trim()
		}
		else {
			$line = $_.Substring(0, $octothorpIndex).Trim()
		}

		$package = "$line"
		Write-Host "line: $package"
		Ensure-ScoopPackage -Name "$package"
	}

	# $ENV:PATH="$HOME\scoop\apps\python\current\Scripts:$ENV:PATH"
	# 'C:\Users\Edwin\scoop\apps\sublime-text\current\install-context.reg'"
	# "C:\Users\Edwin\scoop\apps\python\current\install-pep-514.reg"

	# Checkpoint-Computer -Description 'Clean Install' -RestorePointType 'MODIFY_SETTINGS' # 5.1

	# Ensure devleoper mode is enabled
	# $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
	# if (!(Test-Path -Path $RegistryKeyPath)) {
	#     Write-Host "Creating registry directory"
	#     sudo New-Item -Path $RegistryKeyPath -ItemType Directory -Force
	# }

	# # Enable developer mode
	# if(!(Test-RegistryKeyValue -Path "$RegistryKeyPath" -Name 'AllowDevelopmentWithoutDevLicense')) {
	#     Write-Host "Enabling developer mode"
	#     sudo New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
	# }

	# Ensure is admin
	# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	# if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
	#     Write-Error "Not Administrator"
	#     exit 1
	# }
	# Write-Output 'Installing a newer PowerShellGet'
	# sudo Install-PackageProvider -Name NuGet -Force

	# Install-Module -Name PowerShellGet -Force
	# Install-Module -Name PSReadLine -AllowPrerelease -Force
	# sudo Install-Module -Name PackageManagement

	# Set-ExecutionPolicy Unrestricted -Scope CurrentUser

	# PowerToys
	if (!(Test-Path -Path "$env:APPDATA\git-boxstarter")) {
		git clone 'https://github.com/chocolatey/boxstarter' "$env:APPDATA\git-boxstarter"
	}

	# nim
	# sudo New-Item -Type SymbolicLink -Path ~ -Name .ssh -Value G:\storage_other\ssh\

	Write-Host 'nim, powertoys, gpg4win-portable, autohotkey dont really work'

	# for espanso?
	[Environment]::SetEnvironmentVariable('PASSWORD_STORE_DIR', "$env:USERPROFILE\Dropbox\password-store", [System.EnvironmentVariableTarget]::User)
	# [Environment]::SetEnvironmentVariable('VISUAL', "neovide", [System.EnvironmentVariableTarget]::User)
	# [Environment]::SetEnvironmentVariable('EDITOR', "neovide", [System.EnvironmentVariableTarget]::User)

	# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.HyperV\Boxstarter.HyperV.psd1" -Force
	# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.WinConfig\Boxstarter.WinConfig.psd1" -Force

	# Set-WindowsExplorerOptions ...
}

function command-transfer() {
	$ErrorActionPreference = 'Stop' # FIXME

	$driveLetter = Read-Host -Prompt "Drive letter?"

	$sshKeysFile = Join-Path -Path "${driveLetter}:\" -ChildPath "ssh-keys.tar.age"
	$gpgKeysFile = Join-Path -Path "${driveLetter}:\" -ChildPath "gpg-keys.tar.age"

	if (!(Test-Path "$sshKeysFile")) {
		Write-Host "SSH keyfile not found"
		return 1
	}

	if (!(Test-Path "$gpgKeysFile")) {
		Write-Host "GPG keyfile not found"
		return 1 # FIXME: does not translate to exit code of whole program; prints '1' to console
	}

	# ssh keys
	if ((Read-Host -Prompt "Copy ssh keys? (y/n)") -eq "y") {
		$sshTmp = Join-Path -Path "$HOME" -ChildPath ".ssh/tmp-ssh"
		age --decrypt --output "$sshTmp" "$sshKeysFile"
		if (!$?) {
			return 1
		}
		Set-Location -Path ~/.ssh
		tar -xmf "$sshTmp"
		if (!$?) {
			return 1
		}
		# Remove-Item -Force "$sshTmp"
	}

	# gpg keys
	if ((Read-Host -Prompt "Copy gpg keys? (y/n)") -eq "y") {
		$gpgTmp = Join-Path -Path "$HOME" -ChildPath ".ssh/tmp-gpg"
		age --decrypt --output "$gpgTmp" "$gpgKeysFile"
		if (!$?) {
			return 1
		}
		gpg --import "$gpgTmp"
		if (!$?) {
			return 1
		}
		Remove-Item -Force "$gpgTmp"
	}
}

function Ensure-ScoopBucket {
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

function Ensure-ScoopPackage {
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
