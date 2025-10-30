# ========================================
# VERIFICATION PRIVILEGES ADMINISTRATEUR
# ========================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur. Redémarrage..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    exit
}
# ========================================
# DEFINITION VARIABLES ET LISTES
# ========================================

# -------------
# APPLICATIONS
#--------------

# -------------
# NAVIGATEURS
#--------------
# --- --- Brave --- ---
$bravePath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
$braveTargetsRoot = @(
    "$bravePath\component_crx_cache",
    "$bravePath\extensions_crx_cache",
    "$bravePath\GraphiteDawnCache",
    "$bravePath\GrShaderCache",
    "$bravePath\ShaderCache"
)
$braveTargetsL = @(
    "Cache\Cache_Data"
    "GPUCache"
    "Code Cache"
    "Account Web Data-journal"
    "Affiliation Database-journal"
    "Favicons-journal"
    "heavy_ad_intervention_opt_out.db-journal"
    "History-journal"
    "Login Data For Account-journal"
    "Login Data-journal"
    "Network Action Predictor-journal"
    "ServerCertificate-journal"
    "Shortcuts-journal"
    "Top Sites-journal"
    "Web Data-journal"
    "ads_service\database.sqlite-journal"
    "Network\Cookies-journal"
    "Network\Reporting and NEL-journal"
    "Network\Trust Tokens-journal"
    "Safe Browsing Network\Safe Browsing Cookies-journal"
    "Shared Dictionary\db-journal"
    "WebStorage\QuotaManager-journal"
    "Top Sites"
    "Network Action Predictor"
)
# --- --- Edge --- ---
$edgePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
$edgeTargetsRoot = @(
    "$edgePath\first_party_sets.db-journal"
    "$edgePath\ShaderCache"
    "$edgePath\GrShaderCache"
    "$edgePath\BrowserMetrics"
    "$edgePath\GraphiteDawnCache"
    "$edgePath\extensions_crx_cache"
    "$edgePath\Snapshots\*\Default\History-journal"
    "$edgePath\Snapshots\*\Default\Login Data-journal"
    "$edgePath\Snapshots\*\Default\Login Data For Account-journal"
    "$edgePath\Snapshots\*\Default\Collections\collectionsSQLite-journal"
)
$edgeTargetsL = @(
    "WebStorage\QuotaManager-journal"
    "WebAssistDatabase-journal"
    "Web Data-journal"
    "Top Sites-journal"
    "Service Worker\ScriptCache"
    "Service Worker\Database"
    "Service Worker\CacheStorage"
    "Nurturing\campaign_history-journal"
    "Network\Cookies-journal"
    "Network\Reporting and NEL-journal"
    "Network Action Predictor-journal"
    "Login Data-journal"
    "Login Data For Account-journal"
    "IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb"
    "HubApps Icons-journal"
    "GPUCache"
    "Favicons-journal"
    "EdgePushStorageWithWinRt\*.log"
    "EdgeHubAppUsage\EdgeHubAppUsageSQLite.db-journal"
    "EdgeCoupons\coupons_data.db"
    "Collections\collectionsSQLite-journal"
    "Code Cache"
    "Cache\Cache_Data"
    "Storage\ext\ihmafllikibpmigkcoadcmckbfhibefp\def\Code Cache"
    "Storage\ext\ihmafllikibpmigkcoadcmckbfhibefp\def\GPUCache"
    "Storage\ext\ihmafllikibpmigkcoadcmckbfhibefp\def\Network\Trust Tokens-journal"
    "Storage\ext\ihmafllikibpmigkcoadcmckbfhibefp\def\Shared Dictionary\db-journal"
    "IndexedDB\https*"
    "ExtensionActivityEdge-journal"
    "History-journal"
    "Collections\collectionsSQLite-journal"
    "Shared Dictionary\db-journal"
    "BrowsingTopicsSiteData-journal"
    "ExensionActivityEdge-journal"
    "heavy_ad_intervention_opt_out.db-journal"
    "PrivateAggregation-journal"
    "ServerCertificate-journal"
    "Shortcuts-journal"
    "Vpn Tokens-journal"
    "Web Data-journal"
    "EdgeEDrop\EdgeEDropSQLite.db-journal"
    "Network\Trust Tokens-journal"
    "Safe Browsing Network\Safe Browsing Cookies-journal"
)
# --- --- Firefox --- ---
$firefoxPathR = "$env:APPDATA\Mozilla\Firefox\Profiles"
$firefoxPathL = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles"
$firefoxTargetsR = @(
    "storage\default\https+++*"
    "cookies.sqlite"
    "places.sqlite"
)
$firefoxTargetsL = @(
    "cache2\entries"
    "jumpListCache"
    "startupCache"
    "offlineCache"
    "thumbnails"
)
# --- --- Google Chrome --- ---
$chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$chromeTargetsRoot = @(
    "$chromePath\first_party_sets.db-journal",
    "$chromePath\CrashpadMetrics-active.pma",
    "$chromePath\BrowserMetrics"
)
$chromeTargetsL = @(
    "WebStorage\QuotaManager-journal"
    "WebStorage\20\IndexedDB\indexeddb.leveldb"
    "Web Data-journal"
    "Top Sites"
    "Network Action Predictor"
    "Service Worker\ScriptCache"
    "Service Worker\Database"
    "Shared Dictionary\db-journal"
    "Network\Cookies-journal"
    "Network\Reporting and NEL-journal"
    "Network Action Predictor-journal"
    "Login Data-journal"
    "Login Data For Account-journal"
    "History-journal"
    "GPUCache"
    "Platform Notifications"
    "Favicons-journal"
    "Conversions-journal"
    "Code Cache"
    "Cache\Cache_Data"
    "Affiliation Database-journal"
)
# --- --- Opera --- ---
$operaPathR = "$env:APPDATA\Opera Software\Opera Stable"
$operaPathL = "$env:LOCALAPPDATA\Opera Software\Opera Stable"
$operaTargetsRoot = @(
    "$operaPathR\ShaderCache"
    "$operaPathR\component_crx_cache"
    "$operaPathR\GraphiteDawnCache"
    "$operaPathR\GrShaderCach"
)
$operaTargetsR = @(
    "Affiliation Database-journal"
    "Favicons-journal"
    "History-journal"
    "Login Data-journal"
    "Network Action Predictor"
    "Network Action Predictor-journal"
    "ServerCertificate-journal"
    "Shortcuts-journal"
    "Web Data-journal"
    "Jump List Icons"
    "Jump List IconsOld"
    "Network\Cookies-journal"
    "Network\Reporting and NEL-journal"
    "Network\Trust Tokens-journal"
    "Safe Browsing Network\Safe Browsing Cookies-journal"
    "Shared Dictionary\db-journal"
    "WebStorage\5"
    "WebStorage\7"
    "WebStorage\QuotaManager-journal"
    "GPUCache"
    "Code Cache"
    "IndexedDB\https*"
)
$operaTargetsL = @(
    "cache\Cache_Data"
)
# --- --- Opera GX --- ---
# --- --- Vivaldi --- ---

