function Wait-For-Delete {
    param(
        [Parameter(Mandatory = $true)][string]$ServiceExecutableName,
        [int]$maxRepeat = 10
    )
    Write-Host "Wait-For-Delete"
    do {
        $maxRepeat--
        Start-Sleep -Milliseconds 500  
        $res = Find-WindowsService $ServiceExecutableName;
    } until ($res -eq $false)
}

function Find-WindowsService {
    param(
        [string]$ServiceExecutableName
    )
    If (Get-Service $ServiceExecutableName -ErrorAction SilentlyContinue) {
        Write-Host "$ServiceExecutableName found"
        return $true    
    }
    Else {
        Write-Host "$ServiceExecutableName not found"  
        return $false  
    }
}

function Watch-WsStopped {
    param(
        [Parameter(Mandatory = $true)][string]$ServiceExecutableName,
        [int]$maxRepeat = 10
    )
    $status = "Stopped"
    do {
        $count = 0;
        if ((Find-WindowsService $ServiceExecutableName)) {
            Write-Host "CheckForStopped"
            $count = (Get-Service $ServiceExecutableName | Where-Object { $_.status -eq $status }).count
            $maxRepeat--
            Start-Sleep -Milliseconds 500  
        }
        else {
            $count = 1
        }
    } until ($count -eq 1 -or $maxRepeat -eq 0)
}