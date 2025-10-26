# ========================================
# VERIFICATION PRIVILEGES ADMINISTRATEUR
# ========================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur. Redémarrage..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    exit
}
$startTime = Get-Date
function Get-Timestamp {
    return Get-Date -Format "[dd/MM/yy HH:mm:ss]"
}
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
        $mo = [math]::Round($size / 1MB, 4)
        Write-Host "$target : $mo Mo" -ForegroundColor Cyan
        $total += $size
    }
    
    $totalMo = [math]::Round($total / 1MB, 4)
    Write-Host "------------------------------"
    Write-Host "Total $name : $totalMo Mo" -ForegroundColor Yellow
    
    return $total
}
# --- Configuration des cibles ---
# --- --- Windows --- ---
$winTargets = @(
    "$env:TEMP",
    "$env:WINDIR\Temp",
    "$env:WINDIR\Logs\CBS",
    "$env:WINDIR\Prefetch",
    "$env:WINDIR\WinSxS\Temp",
    "$env:WINDIR\Downloaded Program Files",
    "$env:WINDIR\SoftwareDistribution\Download",
    "$env:PROGRAMDATA\Microsoft\Windows\Caches",
    "$env:LOCALAPPDATA\Microsoft\Windows\WebCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*"
)
# --- --- Firefox (Local) --- ---
$localTargetsFF = @(
    "cache2\entries"
    "jumpListCache"
    "startupCache"
    "offlineCache"
    "thumbnails"
)
# --- --- Firefox (Roaming) --- ---
$roamingTargetsFF = @(
    "storage\default\https+++*"
    "cookies.sqlite"
    "places.sqlite"
)
# --- --- Google Chrome --- ---
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
# --- --- Edge --- ---
$localTargetsE = @(
    "first_party_sets.db-journal"
    "Default\WebStorage\QuotaManager-journal"
    "Default\WebAssistDatabase-journal"
    "Default\Web Data-journal"
    "Default\Top Sites-journal"
    "Default\Service Worker\ScriptCache"
    "Default\Service Worker\Database"
    "Default\Service Worker\CacheStorage"
    "Default\Nurturing\campaign_history-journal"
    "Default\Network\Cookies-journal"
    "Default\Network\Reporting and NEL-journal"
    "Default\Network Action Predictor-journal"
    "Default\Login Data-journal"
    "Default\Login Data For Account-journal"
    "Default\IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb" #???
    "Default\HubApps Icons-journal"
    "Default\GPUCache"
    "Default\Favicons-journal"
    "Default\EdgePushStorageWithWinRt\*.log"
    "Default\EdgeHubAppUsage\EdgeHubAppUsageSQLite.db-journal"
    "Default\EdgeCoupons\coupons_data.db"
    "Default\Collections\collectionsSQLite-journal"
    "Default\Code Cache"
    "Default\Cache\Cache_Data"
)
# --- Récupération des chemins ---
$firefoxLocal = Get-BrowserTargets "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles" $localTargetsFF
$firefoxRoaming = Get-BrowserTargets "$env:APPDATA\Mozilla\Firefox\Profiles" $roamingTargetsFF
$chromeLocal = Get-BrowserTargets "$env:LOCALAPPDATA\Google\Chrome" $localTargetsGC
$edgeLocal = Get-BrowserTargets "$env:LOCALAPPDATA\Microsoft\Edge" $localTargetsE
# --- Calculs ---
$totals = @{
    Windows        = Show-TargetTotals "Windows Temp & Cache" $winTargets "Green"
    FirefoxLocal   = Show-TargetTotals "Firefox Local" $firefoxLocal "Green"
    FirefoxRoaming = Show-TargetTotals "Firefox Roaming" $firefoxRoaming "Green"
    ChromeLocal    = Show-TargetTotals "Chrome Local" $chromeLocal "Green"
    EdgeLocal      = Show-TargetTotals "Edge Local" $edgeLocal "Green"
}
$allTotal = $totals.Windows + $totals.FirefoxLocal + $totals.FirefoxRoaming + $totals.ChromeLocal + $totals.EdgeLocal
$allTotalMo = [math]::Round($allTotal / 1MB, 2)
# --- Affichage ---
Write-Host "------------------------------"
Write-Host "Total Tous Navigateurs : $allTotalMo Mo" -ForegroundColor Magenta
Write-Host "------------------------------"

# --- Résumé final ---
Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║                     RÉSUMÉ DE L'ANALYSE                       ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
# Calcul des totaux par catégorie
$totalWindows = $totals.Windows
$totalFirefox = $totals.FirefoxLocal + $totals.FirefoxRoaming
$totalChrome = $totals.ChromeLocal
$totalEdge = $totals.EdgeLocal
$grandTotal = $totalWindows + $totalFirefox + $totalChrome + $totalEdge
# Affichage formaté
$winMo = [math]::Round($totalWindows / 1MB, 2)
$ffMo = [math]::Round($totalFirefox / 1MB, 2)
$chromeMo = [math]::Round($totalChrome / 1MB, 2)
$edgeMo = [math]::Round($totalEdge / 1MB, 2)
$totalMo = [math]::Round($grandTotal / 1MB, 2)
$totalGo = [math]::Round($grandTotal / 1GB, 2)
$winGo = [math]::Round($totalWindows / 1GB, 2)
$ffGo = [math]::Round($totalFirefox / 1GB, 2)
$chromeGo = [math]::Round($totalChrome / 1GB, 2)
$edgeGo = [math]::Round($totalEdge / 1GB, 2)
$duration = (Get-Date) - $startTime
Write-Host "🪟🪟🪟🪟   Windows (Temp & Cache) : " -NoNewline
Write-Host ("{0,10} Mo" -f $winMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $winGo) -ForegroundColor DarkGreen
Write-Host "🦊🦊🦊🦊   Firefox (Total)        : " -NoNewline
Write-Host ("{0,10} Mo" -f $ffMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $ffGo) -ForegroundColor DarkGreen
Write-Host "🔵🔴🟡🟢   Chrome                 : " -NoNewline
Write-Host ("{0,10} Mo" -f $chromeMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $chromeGo) -ForegroundColor DarkGreen
Write-Host "🌊🌊🌊🌊   Edge                   : " -NoNewline
Write-Host ("{0,10} Mo" -f $edgeMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $edgeGo) -ForegroundColor DarkGreen
Write-Host "🌊         Edge                   : " -NoNewline
Write-Host ("{0,10} Mo" -f $edgeMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $edgeGo) -ForegroundColor DarkGreen
Write-Host "`n  ─────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "`n📊  TOTAL GÉNÉRAL               : " -NoNewline
Write-Host ("{0,10} Mo" -f $totalMo) -ForegroundColor Yellow -NoNewline
Write-Host (" ({0:N2} Go)" -f $totalGo) -ForegroundColor DarkYellow
Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║                    Analyse terminée ✓                         ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
Read-Host "Fin"