#Requires -Version 2.0


$hive = "HKEY_LOCAL_MACHINE"


$keyPath = "Software\Microsoft\WBEM\Scripting"


$valueName = "Default NameSpace"


# $gciPath = $keyPath -replace "\",""


$query = "Select * from RegistryValueChangeEvent where Hive='$hive' AND " +


         "KeyPath='$keyPath' AND ValueName='$ValueName'"


Register-WmiEvent -Query $query -SourceIdentifier KeyChanged


Wait-Event -SourceIdentifier KeyChanged


"New value for $valueName is " + (Get-ItemProperty -Path HKLM:$gciPath).$valueName