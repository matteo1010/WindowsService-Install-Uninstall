param (
    [Parameter(Mandatory = $true)][string]$ServiceExecutableName
)

. "$PSScriptRoot\Utils\Utility.ps1"

Write-Output "Stop $ServiceExecutableName"

if ((Find-WindowsService $ServiceExecutableName)) {
    Stop-Service -Name $ServiceExecutableName
    
    Watch-WsStopped $ServiceExecutableName

    if ($PSVersionTable.PSVersion.Major -gt 5) {
        Remove-Service -$ServiceExecutableName 
    }
    else {
        sc.exe delete $ServiceExecutableName
    }

    Watch-WsStopped $ServiceExecutableName

    Write-Host "$ServiceExecutableName deleted"
}

exit 0;