# -------------
# WINDOWS/SYST
#--------------
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
# ========================================
# CREATION DES FONCTIONS
# ========================================
function Get-Timestamp {
    return Get-Date -Format "[dd/MM/yy HH:mm:ss]"
}
function Get-FolderSize($path) {
    if (-not $path) { return 0 }
    
    try {
        $resolvedPaths = @(Resolve-Path $path -ErrorAction SilentlyContinue)
        
        if ($resolvedPaths.Count -eq 0) { return 0 }
        
        $totalSize = 0
        
        foreach ($resolvedPath in $resolvedPaths) {
            $item = Get-Item $resolvedPath -Force -ErrorAction SilentlyContinue
            
            if ($item.PSIsContainer) {
                $size = (Get-ChildItem -Path $resolvedPath -Recurse -Force -File -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                
                if ($size) { $totalSize += $size }
            }
            else {
                if ($item.Length) { $totalSize += $item.Length }
            }
        }
        
        return $totalSize
    }
    catch {
        return 0
    }
}
# Fonction pour Firefox (qui a un dossier Profiles)
function Get-FirefoxTargets($profilesRoot, $targetPaths) {
    if (-not (Test-Path $profilesRoot)) { return @() }
    
    $targets = @()
    # Firefox: tous les dossiers dans Profiles
    $profiles = Get-ChildItem -Path $profilesRoot -Directory -ErrorAction SilentlyContinue
    
    foreach ($profil in $profiles) {
        foreach ($targetPath in $targetPaths) {
            $targets += Join-Path $profil.FullName $targetPath
        }
    }
    
    return $targets
}
# Fonction pour Chrome/Edge (qui ont User Data avec Default et Profile *)
function Get-ChromiumTargets($userDataRoot, $targetPaths) {
    if (-not (Test-Path $userDataRoot)) { return @() }
    
    $targets = @()
    # Chrome/Edge: chercher Default et Profile *
    $profiles = Get-ChildItem -Path $userDataRoot -Directory -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile *" }
    
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
        $mo = [math]::Round($size / 1KB, 4)
        Write-Host "$target : $mo Ko" -ForegroundColor Cyan
        $total += $size
    }
    
    $totalMo = [math]::Round($total / 1MB, 4)
    Write-Host "------------------------------"
    Write-Host "Total $name : $totalMo Mo" -ForegroundColor Yellow
    
    return $total
}

# ========================================
# EXECUTION DES FONCTIONS
# ========================================
$startTime = Get-Date

# --- Récupération des chemins ---
# Firefox utilise la fonction dédiée
$firefoxLocal = Get-FirefoxTargets $firefoxPathL $firefoxTargetsL
$firefoxRoaming = Get-FirefoxTargets $firefoxPathR $firefoxTargetsR
$operaLocal = Get-ChromiumTargets $operaPathL $operaTargetsL
$operaRoaming = Get-ChromiumTargets $operaPathR $operaTargetsR

