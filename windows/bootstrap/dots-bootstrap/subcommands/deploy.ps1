$__dirname = Split-Path -Parent "$PSCommandPath"

# Write-Output 'Installing a newer PowerShellGet'
# sudo Install-PackageProvider -Name NuGet -Force

# Install-Module -Name PowerShellGet -Force

# Install-Module PSReadLine -AllowPrerelease -Force

# foreach($relativePath in @(
#     '.config/git/attributes'
#     '.config/git/ignore'
#     '.config/git/templates/commit'
#     '.config/git/include/alias.conf'
#     '.config/git/include/url.conf'

# )) {
#     $src = "$HOME/.dots/user/$relativePath"
#     $dest = "$HOME/.dots/windows/user/$relativePath"

#     Copy-Item -Path "$src" -Destination "$dest"
# }

foreach($relativePath in @(
    '.config/git/attributes',
    '.config/git/config',
    'Documents/PowerShell/Microsoft.PowerShell_profile.ps1',
    'Documents/WindowsPowershell/Microsoft.PowerShell_profile.ps1'
)) {
    [void](Symlink-Relative-Path -RelativePath "$relativePath")
}


exit

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
    Write-Host "Windows versions under 7 is not supported"
    exit 1
}

# PowerToys
Ensure-ScoopBucket -Name extras
Ensure-ScoopBucket -Name nerd-fonts

# nim
# from gow:  'grep' 'less' 'curl'
$collection = @('sudo', 'git', 'delta', 'neovim', 'sed', 'touch', 'aria2', 'gopass', 'starship', 'gow')
foreach ($item in $collection) {
    Ensure-ScoopPackage -Name "$item"
}

$languages = @('perl', 'go', 'nodejs', 'python', 'php', 'erlang', 'ruby', 'r', 'nasm', 'rust')
foreach ($language in $languages) {
    Ensure-ScoopPackage -Name "$language"
}

# powertoys, gpg4win-portable, autohotkey
# delta requires recent version of 'less'
$apps = @('vscodium', 'alacritty', 'kitty', 'discord', 'notepadplusplus', 'sublime-text')
foreach ($app in $apps) {
    Ensure-ScoopPackage -Name "$app"
}
# $ENV:PATH="$HOME\scoop\apps\python\current\Scripts:$ENV:PATH"

# sudo New-Item -Type SymbolicLink -Path ~ -Name .ssh -Value G:\storage_other\ssh\
# 'C:\Users\Edwin\scoop\apps\sublime-text\current\install-context.reg'"
# "C:\Users\Edwin\scoop\apps\python\current\install-pep-514.reg"

Write-Host 'nim, powertoys, gpg4win-portable, autohotkey dont really work'

[Environment]::SetEnvironmentVariable('PASSWORD_STORE_DIR', "G:\bridge\password-store", [System.EnvironmentVariableTarget]::User)


Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/dotnet/cli/master/scripts/obtain/dotnet-install.ps1')

# sudo Install-Module -Name PackageManagement

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

# # Ensure is admin
# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
#     Write-Error "Not Administrator"
#     exit 1
# }

