if ($MyInvocation.InvocationName -ne '.' -and $MyInvocation.Line -ne ''
) {
	[Console]::Error.WriteLine("This script should only be sourced.")
	exit 1
}

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
	Write-Host "Windows versions under 10 is not supported"
	return 1
}
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Scoop-Package([string]$command) {
	scoop info "$command" >$null
	if ($?) {
		util.log "Already installed $command"
	}
	else {
		util.log "Installing $command"

		scoop install "$command"

		scoop info "$command" >$null
		if (!($?)) {
			util.die "Automatic installation of $command failed"
		}
	}
}

function Ensure-Winget-Package([string]$package) {
	winget list --query "$package" >$null
	if ($?) {
		Write-Output "Already installed $package..."
	} else {
		Write-Output "Installing $package..."
		winget install --id "$package" --source winget
	}
}

function In-VirtualBox() {
	$name1 = Get-CimInstance -ClassName Win32_BIOS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Name'
	$name2 = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty 'Model'
	
	return $name1 -eq 'VirtualBox' -or $name2 -eq 'VirtualBox'
}

function Get-YesNoResponse {
    param(
        [string]$Prompt = "Do you want to continue? (y/n)"
    )

    while ($true) {
        Write-Host "$Prompt " -NoNewline
        $key = [Console]::ReadKey()

        $char = $key.KeyChar.ToString().ToLower()
		Write-Host
        if ($char -eq 'y') {
            return $true
        } elseif ($char -eq 'n') {
            return $false
        } else {
            Write-Host "Please enter 'y' for Yes or 'n' for No."
        }
    }
}


function util.die([string]$message) {
	util.error "$message"
	[Console]::Error.WriteLine("=> Exiting")
	exit 1
}

function util.error([string]$message) {
	[Console]::Error.WriteLine("=> Error: $message")
}

function util.log([string]$message) {
	Write-Output "=> Info: $message"
}