# Chrome et Edge utilisent la fonction Chromium
$chromeLocal = Get-ChromiumTargets $chromePath $chromeTargetsL
$edgeLocal = Get-ChromiumTargets $edgePath $edgeTargetsL
$braveLocal = Get-ChromiumTargets $bravePath $braveTargetsL

# --- Calculs ---
$totals = @{
    # Windows        = Show-TargetTotals "Windows Temp & Cache" $winTargets "Green"
    # FirefoxLocal   = Show-TargetTotals "Firefox Local" $firefoxLocal "Green"
    # FirefoxRoaming = Show-TargetTotals "Firefox Roaming" $firefoxRoaming "Green"
    # ChromeLocal    = Show-TargetTotals "Chrome Local" $chromeLocal "Green"
    # ChromeRoot     = Show-TargetTotals "Chrome Root" $chromeTargetsRoot "Green"
    EdgeLocal = Show-TargetTotals "Edge Local" $edgeLocal "Green"
    EdgeRoot  = Show-TargetTotals "Edge Root" $edgeTargetsRoot "Green"
    # BraveLocal     = Show-TargetTotals "Brave Local" $braveLocal "Green"
    # BraveRoot      = Show-TargetTotals "Brave Root" $braveTargetsRoot "Green"
    # OperaLocal     = Show-TargetTotals "Opera Local" $operaLocal "Green"
    # OperaRoaming   = Show-TargetTotals "Opera Roaming" $operaRoaming "Green"
    # OperaRoot      = Show-TargetTotals "Opera Root" $operaTargetsRoot "Green"
}
$allTotal = $totals.Windows + $totals.FirefoxLocal + $totals.FirefoxRoaming + $totals.ChromeLocal + $totals.ChromeRoot + $totals.EdgeLocal + $totals.EdgeRoot + $totals.BraveLocal + $totals.BraveRoot + $totals.OperaLocal + $totals.OperaRoaming + $totals.OperaRoot
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
$totalChrome = $totals.ChromeLocal + $totals.ChromeRoot
$totalEdge = $totals.EdgeLocal + $totals.EdgeRoot
$totalBrave = $totals.BraveLocal + $totals.BraveRoot
$totalOpera = $totals.OperaLocal + $totals.OperaRoaming + $totals.OperaRoot
$grandTotal = $totalWindows + $totalFirefox + $totalChrome + $totalEdge + $totalBrave + $totalOpera
# Affichage formaté
$winMo = [math]::Round($totalWindows / 1MB, 2)
$ffMo = [math]::Round($totalFirefox / 1MB, 2)
$chromeMo = [math]::Round($totalChrome / 1MB, 2)
$edgeMo = [math]::Round($totalEdge / 1MB, 2)
$braveMo = [math]::Round($totalBrave / 1MB, 2)
$operaMo = [math]::Round($totalOpera / 1MB, 2)
$totalMo = [math]::Round($grandTotal / 1MB, 2)
$totalGo = [math]::Round($grandTotal / 1GB, 2)
$winGo = [math]::Round($totalWindows / 1GB, 2)
$ffGo = [math]::Round($totalFirefox / 1GB, 2)
$chromeGo = [math]::Round($totalChrome / 1GB, 2)
$edgeGo = [math]::Round($totalEdge / 1GB, 2)
$braveGo = [math]::Round($totalBrave / 1GB, 2)
$operaGo = [math]::Round($totalOpera / 1GB, 2)
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
Write-Host "🦁🦁🦁🦁   Brave                  : " -NoNewline
Write-Host ("{0,10} Mo" -f $braveMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $braveGo) -ForegroundColor DarkGreen
Write-Host "⭕⭕⭕⭕   Opera                  : " -NoNewline
Write-Host ("{0,10} Mo" -f $operaMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $operaGo) -ForegroundColor DarkGreen
Write-Host "⭕⭕⭕⭕   Opera GX               : " -NoNewline
Write-Host ("{0,10} Mo" -f $braveMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $braveGo) -ForegroundColor DarkGreen
Write-Host "🔴🔴🔴🔴   Vivaldi                : " -NoNewline
Write-Host ("{0,10} Mo" -f $braveMo) -ForegroundColor Green -NoNewline
Write-Host (" ({0:N2} Go)" -f $braveGo) -ForegroundColor DarkGreen
Write-Host "`n  ─────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "`n📊  TOTAL GÉNÉRAL               : " -NoNewline
Write-Host ("{0,10} Mo" -f $totalMo) -ForegroundColor Yellow -NoNewline
Write-Host (" ({0:N2} Go)" -f $totalGo) -ForegroundColor DarkYellow
Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║                    Analyse terminée ✓                         ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
# Read-Host "Fin"