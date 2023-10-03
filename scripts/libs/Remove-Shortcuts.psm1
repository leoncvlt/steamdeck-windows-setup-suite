function Remove-Shortcuts {
    Param (
        [String]$Name
    )

    foreach ($shortcut in (Get-ChildItem -Path $env:USERPROFILE -Filter "*.lnk" -File -Recurse)) {
        if ($shortcut.Name -eq $Name) {
            Write-Host "Deleting $($shortcut.FullName) shortcut"
            Remove-Item $shortcut.FullName -Force
        }
    }
   
}