function Dotfox {
	[CmdletBinding(DefaultParameterSetName = 'Symlink')]
	param (
		# Subcommand to run
		[Parameter(ParameterSetName = 'Symlink', Position = 0)]
		[ValidateSet('deploy')]
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

	if ([string]::IsNullOrEmpty($Subcommand)) {
		$Subcommand = 'deploy'
	}

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

function command-deploy() {
	foreach ($relativePath in @(
			'.config/git/attributes',
			'.config/git/config',
			'Documents/PowerShell/Microsoft.PowerShell_profile.ps1',
			'Documents/PowerShell/Modules/Dotfox',
			'Documents/PowerShell/Modules/Dotmgr',
			'Documents/PowerShell/Modules/Dots',
			'Documents/WindowsPowershell/Microsoft.PowerShell_profile.ps1'
			'AppData/Roaming/gnupg/gpg-agent.conf'
		)) {
		[void](Symlink-RelativePath -RelativePath "$relativePath")
	}
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
	$targetFile = Join-Path -Path "$HOME/.dotfiles/os/unix/user-windows" -ChildPath "$relativePath"

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
