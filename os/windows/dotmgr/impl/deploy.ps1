$dotdir = "$HOME\.dotfiles\os\windows\user"

foreach ($relPath in @(
	'.config\git\attributes',
	'.config\git\config',
	'Documents\PowerShell\Microsoft.PowerShell_profile.ps1',
	'Documents\PowerShell\Modules\Dotfox',
	'Documents\PowerShell\Modules\Dotmgr',
	'Documents\PowerShell\Modules\Dots',
	'Documents\WindowsPowershell\Microsoft.PowerShell_profile.ps1'
	'AppData\Roaming\gnupg\gpg-agent.conf'
)) {
	Write-Host "symlink|$dotdir\${relpath}|$HOME\${relPath}"
}
