# --- --- Edge --- ---
$edgeProfilPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
$edgeTargets = @(
    # "Cache"
    "Cache\Cache_Data"
    "Code Cache"
    "GPUCache"
    "DawnCache"
    "Media Cache"
    # "Service Worker"
    "Service Worker\CacheStorage"
    "Service Worker\ScriptCache"
    "Site Characteristics Database"
    "optimization_guide_hint_cache_store"
    "optimization_guide_model_and_features_store"
    # "Local Storage" ???
    "Session Storage"
    # "IndexedDB" ???
    "databases"
    "blob_storage"
    # "File System" ??? /!\
    "Download Service"
    # "Storage\ext" ???
    "WebRTC Logs"
    # "Sessions" ???
    "Network"
    "AutofillStrikeDatabase"
)
$edgeTargetsRoot = @(
    "$edgeProfilPath\ShaderCache"
    "$edgeProfilPath\GrShaderCache"
)
# --- --- Google Chrome --- ---
$chromeProfilPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$chromeTargets = @(
    # "Cache"
    "Cache\Cache_Data"
    "Code Cache"
    "GPUCache"
    "DawnCache"
    "Media Cache"
    # "Service Worker"
    "Service Worker\CacheStorage"
    "Service Worker\ScriptCache"
    "Site Characteristics Database"
    "optimization_guide_hint_cache_store"
    "optimization_guide_model_and_features_store"
    # "Local Storage" ???
    "Session Storage"
    # "IndexedDB" ???
    "databases"
    "blob_storage"
    # "File System" ??? /!\
    "Download Service"
    # "Storage\ext" ???
    "WebRTC Logs"
    # "Sessions" ???
    "Network"
    "AutofillStrikeDatabase"
)
$chromeTargetsRoot = @(
    "$chromeProfilPath\ShaderCache"
    "$chromeProfilPath\GrShaderCache"
)
# --- --- Brave --- ---
$braveProfilPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
$braveTargets = @(
    # "Cache"
    "Cache\Cache_Data"
    "Code Cache"
    "GPUCache"
    "DawnCache"
    "Media Cache"
    # "Service Worker"
    "Service Worker\CacheStorage"
    "Service Worker\ScriptCache"
    "Site Characteristics Database"
    "optimization_guide_hint_cache_store"
    "optimization_guide_model_and_features_store"
    # "Local Storage" ???
    "Session Storage"
    # "IndexedDB" ???
    "databases"
    "blob_storage"
    # "File System" ??? /!\
    "Download Service"
    # "Storage\ext" ???
    "WebRTC Logs"
    # "Sessions" ???
    "Network"
    "AutofillStrikeDatabase"
    "VideoDecodeStats"
)
$braveTargetsRoot = @(
    "$braveProfilPath\Crashpad"
    "$braveProfilPath\ShaderCache"
    "$braveProfilPath\GrShaderCache"
    "$braveProfilPath\Crash Reports"
)
# --- --- Opera --- ---
$operaProfilPathR = "$env:APPDATA\Opera Software\Opera Stable"
$operaProfilPathL = "$env:LOCALAPPDATA\Opera Software\Opera Stable"
$operaTargetsRoot = @(
    "$operaProfilPathR\ShaderCache"
    "$operaProfilPathR\GrShaderCache"
)
$operaTargetsR = @(
    "AutofillAiModelCache"                        # Analyse AI pour autoremplissage des formulaires
    # "AutofillStrikeDatabase"                    # "Strike" autoremplissage des formulaires
    "blob_storage"                                # Données binaires temporaires (DL/UL de gros fichiers)
    "Cache"                                       # Cache principal
    # "Cache\Cache_Data"                          # Sous-dossier du cache principal, remplace/enrichit le fonctionnement classique du cache
    "Code Cache"                                  # Cache pour les scripts JS compilés
    "Crash Reports"                               # Rapports d'erreurs des applications
    "GPUCache"                                    # Cache pour les GPU
    # "databases"                                 # Bases de données des apps Web (pour du offline(mail,prise de note, etc) ou save de jeux)
    "DawnCache"                                   # Cache pour le rendu graphique avec Dawn
    "DawnGraphiteCache"                           # Cache pour le rendu graphique avec Dawn (Graphite)
    "DawnWebGPUCache"                             # Cache pour le rendu graphique avec Dawn (WebGPU)
    "Download Service"                            # Cache des DL en cours/pause
    # "File System" ??? /!\                       # OldBDD pour stockage offline (projets non synchronisés, brouillons, fichiers cloud pas re-synchronisés, etc) | Remplacé par IndexedDB ou localStorage
    # "IndexedDB" ???                             # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    # "Local Storage" ???                         # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    "Media Cache"                                 # Cache pour les médias (images, vidéos, etc)
    "Network"                                     # Cache reseau (Buffers pour les recherches DNS, Données préchargées (préfetching), Caches d’en-têtes HTTP/S, etc)
    "optimization_guide_hint_cache_store"         # Cache de regle d'optimisation Chromium
    "optimization_guide_model_and_features_store" # Cache de model/features d'optimisation Chromium
    # "Service Worker"
    "Service Worker\CacheStorage"                 # Cache des Service Workers (apps Web[PWA]) (cache pour ressources offline, preferences, etc)
    "Service Worker\ScriptCache"                  # Cache des scripts JS des Service Workers (apps Web[PWA])
    # "Sessions" ???                              # Etat session active (onglets ouverts, les fenêtres en cours, les groupes d’onglets, et leur historique/position)
    "Session Storage"                             # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    "ShaderCache"                                 # Cache pour le rendu graphique
    "Site Characteristics Database"               # Statistiques de site (temps de chargement, etc)
    "WebRTC Logs"                                 # Logs WebRTC (logs de communication audio/video)
)
$operaTargetsL = @(
    "cache\Cache_Data"
    "System Cache\Cache_Data"
)
# $operaProfilPath = "$env:LOCALAPPDATA\Opera Software\Opera Stable"
# $operaProfilPath = "$env:LOCALAPPDATA\Opera Software\Opera Stable"
# $operaTargets = @(
#     # "Cache"
#     "Cache\Cache_Data"
#     "Code Cache"
#     "GPUCache"
#     "DawnCache"
#     "Media Cache"
#     # "Service Worker"
#     "Service Worker\CacheStorage"
#     "Service Worker\ScriptCache"
#     "Site Characteristics Database"
#     "optimization_guide_hint_cache_store"
#     "optimization_guide_model_and_features_store"
#     # "Local Storage" ???
#     "Session Storage"
#     # "IndexedDB" ???
#     "databases"
#     "blob_storage"
#     # "File System" ??? /!\
#     "Download Service"
#     # "Storage\ext" ???
#     "WebRTC Logs"
#     # "Sessions" ???
#     "Network"
#     "AutofillStrikeDatabase"
# )


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

