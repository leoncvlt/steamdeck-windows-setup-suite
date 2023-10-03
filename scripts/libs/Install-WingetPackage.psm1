function Install-WingetPackage {
    Param (
        [String]$PackageId
    )

    $Winget = "$($env:USERPROFILE)\AppData\Local\Microsoft\WindowsApps\winget.exe"
    if (Test-Path -Path $Winget -PathType Leaf) {
        Write-Host "Installing $PackageID"
        Invoke-Expression "$Winget install --accept-package-agreements --accept-source-agreements -h -e --id $PackageId --force"
    }
    else {
        Write-Warning "winget not installed"
    }
}