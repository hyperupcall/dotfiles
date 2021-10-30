$env:Path += ";$HOME\.dots\windows\bootstrap\dots-bootstrap"

$PSReadLineOptions = @{
    CompletionQueryItems = 250
    EditMode = 'Emacs'
    HistoryNoDuplicates = $false
    HistorySaveStyle = 'SaveAtExit'
    HistorySearchCursorMovesToEnd = $false
    MaximumKillRingCount = 15
    # ShowToolTips = $true
}
Set-PSReadLineOption @PSReadLineOptions

$splat = @{
    Key = 'Alt+h'
    BriefDescription = 'ShowHelpMenu'
    LongDescription = "Pass '--help' to the program in the buffer"
    ScriptBlock = {
        param($key, $arg)

        Write-Host 'Not implemented'

        # $line = $null
        # $cursor = $null
        # [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        
        # echo 'so done'
        # $cmd = $null
        # $pos = $line.IndexOf(' ')
        # echo 'RESULT' $pos
        # if ($pos.Length -lt 0) {
        #     if (Get-Command "$line" -ErrorAction SilentlyContinue) {
        #         $cmd = "$line"
        #     }
        # } else {
        #     $cmd = $line.Substring(0, $pos)
        # }
        
        # if (!$cmd) {
        #     & "$cmd" --help
        # }

        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    }
}
Set-PSReadLineKeyHandler @splat


$splat = @{
    Key = 'Alt+m'
    BriefDescription = 'ShowManPage'
    LongDescription = 'Gathers the manual for the program in the buffer'
    ScriptBlock = {
        param($key, $arg)

        Write-Host 'Not implemented'

        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    }
}

if ($env:WT_SESSION) { 
    Invoke-Expression (&starship init powershell)
} else {
    # nope
}


# Import-Module PSReadLine
#Set-PSReadlineKeyHandler -Key ctrl+p -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key ctrl+n -Function HistorySearchForward
#Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    $name = [System.IO.Path]::GetRandomFileName()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

function mkt() {
    # $randomfile = [System.IO.Path]::GetRandomFileName()
    # Out-File "$randomFile"

    $file = New-TemporaryFile
    Remove-Item "$file" | Out-Null
    New-Item -ItemType Directory "$file-dir" | Out-Null
    Set-Location "$file-dir" | Out-Null

    # $tempFolderPath = Join-Path $Env:Temp $(New-Guid)
    # New-Item -Type Directory -Path $tempFolderPath | Out-Null
}

Set-Alias -Name alias -Value Set-Alias
Set-Alias -Name g -Value git

function gclone {
    git clone @args
}

function ginit {
    git init @args
}

function lsblk() {
    Get-Disk | ForEach-Object { Get-Partition -DiskNumber $($_.Number) }
}

function l {
    Get-ChildItem @args
}

function source {
    . @args
}
function sop() {
    . "$profile"
}

function cmdv([string]$Name) {
    $(Get-Command "$Name").Source
}
function Relaunch-Admin {
    Start-Process -Verb RunAs (Get-Process -Id $PID).Path
}
Set-Alias sudobash Relaunch-Admin
Set-Alias asadmin Relaunch-Admin
Set-Alias psadmin Relaunch-Admin

Set-Alias -Name geth -Value Get-Help

Set-Alias -Name reboot -Value Restart-Computer
# With-Env GIT_TRACE=1 git commit -vv --allow-empty --message 'four'
function With-Env {
    $ori = @{}
    Try {
    $i = 0

    # Loading .env files
    if(Test-Path $args[0]) {
        foreach($line in (Get-Content $args[0])) {
        if($line -Match '^\s*$' -Or $line -Match '^#') {
            continue
        }

        $key, $val = $line.Split("=")
        $ori[$key] = if(Test-Path Env:\$key) { (Get-Item Env:\$key).Value } else { "" }
        New-Item -Name $key -Value $val -ItemType Variable -Path Env: -Force > $null
        }

        $i++
    }

    while(1) {
        if($i -ge $args.length) {
        exit
        }

        if(!($args[$i] -Match '^[^ ]+=[^ ]+$')) {
        break
        }

        $key, $val = $args[$i].Split("=")
        $ori[$key] = if(Test-Path Env:\$key) { (Get-Item Env:\$key).Value } else { "" }
        New-Item -Name $key -Value $val -ItemType Variable -Path Env: -Force > $null

        $i++
    }


    Invoke-Expression ($args[$i..$args.length] -Join " ")
    } Finally {
    foreach($key in $ori.Keys) {
        New-Item -Name $key -Value $ori.Item($key) -ItemType Variable -Path Env: -Force > $null
    }
    }
}