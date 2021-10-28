#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ErrorView = 'ConciseView'

$__dirname = Split-Path -Parent "$PSCommandPath"

. "$__dirname/util/util.ps1"
. "$__dirname/subcommands/deploy.ps1"