$edgeLocal = Get-ChromiumTargets $edgeProfilPath $edgeTargets
$chromeLocal = Get-ChromiumTargets $chromeProfilPath $chromeTargets
$braveLocal = Get-ChromiumTargets $braveProfilPath $braveTargets
$operaLocal = Get-ChromiumTargets $operaProfilPath $operaTargets
# --- Calculs ---
$totals = @{
    # Windows        = Show-TargetTotals "Windows Temp & Cache" $winTargets "Green"
    # FirefoxLocal   = Show-TargetTotals "Firefox Local" $firefoxLocal "Green"
    # FirefoxRoaming = Show-TargetTotals "Firefox Roaming" $firefoxRoaming "Green"
    EdgeRoot    = Show-TargetTotals "Edge Root" $edgeTargetsRoot "Green"
    EdgeLocal   = Show-TargetTotals "Edge Profil" $edgeLocal "Green"
    ChromeRoot  = Show-TargetTotals "Chrome Root" $chromeTargetsRoot "Green"
    ChromeLocal = Show-TargetTotals "Chrome Profil" $chromeLocal "Green"
    BraveRoot   = Show-TargetTotals "Brave Root" $braveTargetsRoot "Green"
    BraveLocal  = Show-TargetTotals "Brave Local" $braveLocal "Green"
    OperaRoot   = Show-TargetTotals "Opera Root" $operaTargetsRoot "Green"
    OperaLocal  = Show-TargetTotals "Opera Local" $operaLocal "Green"
    # OperaRoaming   = Show-TargetTotals "Opera Roaming" $operaRoaming "Green"
}
$allTotal = $totals.Windows + $totals.FirefoxLocal + $totals.FirefoxRoaming + $totals.ChromeLocal + $totals.ChromeRoot + $totals.EdgeLocal + $totals.EdgeRoot + $totals.BraveLocal + $totals.BraveRoot + $totals.OperaLocal + $totals.OperaRoaming + $totals.OperaRoot
$allTotalMo = [math]::Round($allTotal / 1MB, 2)
# --- Affichage ---
Write-Host "------------------------------"
Write-Host "Total Tous Navigateurs : $allTotalMo Mo" -ForegroundColor Magenta
Write-Host "------------------------------"

