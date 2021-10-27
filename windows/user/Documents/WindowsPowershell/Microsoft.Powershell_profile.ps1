Set-PSReadlineOption -EditMode Emacs

# Import-Module PSReadLine
#Set-PSReadlineKeyHandler -Key ctrl+p -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key ctrl+n -Function HistorySearchForward
#Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit


function mkt() {
    $file = New-TemporaryFile
    Remove-Item $file | Out-Null
    New-Item -ItemType Directory "$file-dir" | Out-Null
    Set-Location "$file-dir" | Out-Null

    # $tempFolderPath = Join-Path $Env:Temp $(New-Guid)
    # New-Item -Type Directory -Path $tempFolderPath | Out-Null
}

function sop() {
    . $profile
}

# if (!(Test-Path alias:g)) {
if (Get-Alias -Name g) {
    Set-Alias g git
} else {
    New-Alias g git
}
