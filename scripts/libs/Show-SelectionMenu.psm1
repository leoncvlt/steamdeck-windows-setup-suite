# from https://github.com/chrisseroka/ps-menu
function DrawMenu {
    param ($menuItems, $menuPosition, $Multiselect, $selection)
    $l = $menuItems.length
    for ($i = 0; $i -le $l; $i++) {
        if ($null -ne $menuItems[$i]) {
            $item = $menuItems[$i]
            if ($Multiselect) {
                if ($selection -contains $i) {
                    $item = '[#] ' + $item
                }
                else {
                    $item = '[ ] ' + $item
                }
            }
            if ($i -eq $menuPosition) {
                Write-Host " ~$($item)" -ForegroundColor Blue
            }
            else {
                Write-Host "  $($item)"
            }
        }
    }
}

function ToggleSelection {
    param ($pos, [array]$selection)
    if ($selection -contains $pos) { 
        $result = $selection | Where-Object { $_ -ne $pos }
    }
    else {
        $selection += $pos
        $result = $selection
    }
    $result
}

function Show-SelectionMenu {
    param ([array]$menuItems, [switch]$ReturnIndex = $false, [switch]$Multiselect, [array]$InitialSelection = @())
    $vkeycode = 0
    $pos = 0
    $selection = $InitialSelection
    if ($menuItems.Length -gt 0) {
        try {
            [console]::CursorVisible = $false #prevents cursor flickering
            DrawMenu $menuItems $pos $Multiselect $selection
            While ($vkeycode -ne 13 -and $vkeycode -ne 27) {
                $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
                $vkeycode = $press.virtualkeycode
                If ($vkeycode -eq 38 -or $press.Character -eq 'k') {
                    $pos-- 
                }
                If ($vkeycode -eq 40 -or $press.Character -eq 'j') {
                    $pos++ 
                }
                If ($vkeycode -eq 36) {
                    $pos = 0 
                }
                If ($vkeycode -eq 35) {
                    $pos = $menuItems.length - 1 
                }
                If ($press.Character -eq ' ' -or $vkeycode -eq 39 ) {
                    $selection = ToggleSelection $pos $selection 
                }
                if ($pos -lt 0) {
                    $pos = 0 
                }
                If ($vkeycode -eq 27) {
                    $pos = $null 
                }
                if ($pos -ge $menuItems.length) {
                    $pos = $menuItems.length - 1 
                }
                if ($vkeycode -ne 27) {
                    $startPos = [System.Console]::CursorTop - $menuItems.Length
                    [System.Console]::SetCursorPosition(0, $startPos)
                    DrawMenu $menuItems $pos $Multiselect $selection
                }
            }
        }
        finally {
            [System.Console]::SetCursorPosition(0, $startPos + $menuItems.Length)
            [console]::CursorVisible = $true
        }
    }
    else {
        $pos = $null
    }

    if ($ReturnIndex -eq $false -and $null -ne $pos) {
        if ($Multiselect) {
            return $menuItems[$selection]
        }
        else {
            return $menuItems[$pos]
        }
    }
    else {
        if ($Multiselect) {
            return $selection
        }
        else {
            return $pos
        }
    }
}