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
# --- --- Brave --- ---
$braveProfilPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
# --- --- Edge --- ---
$edgeProfilPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
# --- --- Firefox --- ---
$firefoxPathR = "$env:APPDATA\Mozilla\Firefox\Profiles"
$firefoxPathL = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles"
$firefoxTargetsR = @(
    "storage\default\https+++*" 
    "cookies.sqlite"
    #"places.sqlite"             # Historique, téléchargements, favoris (supprimer = perte historique/favoris)
)
$firefoxTargetsL = @(
    "cache2"
    "jumpListCache"
    "startupCache"
    "offlineCache"
    "thumbnails"
)
# --- --- Google Chrome --- ---
$chromeProfilPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
# --- --- Opera --- ---
$operaProfilPathR = "$env:APPDATA\Opera Software\Opera Stable"
$operaProfilPath = "$env:LOCALAPPDATA\Opera Software\Opera Stable"
# --- --- Opera GX --- ---
$operaGxProfilPathR = "$env:APPDATA\Opera Software\Opera GX Stable"
$operaGxProfilPath = "$env:LOCALAPPDATA\Opera Software\Opera GX Stable"
# --- --- Vivaldi --- ---
$vivaldiProfilPath = "$env:LOCALAPPDATA\Vivaldi\User Data"

# --- --- Windows --- ---
$localLowPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\LocalLow"
$winTargets = @(
    "$env:TEMP",
    "$env:WINDIR\Temp",
    "$env:WINDIR\Logs\CBS",
    "$env:WINDIR\Prefetch",
    "$env:WINDIR\WinSxS\Temp",
    "$env:WINDIR\LiveKernelReports",
    "$env:WINDIR\Downloaded Program Files",
    "$env:WINDIR\SoftwareDistribution\Download",
    "$env:PROGRAMDATA\Microsoft\Windows\Caches",
    "$env:LOCALAPPDATA\CrashDumps",
    "$env:LOCALAPPDATA\Microsoft\Windows\WebCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*",
    "$localLowPath\Microsoft\CryptnetUrlCache\Content",
    "$localLowPath\Microsoft\CryptnetUrlCache\MetaData"
)
# --- --- Chromium --- ---
$chromiumTargets = @(
    "AutofillAiModelCache",                        # Analyse AI pour autoremplissage des formulaires
    # "AutofillStrikeDatabase",                    # "Strike" autoremplissage des formulaires
    "blob_storage",                                # Données binaires temporaires (DL/UL de gros fichiers)
    "Cache",                                       # Cache principal
    # "Cache\Cache_Data",                          # Sous-dossier du cache principal, remplace/enrichit le fonctionnement classique du cache
    "Code Cache",                                  # Cache pour les scripts JS compilés
    "Crash Reports",                               # Rapports d'erreurs des applications
    "GPUCache",                                    # Cache pour les GPU
    # "databases",                                 # Bases de données des apps Web (pour du offline(mail,prise de note, etc) ou save de jeux)
    "DawnCache",                                   # Cache pour le rendu graphique avec Dawn
    "DawnGraphiteCache",                           # Cache pour le rendu graphique avec Dawn (Graphite)
    "DawnWebGPUCache",                             # Cache pour le rendu graphique avec Dawn (WebGPU)
    "Download Service",                            # Cache des DL en cours/pause
    # "File System", ??? /!\                       # OldBDD pour stockage offline (projets non synchronisés, brouillons, fichiers cloud pas re-synchronisés, etc) | Remplacé par IndexedDB ou localStorage
    # "IndexedDB", ???                             # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    # "Local Storage", ???                         # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    "Media Cache",                                 # Cache pour les médias (images, vidéos, etc)
    "Network",                                     # Cache reseau (Buffers pour les recherches DNS, Données préchargées (préfetching), Caches d’en-têtes HTTP/S, etc)
    "optimization_guide_hint_cache_store",         # Cache de regle d'optimisation Chromium
    "optimization_guide_model_and_features_store", # Cache de model/features d'optimisation Chromium
    # "Service Worker",
    "Service Worker\CacheStorage",                 # Cache des Service Workers (apps Web[PWA]) (cache pour ressources offline, preferences, etc)
    "Service Worker\ScriptCache",                  # Cache des scripts JS des Service Workers (apps Web[PWA])
    # "Sessions", ???                              # Etat session active (onglets ouverts, les fenêtres en cours, les groupes d’onglets, et leur historique/position)
    "Session Storage",                             # BDD apps Web (pour du offline(mail,prise de note, etc) ou save de jeux, id de session, preferences utilisateur, options de langue, etc)
    "ShaderCache",                                 # Cache pour le rendu graphique
    "Site Characteristics Database",               # Statistiques de site (temps de chargement, etc)
    "WebRTC Logs",                                 # Logs WebRTC (logs de communication audio/video)
    "Crashpad",
    "Crash Reports",
    "ShaderCache",
    "GrShaderCache"
)
# --- --- Chromium Root --- ---
$chromiumTargetsRoot = @(
    "Crashpad",
    "Crash Reports",
    "ShaderCache",
    "GrShaderCache"
)

