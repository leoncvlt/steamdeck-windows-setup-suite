
function Install-DownloadPackage {
    Param (
        [Parameter(Mandatory)][String]$Path, 
        [String]$Match,
        [String]$Target,
        [String]$Arguments
    )

    $Cleanup = New-Object System.Collections.ArrayList

    if (-Not (Test-Path -Path $Path -PathType Leaf)) {
        if ($Path.Contains("api.github.com") -And $Path.Contains("releases")) { 
            $Path = (Invoke-WebRequest -Uri $Path -UseBasicParsing).Content | ConvertFrom-Json |
            Select-Object -ExpandProperty "assets" |
            Where-Object "browser_download_url" -Match $Match |
            Select-Object -ExpandProperty "browser_download_url"
        }

        $TempFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.IO.Path]::GetFileName($Path))
        Write-Host  "Downloading $Path"
        Invoke-WebRequest -URI $Path -OutFile $TempFile
        $Path = $TempFile
    }

    $Ext = [System.IO.Path]::GetExtension($Path)
    if ($Ext -eq ".zip" -Or $Ext -eq ".cab") {
        $TempPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([guid]::NewGuid().ToString())
        Write-Output "Expanding archive to $TempPath"
        if ($Ext -eq ".zip") {
            Expand-Archive $Path $TempPath -Force
        }
        if ($Ext -eq ".cab") {
            Start-Process -FilePath "expand.exe" -ArgumentList "-F:* $Path $TempPath" -Wait
        }

        $Cleanup.Add($Path)
        $Cleanup.Add($TempPath)

        $Path = $(Join-Path -Path $TempPath -ChildPath $Target)
        $Ext = [System.IO.Path]::GetExtension($Path)
    }
    else {
        $Cleanup.Add($Path)
    }

    Write-Output "Executing $Path"
    $Process = $null

    if ($Ext -eq ".inf") {
        $Process = Start-Process -FilePath "PNPUtil.exe" -ArgumentList "/add-driver `"$Path`" /install" -Wait -PassThru
    }
    if ($Ext -eq ".msixbundle") {
        Add-AppxPackage -Path $Path
    }
    if ($Ext -eq ".ps1") {
        Invoke-Expression "& `"$Path`""
    }
    if ($Ext -eq ".exe" -Or $Ext -eq ".cmd" -Or $Ext -eq ".bat") {
        $Props = @{}
        if ($Arguments) { $Props["ArgumentList"] = $Arguments }
        $Process = Start-Process $Path -Wait -PassThru $Props
    }

    if ($null -ne $Process) {
        $ExitCode = $Process.ExitCode
        Write-Host "Finished with exit code $ExitCode"
    }

    Remove-Item $Cleanup -Recurse -Force
}