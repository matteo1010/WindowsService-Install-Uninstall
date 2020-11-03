param (
    [Parameter(Mandatory = $true)][string]$ServiceRootPath,
    [Parameter(Mandatory = $true)][string]$ServiceExecutableName,
    [Parameter(Mandatory = $true)][string]$ServiceName,
    [Parameter(Mandatory = $true)][string]$ServiceDescription,
    [Parameter(Mandatory = $true)][string]$ServiceDisplayName
)

. "$PSScriptRoot\Utils\Utility.ps1"

#create final path
$ServiceFullPath = Join-Path -Path $ServiceRootPath -ChildPath $ServiceExecutableName

Write-Output "Setup $ServiceFullPath"

#Create and start service
New-Service -Name $ServiceName -BinaryPathName $ServiceFullPath -Description $ServiceDescription -DisplayName $ServiceDisplayName
Set-Service -Name $ServiceName -StartupType Automatic
Start-Service -Name $ServiceName

#make check of setup
if (Find-WindowsService $ServiceName) {
    Write-Host -ForegroundColor Green "Setup $ServiceName end"
}

exit 0;