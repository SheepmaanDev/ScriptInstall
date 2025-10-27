function Get-FolderSize($path) {
    if (-not $path) { return 0 }
    
    try {
        # Gère les wildcards en résolvant tous les chemins correspondants
        $resolvedPaths = @(Resolve-Path $path -ErrorAction SilentlyContinue)
        
        if ($resolvedPaths.Count -eq 0) { return 0 }
        
        $totalSize = 0
        
        foreach ($resolvedPath in $resolvedPaths) {
            $item = Get-Item $resolvedPath -Force -ErrorAction SilentlyContinue
            
            if ($item.PSIsContainer) {
                # C'est un dossier : calcule la taille de tout son contenu
                $size = (Get-ChildItem -Path $resolvedPath -Recurse -Force -File -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                
                if ($size) { $totalSize += $size }
            }
            else {
                # C'est un fichier : ajoute sa taille directement
                if ($item.Length) { $totalSize += $item.Length }
            }
        }
        
        return $totalSize
    }
    catch {
        return 0
    }
}

function Get-BrowserTargets($profilesRoot, $targetPaths) {
    if (-not (Test-Path $profilesRoot)) { return @() }
    
    $targets = @()
    $testPathFF = Get-ChildItem -Path $profilesRoot -Directory | Where-Object { $profilesRoot -like "*Mozilla*" }
    # Write-Host "$test"
    if ($testPathFF) {
        Write-Host "I'M MOTHERFUCKING FF !! " -ForegroundColor Green
        $profiles = Get-ChildItem -Path $profilesRoot -Directory -ErrorAction SilentlyContinue
    }
    else {
        $profiles = Get-ChildItem -Path $profilesRoot -Directory | Where-Object {
            $_.Name -eq "Default" -or $_.Name -like "Profile *"
        }
    }
    $profiles = Get-ChildItem -Path $profilesRoot -Directory -ErrorAction SilentlyContinue
    
    foreach ($profil in $profiles) {
        foreach ($targetPath in $targetPaths) {
            $targets += Join-Path $profil.FullName $targetPath
        }
    }
    
    return $targets
}

function Show-TargetTotals($name, $targets, $color) {
    Write-Host "`n--- $name ---" -ForegroundColor $color
    
    $total = 0
    foreach ($target in $targets) {
        $size = Get-FolderSize $target
        $mo = [math]::Round($size / 1MB, 2)
        Write-Host "$target : $mo Mo" -ForegroundColor Cyan
        $total += $size
    }
    
    $totalMo = [math]::Round($total / 1MB, 2)
    Write-Host "------------------------------"
    Write-Host "Total $name : $totalMo Mo" -ForegroundColor Yellow
    
    return $total
}

# --- Configuration des cibles ---
$localTargetsFF = @(
    "cache2\entries"
    "jumpListCache"
    "startupCache"
    "offlineCache"
    "thumbnails"
)
$roamingTargetsFF = @(
    "storage\default\https+++*"
    "cookies.sqlite"
    "places.sqlite"
)
$localTargetsGC = @(
    "first_party_sets.db-journal"
    "CrashpadMetrics-active.pma"
    "BrowserMetrics"
    "Default\WebStorage\QuotaManager-journal"
    "Default\WebStorage\20\IndexedDB\indexeddb.leveldb"
    "Default\Web Data-journal"
    "Default\Top Sites"
    "Default\Network Action Predictor"
    "Default\Service Worker\ScriptCache"
    "Default\Service Worker\Database"
    "Default\Shared Dictionary\db-journal"
    "Default\Network\Cookies-journal"
    "Default\Network\Reporting and NEL-journal"
    "Default\Network Action Predictor-journal"
    "Default\Login Data-journal"
    "Default\Login Data For Account-journal"
    "Default\History-journal"
    "Default\GPUCache"
    "Default\Favicons-journal"
    "Default\Conversions-journal"
    "Default\Code Cache"
    "Default\Cache\Cache_Data"
    "Default\Affiliation Database-journal"
)

# --- Récupération des chemins ---
$firefoxLocal = Get-BrowserTargets "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles" $localTargetsFF
$firefoxRoaming = Get-BrowserTargets "$env:APPDATA\Mozilla\Firefox\Profiles" $roamingTargetsFF
$chromeLocal = Get-BrowserTargets "$env:LOCALAPPDATA\Google\Chrome\User Data" $localTargetsGC

# --- Calculs & Affichage ---
$totals = @{
    FirefoxLocal   = Show-TargetTotals "Firefox Local" $firefoxLocal "Green"
    FirefoxRoaming = Show-TargetTotals "Firefox Roaming" $firefoxRoaming "Green"
    ChromeLocal    = Show-TargetTotals "Chrome Local" $chromeLocal "Green"
}

$allTotal = $totals.FirefoxLocal + $totals.FirefoxRoaming + $totals.ChromeLocal
$allTotalMo = [math]::Round($allTotal / 1MB, 2)

Write-Host "------------------------------"
Write-Host "Total Tous Navigateurs : $allTotalMo Mo" -ForegroundColor Magenta
Write-Host "------------------------------"