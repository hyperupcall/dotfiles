function Dotmgr() {
	[CmdletBinding(DefaultParameterSetName='Symlink')]
	param (
		# Subcommand to run
		[Parameter(ParameterSetName='Symlink', Mandatory=$true)]
		[ValidateSet('bootstrap')]
		[String]
		$Subcommand,

		# Print help
		[Parameter(ParameterSetName='Help')]
		[Switch]
		$Help
	)

	Set-StrictMode -Version Latest
	$ErrorActionPreference = 'Stop'
	$ErrorView = 'ConciseView'

	if($Help) {
		Get-Help "$($MYINVOCATION.InvocationName)"
		return
	}

	if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
		Write-Host "Windows versions under 10 is not supported"
		return 1
	}

	& "command-$Subcommand"
}

function command-bootstrap() {
	$__dirname = Split-Path -Parent "$PSCommandPath"

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
		} else {
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
	# [Environment]::SetEnvironmentVariable('PASSWORD_STORE_DIR', "G:\bridge\password-store", [System.EnvironmentVariableTarget]::User)
	# [Environment]::SetEnvironmentVariable('VISUAL', "neovide", [System.EnvironmentVariableTarget]::User)
	# [Environment]::SetEnvironmentVariable('EDITOR', "neovide", [System.EnvironmentVariableTarget]::User)

	# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.HyperV\Boxstarter.HyperV.psd1" -Force
	# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.WinConfig\Boxstarter.WinConfig.psd1" -Force

	# Set-WindowsExplorerOptions ...
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
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("[a-z]+")]
		[String]
		$Name
	)

	$appDir = Join-Path -Path "$HOME/scoop/apps" -ChildPath "$Name"
	if (Test-Path "$appDir") {
			scoop update "$Name"
	} else {
			scoop install "$Name"
	}
}

<#
.SYNOPSIS
Tests if a registry value exists.

.DESCRIPTION
The usual ways for checking if a registry value exists don't handle when a value simply has an empty or null value.  This function actually checks if a key has a value with a given name.

.EXAMPLE
Test-RegistryKeyValue -Path 'hklm:\Software\Carbon\Test' -Name 'Title'

Returns `True` if `hklm:\Software\Carbon\Test` contains a value named 'Title'.  `False` otherwise.
#>
function Test-RegistryKeyValue {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
        $Path,

        [Parameter(Mandatory=$true)]
        [string]
        # The name of the value being set.
        $Name
    )

    if(!(Test-Path -Path $Path -PathType Container)) {
        return $false
    }

    $properties = Get-ItemProperty -Path $Path
    if(!$properties) {
        return $false
    }

    if(!(Get-Member -InputObject $properties -Name $Name)) {
        return $false
    }

    return $true
}
