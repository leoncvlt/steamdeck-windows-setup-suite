Import-Module -Name ("$PSScriptRoot\libs\Install-DownloadPackage.psm1")
Import-Module -Name ("$PSScriptRoot\libs\Install-WingetPackage.psm1")
Import-Module -Name ("$PSScriptRoot\libs\Remove-UWPApp.psm1")

Write-Host "Enabling touch keyboard and increasing size"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "EnableDesktopModeAutoInvoke" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "KeyboardLayoutPreference" -Value 2

Write-Host "Disabling hibernation"
Start-Process -FilePath "PowerCfg" -ArgumentList "/h /type reduced"
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0

Write-Host "Setting CPU idle min to 0% (Reduce fan speed)"
Start-Process -FilePath "PowerCfg" -ArgumentList "/SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 000" -Wait
Start-Process -FilePath "PowerCfg" -ArgumentList "/SETACTIVE SCHEME_CURRENT" -Wait

Write-Host -NoNewline "Setting internal clock to UTC"
Start-Process -FilePath "reg" -ArgumentList "add `"HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation`" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f" -Wait
Write-Host -ForegroundColor Green "Done"

Write-Host "Disabling Game Bar"
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
If (!(Test-Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar")) {
    New-Item -Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" | Out-Null
}
Set-ItemProperty -Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Type DWord -Value 0

Write-Host "Disabling Microsoft Edge running in background"
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "StartupBoostEnabled" -Value 0 -Type DWORD
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 0 -Type DWORD

Write-Host "Disabling Bing search in Start menu"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1

Write-Host "Hiding taskbar search box / button"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0

Write-Host "Hiding taskbar widgets"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarMn' -Type DWORD -Value 0 
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat' -Name 'ChatIcon' -Type DWORD -Value 3
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarDa' -Type DWORD  -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' -Name 'AllowNewsAndInterests' -Type DWORD  -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Type DWORD -Value 0 

Write-Host "Disabling Screen Edge Swipe"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\LockDown\AllowEdgeSwipe" -Name "value" -Type DWord -Value 0
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Name "AllowEdgeSwipe"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Name "AllowEdgeSwipe" -Type DWord -Value 0

Write-Host "Restoring full right-click context menu"
New-Item -Path "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null

Write-Host "Showing known file extensions"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

Write-Host "Showing hidden files"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
