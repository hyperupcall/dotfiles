<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Ensure-ScoopBucket {
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1',
                   SupportsShouldProcess=$true,
                   PositionalBinding=$false,
                   HelpUri = 'http://www.microsoft.com/',
                   ConfirmImpact='Medium')]
    [OutputType([int])]
    Param (
        [Parameter(ParameterSetName='Parameter Set 1')]
        [ValidatePattern("[a-z]*")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    
    begin {
    }
    
    process {
        if ($pscmdlet.ShouldProcess("Target", "Operation")) {
            $bucketPath = Join-Path -Path "$HOME/scoop/buckets" -ChildPath "$Name"
            if (!(Test-Path "$bucketPath")) {
                scoop bucket add extras
            }
        }
    }
    
    end {
    }
}

<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Ensure-ScoopPackage {
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1',
                   SupportsShouldProcess=$true,
                   PositionalBinding=$false,
                   HelpUri = 'http://www.microsoft.com/',
                   ConfirmImpact='Medium')]
    [OutputType([int])]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("[a-z]+")]
        [String]
        $Name
    )
    
    begin {
    }
    
    process {
        if ($pscmdlet.ShouldProcess("Target", "Operation")) {
            $appDir = Join-Path -Path "$HOME/scoop/apps" -ChildPath "$Name"
            if (Test-Path "$appDir") {
                scoop update "$Name"
            } else {
                scoop install "$Name"
            }
        }
    }
    
    end {
    }
}

function Symlink-Relative-Path {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RelativePath
    )

    $symlinkFile = Join-Path -Path "$HOME" -ChildPath "$relativePath"
    $targetFile = Join-Path -Path "$HOME/.dots/windows/user" -ChildPath "$relativePath"
    
    # Symlink file must either be a symlink or not exist
    if (Test-Path -Path "$symlinkFile") {
        # If the path already exists, it must be a symbolic link
        if ((Get-Item "$symlinkFile").LinkType -eq 'SymbolicLink') {
            return 0
        } else {
            Write-Error "Path '$symlinkFile' already exists and it is not a symlink"
            exit 1
        }
    }
    
    # Target file must exist
    if (!(Test-Path -Path "$targetFile")) {
        Write-Error "Path '$targetFile' does not exist, but it is expected to"
        exit 1
    }
    
    # Create parent directory of symlink
    $symlinkFileParent = Split-Path -Path $symlinkFile -Parent
    if (!(Test-Path -Path "$symlinkFileParent")) {
        New-Item -Type Directory "$symlinkFileParent" >$null
    }
    
    # Create symlink
    New-Item -ItemType SymbolicLink -Path (Split-Path $symlinkFile -Parent) -Name (Split-Path $symlinkFile -Leaf) -Target $targetFile
    
    return 0
}

function Test-RegistryKeyValue {
    <#
    .SYNOPSIS
    Tests if a registry value exists.

    .DESCRIPTION
    The usual ways for checking if a registry value exists don't handle when a value simply has an empty or null value.  This function actually checks if a key has a value with a given name.

    .EXAMPLE
    Test-RegistryKeyValue -Path 'hklm:\Software\Carbon\Test' -Name 'Title'

    Returns `True` if `hklm:\Software\Carbon\Test` contains a value named 'Title'.  `False` otherwise.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
        $Path,

        [Parameter(Mandatory=$true)]
        [string]
        # The name of the value being set.
        $Name
    )

    if(!(Test-Path -Path $Path -PathType Container)) {
        return $false
    }

    $properties = Get-ItemProperty -Path $Path 
    if(!$properties) {
        return $false
    }
 
    if(!(Get-Member -InputObject $properties -Name $Name)) {
        return $false
    }
    
    return $true
}
