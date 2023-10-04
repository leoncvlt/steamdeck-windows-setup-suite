Import-Module -Name ("$PSScriptRoot\libs\Install-DownloadPackage.psm1")
Import-Module -Name ("$PSScriptRoot\libs\Install-WingetPackage.psm1")

$Release = Get-LatestGithubRelease "ayufan/steam-deck-tools" -Match "portable.zip"
$TempFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.IO.Path]::GetFileName($Release))
Invoke-WebRequest -URI $Release -OutFile $TempFile
$ToolsPath = "$env:LOCALAPPDATA\Programs\SteamDeckTools" 
New-Item $ToolsPath -ItemType Directory | Out-Null
Expand-Archive $TempFile $ToolsPath -Force
Remove-Item $TempFile -Force

Install-WingetPackage "Guru3D.RTSS"
Install-WingetPackage "ViGEm.ViGEmBus"

$Tools = @(
    "FanControl"
    "PerformanceOverlay"
    "PowerControl"
    "SteamController"
)

Write-Host "Setting Steam Deck Tools to run on login"
foreach ($Tool in $Tools) {
    Start-Process -FilePath "$ToolsPath\$Tool.exe" -ArgumentList "-run-on-startup"
    $shell = New-Object -comObject WScript.Shell
    $shortcut = $shell.CreateShortcut("$Home\Desktop\$Tool.lnk")
    $shortcut.TargetPath = "$ToolsPath\$Tool.exe"
    $shortcut.Save()
}

Write-Host "Setting RivaTuner to run on login"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$action = New-ScheduledTaskAction -Execute "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe"
$description = "Start RivaTuner at Login"
Register-ScheduledTask -TaskName "RivaTuner" -Action $action -Trigger $trigger -RunLevel Highest -Description $description -Settings $settings | Out-Null