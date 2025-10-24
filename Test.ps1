# $dossiers = @(
#     "$env:WINDIR\Temp",
#     "$env:TEMP",
#     "$env:WINDIR\SoftwareDistribution\Download",
#     "$env:WINDIR\Logs\CBS",
#     "$env:WINDIR\Prefetch",
#     "$env:WINDIR\WinSxS\Temp",
#     "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
#     "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*",
#     "$env:LOCALAPPDATA\Microsoft\Windows\WebCache",
#     "$env:WINDIR\Downloaded Program Files",
#     "$env:PROGRAMDATA\Microsoft\Windows\Caches"
# )
# $total = 0

############################
# --- Firefox ---
$firefoxTargets = @()
$firefoxProfilesRoot = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfilesRoot) {
    $firefoxProfiles = Get-ChildItem -Path $firefoxProfilesRoot -Directory
    foreach ($profil in $firefoxProfiles) {
        $profilePath = Join-Path $firefoxProfilesRoot $profil.Name
        $firefoxTargets += Join-Path $profilePath "cache2"
        $firefoxTargets += Join-Path $profilePath "startupCache"
        $firefoxTargets += Join-Path $profilePath "cookies.sqlite"
        $firefoxTargets += Join-Path $profilePath "places.sqlite"
        $firefoxTargets += Join-Path $profilePath "jumpListCache"
        $firefoxTargets += Join-Path $profilePath "startupCache"
        $firefoxTargets += Join-Path $profilePath "offlineCache"
    }
}
############################
# --- Google Chrome ---
$chromeTargets = @()
$chromeUserData = "$env:LOCALAPPDATA\Google\Chrome\User Data"
if (Test-Path $chromeUserData) {
    $chromeProfiles = Get-ChildItem -Path $chromeUserData -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -like "Profile *"
    }
    foreach ($profil in $chromeProfiles) {
        $profilePath = Join-Path $chromeUserData $profil.Name
        $chromeTargets += Join-Path $profilePath "Cache"
        $chromeTargets += Join-Path $profilePath "Cookies"
        $chromeTargets += Join-Path $profilePath "History"
        $chromeTargets += Join-Path $profilePath "Network Action Predictor"
        $chromeTargets += Join-Path $profilePath "Top Sites"
        $chromeTargets += Join-Path $profilePath "Visited Links"
        $chromeTargets += Join-Path $profilePath "Downloads"
    }
}
############################
# --- Edge ---
$edgeTargets = @()
$edgeUserData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
if (Test-Path $edgeUserData) {
    $edgeProfiles = Get-ChildItem -Path $edgeUserData -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -like "Profile *"
    }
    foreach ($profil in $edgeProfiles) {
        $profilePath = Join-Path $edgeUserData $profil.Name
        $edgeTargets += Join-Path $profilePath "Cookies"
        $edgeTargets += Join-Path $profilePath "Cache"
        $edgeTargets += Join-Path $profilePath "History"
        $edgeTargets += Join-Path $profilePath "Network Action Predictor"
        $edgeTargets += Join-Path $profilePath "Top Sites"
        $edgeTargets += Join-Path $profilePath "Visited Links"
        $edgeTargets += Join-Path $profilePath "Downloads"
    }
}
############################
# --- Opera ---
$operaTargets = @()
$operaUserData = "$env:APPDATA\Opera Software\Opera Stable"
if (Test-Path $operaUserData) {
    # Opera ne gère qu'un profil principal par défaut
    $operaTargets += Join-Path $operaUserData "Cache"
    $operaTargets += Join-Path $operaUserData "Cookies"
    $operaTargets += Join-Path $operaUserData "History"
    $operaTargets += Join-Path $operaUserData "Network Action Predictor"
    $operaTargets += Join-Path $operaUserData "Top Sites"
    $operaTargets += Join-Path $operaUserData "Visited Links"
    $operaTargets += Join-Path $operaUserData "Downloads"
}
############################
# --- Brave ---
$braveTargets = @()
$braveUserData = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
if (Test-Path $braveUserData) {
    $braveProfiles = Get-ChildItem -Path $braveUserData -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -like "Profile *"
    }
    foreach ($profil in $braveProfiles) {
        $profilePath = Join-Path $braveUserData $profil.Name
        $braveTargets += Join-Path $profilePath "Cache"
        $braveTargets += Join-Path $profilePath "Cookies"
        $braveTargets += Join-Path $profilePath "History"
        $braveTargets += Join-Path $profilePath "Network Action Predictor"
        $braveTargets += Join-Path $profilePath "Top Sites"
        $braveTargets += Join-Path $profilePath "Visited Links"
        $braveTargets += Join-Path $profilePath "Downloads"
    }
}
############################
# --- Vivaldi ---
$vivaldiTargets = @()
$vivaldiUserData = "$env:LOCALAPPDATA\Vivaldi\User Data"
if (Test-Path $vivaldiUserData) {
    $vivaldiProfiles = Get-ChildItem -Path $vivaldiUserData -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -like "Profile *"
    }
    foreach ($profil in $vivaldiProfiles) {
        $profilePath = Join-Path $vivaldiUserData $profil.Name
        $vivaldiTargets += Join-Path $profilePath "Cache"
        $vivaldiTargets += Join-Path $profilePath "Cookies"
        $vivaldiTargets += Join-Path $profilePath "History"
        $vivaldiTargets += Join-Path $profilePath "Network Action Predictor"
        $vivaldiTargets += Join-Path $profilePath "Top Sites"
        $vivaldiTargets += Join-Path $profilePath "Visited Links"
        $vivaldiTargets += Join-Path $profilePath "Downloads"
    }
}
############################
# --- Arc Browser ---
$arcTargets = @()
$arcUserData = "$env:LOCALAPPDATA\Arc\User Data"
if (Test-Path $arcUserData) {
    $arcProfiles = Get-ChildItem -Path $arcUserData -Directory | Where-Object {
        $_.Name -eq "Default" -or $_.Name -like "Profile *"
    }
    foreach ($profil in $arcProfiles) {
        $profilePath = Join-Path $arcUserData $profil.Name
        $arcTargets += Join-Path $profilePath "Cache"
        $arcTargets += Join-Path $profilePath "Cookies"
        $arcTargets += Join-Path $profilePath "History"
        $arcTargets += Join-Path $profilePath "Network Action Predictor"
        $arcTargets += Join-Path $profilePath "Top Sites"
        $arcTargets += Join-Path $profilePath "Visited Links"
        $arcTargets += Join-Path $profilePath "Downloads"
    }
}