# --- Résumé final ---
# Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
# Write-Host "║                     RÉSUMÉ DE L'ANALYSE                       ║" -ForegroundColor Magenta
# Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
# Write-Host ""
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
# $duration = (Get-Date) - $startTime
# Write-Host "$duration"
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




# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Cache\                        (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Cache\Cache_Data\             (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Code Cache\                   (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\GPUCache\                     (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Service Worker\               (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Service Worker\CacheStorage\  (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Blob_storage\                 (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Network\                      (SUPPRIMABLE) -------------
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\GrShaderCache\                (SUPPRIMABLE) ------------

# # Stockage et données web (SUPPRIMABLE pour nettoyage profond, mais perte de sessions/sites connectés/autorisations) :
# $edgeTargetsData = @(
#     "IndexedDB"
#     "Local Storage"
#     "Session Storage"
#     "Storage"
#     "Shared Dictionary"
#     "QuotaManager"
# )
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\IndexedDB\             (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Local Storage\         (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Session Storage\       (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Storage\               (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Shared Dictionary\     (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\QuotaManager           (SUPPRIMABLE) -----------
# Attention : perte des stocks web apps, localStorage, bases IndexedDB, etc., possible déconnexion de sites.

# Fichiers de données utilisateur :
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Cookies                (SUPPRIMABLE, mais perte connexions, suivi...)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Cookies-journal        (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\History                (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\History-journal        (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Visited Links          (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Downloads              (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\DownloadMetadata       (SUPPRIMABLE)
# Ces suppressions entraînent la disparition de l historique, cookies, téléchargements récents, listes de liens visités, etc.

# Préférences, favoris, et données essentielles (À CONSERVER) :
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Preferences            (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Top Sites              (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Login Data             (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Web Data               (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Bookmarks              (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Favicons               (À CONSERVER)
# Ces fichiers gèrent favoris, mdp enregistrés, préférences personnelles, infos de formulaires, icônes, etc.

# Extensions, logs, rapports (SUPPRIMABLE ou RÉSÉRVER, selon usage) :
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Extensions\                    (À CONSERVER si tu veux garder extensions installées)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Extension State\               (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Extension Cookies              (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Collections\                   (À CONSERVER si tu utilises cette fonctionnalité)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Crashpad\                      (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Reporting and NEL\             (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\SSLErrorAssistant              (SUPPRIMABLE)

# Notifications et sessions (SUPPRIMABLE mais perte de sessions ouvertes) :
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\PlatformNotifications\          (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Profile Path                   (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Current Session                (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Current Tabs                   (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Last Session                   (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\<profil>\Last Tabs                      (SUPPRIMABLE)

# Fichiers système Edge (À CONSERVER) :
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Local State                 (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\First Run                   (À CONSERVER)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Dictionaries\               (À CONSERVER si tu utilises le correcteur)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\ShaderCache\                (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\GraphiteDawnCache\          (SUPPRIMABLE)
# C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Crashpad\                   (SUPPRIMABLE)

# Edge Legacy (Ancien, peut être supprimé si inutilisé) :
# C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\     (SUPPRIMABLE sauf besoin spécifique)


