# ========================================
# CREATION DES FONCTIONS
# ========================================
function Get-Timestamp {
    return Get-Date -Format "[dd/MM/yy HH:mm:ss]"
}
function Get-TotalOrZero($map, $key) {
    $val = $map[$key]
    if ($null -eq $val) { return 0 }
    return [double]$val
}
function Convert-Bytes($bytes) {
    $mo = [math]::Round($bytes / 1MB, 2)
    $go = [math]::Round($bytes / 1GB, 2)
    return @{ Mo = $mo; Go = $go }
}
function Get-FolderSize($path) {
    if (-not $path) { return 0 }
    try {
        $resolved = @(Resolve-Path -Path $path -ErrorAction SilentlyContinue)
        if ($resolved.Count -eq 0) { return 0 }
        $total = 0
        foreach ($rp in $resolved) {
            $item = Get-Item -LiteralPath $rp -Force -ErrorAction SilentlyContinue
            if ($null -eq $item) { continue }
            if ($item.PSIsContainer) {
                $size = (Get-ChildItem -LiteralPath $rp -Recurse -Force -File -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                if ($size) { $total += $size }
            }
            else {
                if ($item.Length) { $total += $item.Length }
            }
        }
        return $total
    }
    catch { return 0 }
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
function Get-ChromiumRootTargets($userDataRoot, $rootNames) {
    if (-not (Test-Path $userDataRoot)) { return @() }
    $targets = @()
    foreach ($name in $rootNames) {
        $targets += (Join-Path $userDataRoot $name)
    }
    return $targets
}
function Show-TargetTotals($name, $targets, $color) {
    Write-Host "`n--- $name ---" -ForegroundColor $color
    
    $total = 0
    foreach ($target in $targets) {
        $resolved = @(Resolve-Path -Path $target -ErrorAction SilentlyContinue)
        if ($resolved.Count -eq 0) {
            Write-Host "$target : (absent)" -ForegroundColor DarkGray
            continue
        }
        foreach ($rp in $resolved) {
            $size = Get-FolderSize $rp
            $mo = [math]::Round($size / 1MB, 2)
            Write-Host "$rp : $mo Mo" -ForegroundColor Cyan
            $total += $size
        }
    }
    
    $totalMo = [math]::Round($total / 1MB, 2)
    Write-Host "------------------------------"
    Write-Host "Total $name : $totalMo Mo" -ForegroundColor Yellow
    
    return $total
}
# ========================================
# EXECUTION DES FONCTIONS
# ========================================
$startTime = Get-Date
$edgeRoot = Get-ChromiumRootTargets $edgeProfilPath $chromiumTargetsRoot
$edgeRoot = Get-ChromiumRootTargets $edgeProfilPath $chromiumTargetsRoot
$edgeLocal = Get-ChromiumTargets $edgeProfilPath $chromiumTargets
$chromeRoot = Get-ChromiumRootTargets $chromeProfilPath $chromiumTargetsRoot
$chromeLocal = Get-ChromiumTargets $chromeProfilPath $chromiumTargets
$braveRoot = Get-ChromiumRootTargets $braveProfilPath $chromiumTargetsRoot
$braveLocal = Get-ChromiumTargets $braveProfilPath $chromiumTargets
$operaRoot = Get-ChromiumRootTargets $operaProfilPathR $chromiumTargetsRoot
$operaLocal = Get-ChromiumTargets $operaProfilPath $chromiumTargets
$operaRoaming = Get-ChromiumTargets $operaProfilPathR $chromiumTargets
$operaGXRoot = Get-ChromiumRootTargets $operaGXProfilPathR $chromiumTargetsRoot
$operaGXLocal = Get-ChromiumTargets $operaGXProfilPath $chromiumTargets
$operaGXRoaming = Get-ChromiumTargets $operaGXProfilPathR $chromiumTargets
$vivaldiRoot = Get-ChromiumRootTargets $vivaldiProfilPath $chromiumTargetsRoot
$vivaldiLocal = Get-ChromiumTargets $vivaldiProfilPath $chromiumTargets
$firefoxRoaming = Get-FirefoxTargets $firefoxPathR $firefoxTargetsR
$firefoxLocal = Get-FirefoxTargets $firefoxPathL $firefoxTargetsL
# --- Calculs ---
$totals = @{
    Windows        = Show-TargetTotals "Windows Temp & Cache" $winTargets "Green"
    FirefoxLocal   = Show-TargetTotals "Firefox Local" $firefoxLocal "Green"
    FirefoxRoaming = Show-TargetTotals "Firefox Roaming" $firefoxRoaming "Green"
    EdgeRoot       = Show-TargetTotals "Edge Root" $edgeRoot "Green"
    EdgeLocal      = Show-TargetTotals "Edge Profil" $edgeLocal "Green"
    ChromeRoot     = Show-TargetTotals "Chrome Root" $chromeRoot "Green"
    ChromeLocal    = Show-TargetTotals "Chrome Profil" $chromeLocal "Green"
    BraveRoot      = Show-TargetTotals "Brave Root" $braveRoot "Green"
    BraveLocal     = Show-TargetTotals "Brave Local" $braveLocal "Green"
    OperaRoot      = Show-TargetTotals "Opera Root" $operaRoot "Green"
    OperaLocal     = Show-TargetTotals "Opera Local" $operaLocal "Green"
    OperaRoaming   = Show-TargetTotals "Opera Roaming" $operaRoaming "Green"
    OperaGXRoot    = Show-TargetTotals "OperaGX Root" $operaGXRoot "Green"
    OperaGXLocal   = Show-TargetTotals "OperaGX Local" $operaGXLocal "Green"
    OperaGXRoaming = Show-TargetTotals "OperaGX Roaming" $operaGXRoaming "Green"
    VivaldiRoot    = Show-TargetTotals "Vivaldi Root" $vivaldiRoot "Green"
    VivaldiLocal   = Show-TargetTotals "Vivaldi Local" $vivaldiLocal "Green"
    # OperaRoaming   = Show-TargetTotals "Opera Roaming" $operaRoaming "Green"
}
$allTotal = $totals.Windows + $totals.FirefoxLocal + $totals.FirefoxRoaming + $totals.ChromeLocal + $totals.ChromeRoot + $totals.EdgeLocal + $totals.EdgeRoot + $totals.BraveLocal + $totals.BraveRoot + $totals.OperaLocal + $totals.OperaRoaming + $totals.OperaRoot
$allTotalMo = [math]::Round($allTotal / 1MB, 2)
# --- Affichage ---
Write-Host "------------------------------"
Write-Host "Total Tous Navigateurs : $allTotalMo Mo" -ForegroundColor Magenta
Write-Host "------------------------------"


# Calcul des totaux
$totalWindows = Get-TotalOrZero $totals 'Windows'
$totalFirefox = (Get-TotalOrZero $totals 'FirefoxLocal') + (Get-TotalOrZero $totals 'FirefoxRoaming')
$totalChrome = (Get-TotalOrZero $totals 'ChromeLocal') + (Get-TotalOrZero $totals 'ChromeRoot')
$totalEdge = (Get-TotalOrZero $totals 'EdgeLocal') + (Get-TotalOrZero $totals 'EdgeRoot')
$totalBrave = (Get-TotalOrZero $totals 'BraveLocal') + (Get-TotalOrZero $totals 'BraveRoot')
$totalOpera = (Get-TotalOrZero $totals 'OperaLocal') + (Get-TotalOrZero $totals 'OperaRoaming') + (Get-TotalOrZero $totals 'OperaRoot')
$totalOperaGX = (Get-TotalOrZero $totals 'OperaGXLocal') + (Get-TotalOrZero $totals 'OperaGXRoaming') + (Get-TotalOrZero $totals 'OperaGXRoot')
$totalVivaldi = (Get-TotalOrZero $totals 'VivaldiLocal') + (Get-TotalOrZero $totals 'VivaldiRoaming') + (Get-TotalOrZero $totals 'VivaldiRoot')
$grandTotal = $totalWindows + $totalFirefox + $totalChrome + $totalEdge + $totalBrave + $totalOpera + $totalOperaGX + $totalVivaldi
# Affichage formaté
$sizesWindows = Convert-Bytes $totalWindows
$sizesFirefox = Convert-Bytes $totalFirefox
$sizesChrome = Convert-Bytes $totalChrome
$sizesEdge = Convert-Bytes $totalEdge
$sizesBrave = Convert-Bytes $totalBrave
$sizesOpera = Convert-Bytes $totalOpera
$sizesOperaGX = Convert-Bytes $totalOperaGX
$sizesVivaldi = Convert-Bytes $totalVivaldi
$sizesTotal = Convert-Bytes $grandTotal

# $winMo = $sizesWindows.Mo; $winGo = $sizesWindows.Go
# $ffMo = $sizesFirefox.Mo; $ffGo = $sizesFirefox.Go
# $chromeMo = $sizesChrome.Mo; $chromeGo = $sizesChrome.Go
# $edgeMo = $sizesEdge.Mo; $edgeGo = $sizesEdge.Go
# $braveMo = $sizesBrave.Mo; $braveGo = $sizesBrave.Go
# $operaMo = $sizesOpera.Mo; $operaGo = $sizesOpera.Go
# $operaGXMo = $sizesOperaGX.Mo; $operaGXGo = $sizesOperaGX.Go
# $vivaldiMo = $sizesVivaldi.Mo; $vivaldiGo = $sizesVivaldi.Go
# $totalMo = $sizesTotal.Mo; $totalGo = $sizesTotal.Go
$duration = (Get-Date) - $startTime
# Write-Host "$duration"
${durationSeconds} = [math]::Round($duration.TotalSeconds, 2)
# --- Résumé final (cadre aligné) ---
Write-Host ""
$boxInner = 63
$boxTop = "╔" + ("═" * $boxInner) + "╗"
$boxSep = "╠" + ("═" * $boxInner) + "╣"
$boxBottom = "╚" + ("═" * $boxInner) + "╝"

function Write-BoxLine($text) {
    $padded = $text.PadRight($boxInner)
    Write-Host ("║" + $padded + "║") -ForegroundColor Magenta
}
function Write-BoxLineWithValue($label, $valueText) {
    $valueWidth = Get-DisplayWidth $valueText
    $labelWidth = [math]::Max(0, $boxInner - $valueWidth)
    $labelStr = PadRight-Display $label $labelWidth
    # Compensation spécifique pour l'emoji ⏱ (certaines consoles le comptent sur 1 colonne)
    if ($label -and $label.Contains([char]0x23F1)) { $labelStr += ' ' }
    Write-Host "║" -ForegroundColor Magenta -NoNewline
    Write-Host $labelStr -NoNewline
    Write-Host $valueText -NoNewline -ForegroundColor Green
    Write-Host "║" -ForegroundColor Magenta
}
function Get-DisplayWidth($text) {
    if (-not $text) { return 0 }
    $width = 0
    $i = 0
    while ($i -lt $text.Length) {
        $ch = $text[$i]
        # Surrogate pair (emoji probable) => compter 2 colonnes
        if ([char]::IsHighSurrogate($ch) -and ($i + 1 -lt $text.Length) -and [char]::IsLowSurrogate($text[$i + 1])) {
            $width += 2
            $i += 2
            continue
        }
        # Quelques symboles unicode larges simples
        $code = [int][char]$ch
        if (
            ($code -ge 0x1100) -or 
            ($code -ge 0x2600 -and $code -le 0x27FF) -or 
            ($code -ge 0x2300 -and $code -le 0x23FF)
        ) {
            $width += 2
        }
        else {
            $width += 1
        }
        $i += 1
    }
    return $width
}
function PadRight-Display($text, $totalWidth) {
    $current = Get-DisplayWidth $text
    if ($current -eq $totalWidth) { return $text }
    if ($current -lt $totalWidth) {
        return $text + (' ' * ($totalWidth - $current))
    }
    # Si dépasse, tronquer sans couper une paire surrogate
    $acc = ''
    $w = 0
    $i = 0
    while ($i -lt $text.Length -and $w -lt $totalWidth) {
        $ch = $text[$i]
        if ([char]::IsHighSurrogate($ch) -and ($i + 1 -lt $text.Length) -and [char]::IsLowSurrogate($text[$i + 1])) {
            if ($w + 2 -gt $totalWidth) { break }
            $acc += ($text.Substring($i, 2))
            $w += 2
            $i += 2
            continue
        }
        $acc += $ch
        if (([int][char]$ch) -ge 0x1100) { $w += 2 } else { $w += 1 }
        $i += 1
    }
    return $acc
}
function Write-BoxRow($label, $mo, $go) {
    # Valeurs à largeur fixe, 2 décimales
    $numbersText = ("{0,10:N2} Mo  ({1,6:N2} Go) " -f $mo, $go)
    $numbersWidth = Get-DisplayWidth $numbersText
    $labelWidth = [math]::Max(0, $boxInner - $numbersWidth)
    $labelStr = PadRight-Display $label $labelWidth

    Write-Host "║" -ForegroundColor Magenta -NoNewline
    Write-Host $labelStr -NoNewline
    Write-Host $numbersText -NoNewline -ForegroundColor Green
    Write-Host "║" -ForegroundColor Magenta
}

Write-Host $boxTop -ForegroundColor Magenta
Write-BoxLine "                     RÉSUMÉ DE L'ANALYSE"
Write-Host $boxSep -ForegroundColor Magenta
Write-BoxRow " 🪟🪟🪟🪟   Windows (Temp & Cache) :" $sizesWindows.Mo $sizesWindows.Go
Write-BoxRow " 🦊🦊🦊🦊   Firefox (Total)        :" $sizesFirefox.Mo $sizesFirefox.Go
Write-BoxRow " 🔵🔴🟡🟢   Chrome                 :" $sizesChrome.Mo $sizesChrome.Go
Write-BoxRow " 🌊🌊🌊🌊   Edge                   :" $sizesEdge.Mo $sizesEdge.Go
Write-BoxRow " 🦁🦁🦁🦁   Brave                  :" $sizesBrave.Mo $sizesBrave.Go
Write-BoxRow " ⭕⭕⭕⭕   Opera                  :" $sizesOpera.Mo $sizesOpera.Go
Write-BoxRow " ⭕⭕⭕⭕   Opera GX               :" $sizesOperaGX.Mo $sizesOperaGX.Go
Write-BoxRow " 🔴🔴🔴🔴   Vivaldi                :" $sizesVivaldi.Mo $sizesVivaldi.Go
Write-Host $boxSep -ForegroundColor Magenta
Write-BoxRow " 📊 TOTAL GÉNÉRAL                  :" $sizesTotal.Mo $sizesTotal.Go
Write-BoxLineWithValue " ⏱  TEMPS D'EXÉCUTION              :"  ("{0:N2} s " -f $durationSeconds)
Write-Host $boxBottom -ForegroundColor Magenta
Write-Host ""