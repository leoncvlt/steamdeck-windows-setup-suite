function Remove-UWPApp() {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [String] $AppxPackage
    )

    Begin {
        $Script:TweakType = "App"
    }    

    Process {
        If ((Get-AppxPackage -AllUsers -Name "*$AppxPackage*") -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$AppxPackage*")) {  
            Write-Host "Removing $AppxPackage"
            Get-AppxPackage -AllUsers -Name "*$AppxPackage*" | Remove-AppxPackage -AllUsers
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$AppxPackage*" | Remove-AppxProvisionedPackage -Online -AllUsers
        }
    }
}