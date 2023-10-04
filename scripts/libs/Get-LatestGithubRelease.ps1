function Get-LatestGithubRelease {
    Param(
        [String]$Repo,
        [String]$Match
    )

    return (Invoke-WebRequest -Uri "https://api.github.com/repos/$Repo/releases/latest" -UseBasicParsing).Content | ConvertFrom-Json |
    Select-Object -ExpandProperty "assets" |
    Where-Object "browser_download_url" -Match $Match |
    Select-Object -ExpandProperty "browser_download_url"
}