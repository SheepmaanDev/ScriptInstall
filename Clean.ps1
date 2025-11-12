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
$localLowPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\LocalLow"
$programFilesX86 = $env:ProgramFiles + " (x86)"
# ====================================
# Applications
# ====================================
# --- --- Adobe Acrobat --- ---
$adobePath = "$LocalLowPath\Adobe\Acrobat\DC"
$adobePathWeb = "$LocalLowPath\Adobe\AcroCef\DC"
$adobeTargets = @(
    "$adobePath\ConnectorIcons",
    "$adobePathWeb\Acrobat\Cache\Cache",
    "$adobePathWeb\Acrobat\Cache\Code Cache"
)
# --- --- Node.js --- ---
$nodeCachePath = "$env:LOCALAPPDATA\npm-cache"
$nodeTargets = @(
    $nodeCachePath
)
# --- --- OneDrive --- --- 
$onedrivePathInst = "$env:LOCALAPPDATA\Microsoft\OneDrive\setup\logs"
$onedrivePathSync = "$env:LOCALAPPDATA\Microsoft\OneDrive\logs\ListSync\Business1"
$onedriveTargets = @(
    $onedrivePathInst,
    $onedrivePathSync
)
# --- --- Steam --- ---
$steamPath = "$programFilesX86\Steam\Logs"
$steamTargets = @(
    "$steamPath"
)
# ====================================
# Navigateurs
# ====================================
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
# ====================================
# Windows
# ====================================
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
function Write-BoxLine($text) {
    $padded = $text.PadRight($boxInner)
    Write-Host ("║" + $padded + "║") -ForegroundColor Magenta
}
function Write-BoxLineWithValue($label, $valueText) {
    $valueWidth = Get-DisplayWidth $valueText
    $labelWidth = [math]::Max(0, $boxInner - $valueWidth)
    $labelStr = Format-DisplayPad $label $labelWidth
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
            $code -eq 0x200D -or # Zero Width Joiner
            ($code -ge 0xFE00 -and $code -le 0xFE0F) # Variation Selectors
        ) {
            $i += 1
            continue
        }
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
function Format-DisplayPad($text, $totalWidth) {
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
    $labelStr = Format-DisplayPad $label $labelWidth

    Write-Host "║" -ForegroundColor Magenta -NoNewline
    Write-Host $labelStr -NoNewline
    Write-Host $numbersText -NoNewline -ForegroundColor Green
    Write-Host "║" -ForegroundColor Magenta
}
# ========================================
# EXECUTION DES FONCTIONS
# ========================================
$startTime = Get-Date
# ====================================
# Applications
# ====================================
$adobeLocal = $adobeTargets
# ====================================
# Navigateurs
# ====================================
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

