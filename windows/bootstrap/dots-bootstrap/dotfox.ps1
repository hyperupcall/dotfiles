#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ErrorView = 'ConciseView'

$__dirname = Split-Path -Parent "$PSCommandPath"

for ($i = 0; $i -lt $args.Count; $i++) {
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

if ($($args.Count) -eq 0) {
    Write-Error "Must pass at least one argument. See '--help' for help"
}
. "$__dirname/util/util.ps1"
. "$__dirname/subcommands/deploy.ps1"

