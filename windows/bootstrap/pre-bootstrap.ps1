Set-StrictMode -Version Latest

# if (Test-path -Path "$HOME/.bootstrap") {
#     Write-Error "Error: File or directory '$HOME/.bootstrap' already exists"
#     exit 1
# }
# New-Item -Type Directory ~/.bootstrap >$null

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output 'Installing scoop'

    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}


if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output 'Installing git'

   scoop install git
}

if (Test-Path -Path "$HOME/.dots") {
    Write-Error "Error: Path '$HOME/.dots' exists"
    exit 1
} else {
    git clone 'https://github.com/hyperupcall/.dots' "$HOME/.dots"
}


Write-Host @"
Done. Now:
"$$HOME/.dots/windows/deploy.ps1"
"@