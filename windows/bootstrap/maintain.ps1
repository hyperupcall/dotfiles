Set-StrictMode -Version Latest

# Write-Output 'Installing a newer PowerShellGet'
# sudo Install-PackageProvider -Name NuGet -Force

# Install-Module -Name PowerShellGet -Force

# Install-Module PSReadLine -AllowPrerelease -Force

function Scoop-Install-Or-Upgrade {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $ProgramName
    )

    if (!$ProgramName) {
        Write-Error "Program name cannot be empty"
        exit 1
    }

    if (scoop info $ProgramName) {
        scoop update $ProgramName
    } else {
        scoop install $ProgramName
    }
}

scoop bucket add extras

# delta requires recent version of 'less'
$packages = @('sudo', 'git', 'delta', 'neovim', 'less', 'gpg4win-portable', 'alacritty', 'kitty', 'autohotkey')
foreach ($package in $packages) {
    Scoop-Install-Or-Upgrade $package
}
Remove-Variable $package