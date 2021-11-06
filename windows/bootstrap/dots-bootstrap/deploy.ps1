#Requires -Version 5.1
Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"
$ErrorView = 'ConciseView'

. "$HOME/.dots/windows/bootstrap/dots-bootstrap/deploy.util.ps1"

for ($i = 0; $i -lt $args.count; $i++) {
    if ("$($args[$i])" -eq '--help') {
        Write-Output @"
Usage:
  deploy.ps1 [--help] <subcommand>

Subcommands:
  symlink    Properly symlink all files
"@
    exit
    }
}

if ("$($args.Count)" -eq 0) {
    Write-Error "Must pass at least one argument. See '--help' for help"
    exit 1
}

# Common checks
if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
    Write-Host "Windows versions under 10 is not supported"
    exit 1
}

if ("$($args[0])" -eq 'symlink') {
    . "$HOME/.dots/windows/bootstrap/dots-bootstrap/subcommands/symlink.ps1"
} else {
    Write-Error "Subcommand not valid. See '--help' for help"
    exit 1
}

# TODO(windows): https://superuser.com/a/1096597
# same for disabling shake to minimize

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