# --- Calculs & Affichage ---

function Show-TargetTotals($name, $targets, $color) {
    Write-Host "`n--- $name ---" -ForegroundColor $color
    $total = 0
    foreach ($target in $targets) {
        $size = (Get-ChildItem $target -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $mo = "{0:N2}" -f ($size / 1MB)
        Write-Host "$target : $mo Mo" -ForegroundColor Cyan
        $total += $size
    }
    $totalMo = "{0:N2}" -f ($total / 1MB)
    Write-Host "------------------------------"
    Write-Host "Total $name : $totalMo Mo" -ForegroundColor Yellow
    return $total
}

$totals = @{}
$totals.Firefox = Show-TargetTotals "Firefox"  $firefoxTargets  "Green"
$totals.Chrome = Show-TargetTotals "Chrome"   $chromeTargets   "Green"
$totals.Edge = Show-TargetTotals "Edge"     $edgeTargets     "Green"
$totals.Brave = Show-TargetTotals "Brave"    $braveTargets    "Green"
$totals.Vivaldi = Show-TargetTotals "Vivaldi"  $vivaldiTargets  "Green"
$totals.Opera = Show-TargetTotals "Opera"    $operaTargets    "Green"
$totals.Arc = Show-TargetTotals "Arc"      $arcTargets      "Green"

$allTotal = ($totals.Firefox + $totals.Chrome + $totals.Edge + $totals.Brave + $totals.Vivaldi + $totals.Opera + $totals.Arc)
$allTotalMo = "{0:N2}" -f ($allTotal / 1MB)
Write-Host "------------------------------"
Write-Host "Total Tous Navigateurs : $allTotalMo Mo" -ForegroundColor Magenta
Write-Host "------------------------------"












# --- Affichage de la liste globale ---
# Write-Host "`n--- Chrome ---" -ForegroundColor Green
# $totalChrome = 0
# foreach ($target in $chromeTargets) {
#     $size = (Get-ChildItem -Path $target -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
#     $mo = "{0:N2}" -f ($size / 1MB)
#     Write-Host "$target : $mo Mo" -ForegroundColor Cyan
#     $totalChrome += $size
# }
# $totalMoChrome = "{0:N2}" -f ($totalChrome / 1MB)
# Write-Host "------------------------------"
# Write-Host "Total : $totalMoChrome Mo" -ForegroundColor Yellow

# Write-Host "`n--- Firefox ---" -ForegroundColor Green
# $totalFirefox = 0
# foreach ($target in $firefoxTargets) {
#     $size = (Get-ChildItem -Path $target -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
#     $mo = "{0:N2}" -f ($size / 1MB)
#     Write-Host "$target : $mo Mo" -ForegroundColor Cyan
#     $totalFirefox += $size
# }
# $totalMoFirefox = "{0:N2}" -f ($totalFirefox / 1MB)
# Write-Host "------------------------------"
# Write-Host "Total : $totalMoFirefox Mo" -ForegroundColor Yellow

# Write-Host "`n--- Edge ---" -ForegroundColor Green
# $totalEdge = 0
# foreach ($target in $edgeTargets) {
#     $size = (Get-ChildItem -Path $target -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
#     $mo = "{0:N2}" -f ($size / 1MB)
#     Write-Host "$target : $mo Mo" -ForegroundColor Cyan
#     $totalEdge += $size
# }
# $totalMoEdge = "{0:N2}" -f ($totalEdge / 1MB)
# Write-Host "------------------------------"
# Write-Host "Total : $totalMoEdge Mo" -ForegroundColor Yellow

# $allTotal = $totalChrome + $totalFirefox + $totalEdge
# $allTotalMo = "{0:N2}" -f ($allTotal / 1MB)


# Write-Host "------------------------------"
# Write-Host "Total All Browser : $allTotalMo Mo" -ForegroundColor Yellow
# Write-Host "     Chrome All Profile  : $totalMoChrome Mo" -ForegroundColor Yellow
# Write-Host "     Firefox All Profile : $totalMoFirefox Mo" -ForegroundColor Yellow
# Write-Host "     Edge All Profile    : $totalMoEdge Mo" -ForegroundColor Yellow
# Write-Host "------------------------------"
# /!\ supprime les fichiers /!\
# foreach ($item in $chromeTargets + $firefoxTargets) {
#     Remove-Item $item -Recurse -Force -ErrorAction SilentlyContinue
# }