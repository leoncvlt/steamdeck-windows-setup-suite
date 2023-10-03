Get-Process -Name "onedrive*" | Stop-Process -Force
Get-Service -Name "onedrive*" | Stop-Service -Force
Start-Sleep -s 2
$onedrive = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
If (!(Test-Path $onedrive)) {
    $onedrive = "$env:SystemRoot\System32\OneDriveSetup.exe"
}
Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
Start-Sleep -s 2
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse 
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse 
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse 
Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse 