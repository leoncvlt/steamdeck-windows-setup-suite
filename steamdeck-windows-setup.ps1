$global:ProgressPreference = "SilentlyContinue"
$global:ErrorActionPreference = "SilentlyContinue"

Import-Module -Name ("$PSScriptRoot\scripts\libs\Show-SelectionMenu.psm1")
Import-Module -Name ("$PSScriptRoot\scripts\libs\Get-LatestGithubRelease.psm1")
Import-Module -Name ("$PSScriptRoot\scripts\libs\Install-DownloadPackage.psm1")
Import-Module -Name ("$PSScriptRoot\scripts\libs\Install-WingetPackage.psm1")
Import-Module -Name ("$PSScriptRoot\scripts\libs\Remove-UWPApp.psm1")

function Invoke-Script {
    param ( [String]$Name )
    Invoke-Expression "& `"$PSScriptRoot\scripts\$name.ps1`""
}

Write-Host "[ Steam Deck Windows Setup Suite ]" -BackgroundColor DarkBlue
Write-Host "Press UP/DOWN to select, RIGHT to toggle, ENTER/A to confirm" -ForegroundColor DarkGray
$Options = @(
    "Activate Windows",
    "Install Pending Updates", 
    "Install Drivers", 
    "Install Redistributables",
    "Install Steam Deck Tools",
    "Remove UWP Apps",
    "Remove OneDrive",
    "Apply Tweaks",
    "Reboot"
)
$Choices = Show-SelectionMenu $Options -Multiselect

if ($Choices.Count -eq 0) {
    exit
}

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
if (-not $IsAdmin) {
    Write-Warning "This script requires administrative privileges. Please run it as an administrator."
    exit
}

# Disable UAC
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

if (($Choices -contains "Install Redistributables") -or ($Choices -contains "Install Steam Deck Tools")) {
    # Update WinGet
    $WingetRelease = Get-LatestGithubRelease -Repo "microsoft/winget-cli" -Match ".msixbundle"
    Install-DownloadPackage -Path $WingetRelease
}

if ($Choices -contains "Activate Windows") {
    Write-Host "Activating Windows" -BackgroundColor Blue
    Invoke-Expression "& ([ScriptBlock]::Create((Invoke-RestMethod -Uri 'https://massgrave.dev/get'))) /KMS38"
}

if ($Choices -contains "Install Pending Updates") {
    Write-Host "Installing Pending Updates" -BackgroundColor Blue
    Find-PackageProvider -Name 'Nuget' -ForceBootstrap -IncludeDependencies
    Install-Module PSWindowsUpdate -Force -AllowClobber
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot -Verbose
}

if ($Choices -contains "Install Drivers") {
    Write-Host "Installing Drivers" -BackgroundColor Blue
    $Drivers = Get-Content -Raw -Path "$PSScriptRoot/data/drivers.json" | ConvertFrom-Json
    foreach ($Driver in $Drivers) {
        Write-Output "Installing $($Driver.Name)"
        Install-DownloadPackage -Path $Driver.Url -Target $Driver.Target
    }
}

if ($Choices -contains "Install Redistributables") {
    Write-Host "Installing Redistributables" -BackgroundColor Blue
    $Packages = Get-Content -Raw -Path "$PSScriptRoot/data/packages.json" | ConvertFrom-Json
    foreach ($PackageID in $Packages) {
        Install-WingetPackage $PackageID
    }
}

if ($Choices -contains "Install Steam Deck Tools") {
    Write-Host "Installing Steam Deck Tools" -BackgroundColor Blue
    Invoke-Script "install-steamdeck-tools";
}

if ($Choices -contains "Remove UWP Apps") {
    Write-Host "Removing UWP Apps" -BackgroundColor Blue
    $Apps = Get-Content -Raw -Path "$PSScriptRoot/data/bloat.json" | ConvertFrom-Json
    foreach ($App in $Apps) {
        Remove-UWPApp $App
    }
}

if ($Choices -contains "Remove OneDrive") {
    Write-Host "Removing OneDrive" -BackgroundColor Blue
    Invoke-Script "remove-onedrive";
}

if ($Choices -contains "Apply Tweaks") {
    Write-Host "Applying Tweaks" -BackgroundColor Blue
    Invoke-Script "apply-tweaks";
}

if ($Choices -contains "Reboot") {
    Write-Host "Rebooting" -BackgroundColor Blue
    timeout /t 10
    Restart-Computer -Force
}

pause