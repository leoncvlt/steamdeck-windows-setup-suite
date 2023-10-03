Import-Module -Name ("$PSScriptRoot\Install-DownloadPackage.psm1")
function Install-WingetPackage {
    Param (
        [String]$PackageId
    )

    $Winget = "$($env:USERPROFILE)\AppData\Local\Microsoft\WindowsApps\winget.exe"
    if (-not (Test-Path -Path $Winget -PathType Leaf)) {
        Install-DownloadPackage -Path "https://api.github.com/repos/microsoft/winget-cli/releases/latest" -Match ".msixbundle"
    }

    $AlreadyInstalled = $false
    foreach ($line in (Invoke-Expression "$winget list")) {
        if ($line -like "*$PackageId*") {
            $AlreadyInstalled = $true
            break
        }
    }
    if (-not $AlreadyInstalled) {
        Write-Host "Installing $PackageID"
        Invoke-Expression "$winget install --accept-package-agreements --accept-source-agreements -h -e --id $PackageId --force"
    }
}