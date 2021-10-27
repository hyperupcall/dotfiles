#Requires -Version 5.1
Set-StrictMode -Version Latest

. "$HOME/.dots/windows/bootstrap/deploy.util.ps1"

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
    Write-Host "Windows versions under 7 is not supported"
    exit 1
}

# TODO(windows): https://superuser.com/a/1096597
# same for disabling shake to minimize

# Ensure devleoper mode is enabled
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (!(Test-Path -Path $RegistryKeyPath)) {
    Write-Host "Creating registry directory"
    sudo New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Enable developer mode
if(!(Test-RegistryKeyValue -Path "$RegistryKeyPath" -Name 'AllowDevelopmentWithoutDevLicense')) {
    Write-Host "Enabling developer mode"
    sudo New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
}

# Ensure is admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "Not Administrator"
    exit 1
}


# TODO: >$null
Symlink-Relative-Path -RelativePath '.config/git/config'
Symlink-Relative-Path -RelativePath '.config/git/ignore'
Symlink-Relative-Path -RelativePath '.config/git/templates/commit'
Symlink-Relative-Path -RelativePath 'Documents/WindowsPowershell/Microsoft.Powershell_profile.ps1'