# --- Calculs et agrégations ---
$targetGroups = @(
    [pscustomobject]@{ Key = 'AdobeReader'; Name = 'Adobe Acrobat Reader'; Targets = $adobeLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'NodeCache'; Name = 'Node.js Cache'; Targets = $nodeTargets; Color = 'Green' },
    [pscustomobject]@{ Key = 'OneDrive'; Name = 'OneDrive Logs'; Targets = $onedriveTargets; Color = 'Green' },
    [pscustomobject]@{ Key = 'Steam'; Name = 'Steam Logs'; Targets = $steamTargets; Color = 'Green' },
    [pscustomobject]@{ Key = 'Windows'; Name = 'Windows Temp & Cache'; Targets = $winTargets; Color = 'Green' },
    [pscustomobject]@{ Key = 'FirefoxLocal'; Name = 'Firefox Local'; Targets = $firefoxLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'FirefoxRoaming'; Name = 'Firefox Roaming'; Targets = $firefoxRoaming; Color = 'Green' },
    [pscustomobject]@{ Key = 'EdgeRoot'; Name = 'Edge Root'; Targets = $edgeRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'EdgeLocal'; Name = 'Edge Profil'; Targets = $edgeLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'ChromeRoot'; Name = 'Chrome Root'; Targets = $chromeRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'ChromeLocal'; Name = 'Chrome Profil'; Targets = $chromeLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'BraveRoot'; Name = 'Brave Root'; Targets = $braveRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'BraveLocal'; Name = 'Brave Local'; Targets = $braveLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaRoot'; Name = 'Opera Root'; Targets = $operaRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaLocal'; Name = 'Opera Local'; Targets = $operaLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaRoaming'; Name = 'Opera Roaming'; Targets = $operaRoaming; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaGXRoot'; Name = 'Opera GX Root'; Targets = $operaGXRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaGXLocal'; Name = 'Opera GX Local'; Targets = $operaGXLocal; Color = 'Green' },
    [pscustomobject]@{ Key = 'OperaGXRoaming'; Name = 'Opera GX Roaming'; Targets = $operaGXRoaming; Color = 'Green' },
    [pscustomobject]@{ Key = 'VivaldiRoot'; Name = 'Vivaldi Root'; Targets = $vivaldiRoot; Color = 'Green' },
    [pscustomobject]@{ Key = 'VivaldiLocal'; Name = 'Vivaldi Local'; Targets = $vivaldiLocal; Color = 'Green' }
)

$totals = @{}
foreach ($group in $targetGroups) {
    $totals[$group.Key] = Show-TargetTotals $group.Name $group.Targets $group.Color
}

$summaryConfig = @(
    [pscustomobject]@{ Label = " 📄📄📄📄   Adobe Acrobat Reader   :"; Keys = @('AdobeReader'); IsBrowser = $false },
    [pscustomobject]@{ Label = " 🟢🟢🟢🟢   Node.js                :"; Keys = @('NodeCache'); IsBrowser = $false },
    [pscustomobject]@{ Label = " ☁️☁️☁️☁️   OneDrive               :"; Keys = @('OneDrive'); IsBrowser = $false },
    [pscustomobject]@{ Label = " 🎮🎮🎮🎮   Steam                  :"; Keys = @('Steam'); IsBrowser = $false },
    [pscustomobject]@{ Label = " 🪟🪟🪟🪟   Windows                :"; Keys = @('Windows'); IsBrowser = $false },
    [pscustomobject]@{ Label = " 🦊🦊🦊🦊   Firefox                :"; Keys = @('FirefoxLocal', 'FirefoxRoaming'); IsBrowser = $true },
    [pscustomobject]@{ Label = " 🔵🔴🟡🟢   Chrome                 :"; Keys = @('ChromeLocal', 'ChromeRoot'); IsBrowser = $true },
    [pscustomobject]@{ Label = " 🌊🌊🌊🌊   Edge                   :"; Keys = @('EdgeLocal', 'EdgeRoot'); IsBrowser = $true },
    [pscustomobject]@{ Label = " 🦁🦁🦁🦁   Brave                  :"; Keys = @('BraveLocal', 'BraveRoot'); IsBrowser = $true },
    [pscustomobject]@{ Label = " ⭕⭕⭕⭕   Opera                  :"; Keys = @('OperaLocal', 'OperaRoot', 'OperaRoaming'); IsBrowser = $true },
    [pscustomobject]@{ Label = " ⭕⭕⭕⭕   Opera GX               :"; Keys = @('OperaGXLocal', 'OperaGXRoot', 'OperaGXRoaming'); IsBrowser = $true },
    [pscustomobject]@{ Label = " 🔴🔴🔴🔴   Vivaldi                :"; Keys = @('VivaldiLocal', 'VivaldiRoot'); IsBrowser = $true }
)

$summaryRowsData = foreach ($row in $summaryConfig) {
    $bytes = 0
    foreach ($key in $row.Keys) {
        $bytes += Get-TotalOrZero $totals $key
    }
    $sizes = Convert-Bytes $bytes
    [pscustomobject]@{
        Label     = $row.Label
        Mo        = $sizes.Mo
        Go        = $sizes.Go
        Bytes     = [double]$bytes
        IsBrowser = $row.IsBrowser
    }
}

$allTotalNavBytes = ($summaryRowsData | Where-Object { $_.IsBrowser } | Measure-Object -Property Bytes -Sum).Sum
if ($null -eq $allTotalNavBytes) { $allTotalNavBytes = 0 }
$navSizes = Convert-Bytes $allTotalNavBytes

$grandTotalBytes = ($summaryRowsData | Measure-Object -Property Bytes -Sum).Sum
if ($null -eq $grandTotalBytes) { $grandTotalBytes = 0 }
$sizesTotal = Convert-Bytes $grandTotalBytes

$duration = (Get-Date) - $startTime
${durationSeconds} = [math]::Round($duration.TotalSeconds, 2)

# --- Affichage ---
Write-Host "------------------------------"
Write-Host ("Total de tous les navigateurs : {0:N2} Mo ({1:N2} Go)" -f $navSizes.Mo, $navSizes.Go) -ForegroundColor Magenta
Write-Host "------------------------------"
# --- Résumé final (cadre aligné) ---
Write-Host ""
$boxInner = 63
$boxTop = "╔" + ("═" * $boxInner) + "╗"
$boxSep = "╠" + ("═" * $boxInner) + "╣"
$boxBottom = "╚" + ("═" * $boxInner) + "╝"
Write-Host $boxTop -ForegroundColor Magenta
Write-BoxLine "                     RÉSUMÉ DE L'ANALYSE"
Write-Host $boxSep -ForegroundColor Magenta
foreach ($row in $summaryRowsData) {
    Write-BoxRow $row.Label $row.Mo $row.Go
}
Write-Host $boxSep -ForegroundColor Magenta
Write-BoxRow " 📊 TOTAL GÉNÉRAL                  :" $sizesTotal.Mo $sizesTotal.Go
Write-BoxLineWithValue " ⏱  TEMPS D'EXÉCUTION              :"  ("{0:N2} s " -f $durationSeconds)
Write-Host $boxBottom -ForegroundColor Magenta
Write-Host ""