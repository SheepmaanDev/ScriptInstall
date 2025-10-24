$dossiers = @(
    "$env:WINDIR\Temp",
    "$env:TEMP",
    "$env:WINDIR\SoftwareDistribution\Download",
    "$env:WINDIR\Logs\CBS",
    "$env:WINDIR\Prefetch",
    "$env:WINDIR\WinSxS\Temp",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*",
    "$env:LOCALAPPDATA\Microsoft\Windows\WebCache",
    "$env:WINDIR\Downloaded Program Files",
    "$env:PROGRAMDATA\Microsoft\Windows\Caches"
)
$total = 0

foreach ($dossier in $dossiers) {
    $size = (Get-ChildItem -Path $dossier -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $mo = "{0:N2}" -f ($size / 1MB)
    Write-Host "$dossier : $mo Mo" -ForegroundColor Cyan
    $total += $size
}

$totalMo = "{0:N2}" -f ($total / 1MB)
Write-Host "------------------------------"
Write-Host "Total : $totalMo Mo" -ForegroundColor Yellow

$googleChrome = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", # Si autre profile remplacer "Default" par "Profile 1"/ "Profile 2"/ etc
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History"
)
$totalChrome = 0

foreach ($dossier in $googleChrome) {
    $size = (Get-ChildItem -Path $dossier -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $mo = "{0:N2}" -f ($size / 1MB)
    Write-Host "$dossier : $mo Mo" -ForegroundColor Cyan
    $totalChrome += $size
}

$totalMoChrome = "{0:N2}" -f ($totalChrome / 1MB)
Write-Host "------------------------------"
Write-Host "Total : $totalMoChrome Mo" -ForegroundColor Yellow


# Chemin du dossier Chrome pour l'utilisateur courant
$userDataDir = "$env:LOCALAPPDATA\Google\Chrome\User Data"
# Liste tous les profils (Default & Profile N)
$profiles = Get-ChildItem -Path $userDataDir -Directory | Where-Object {
    $_.Name -eq "Default" -or $_.Name -like "Profile *"
}

# Crée la liste complète des dossiers/fichiers à supprimer pour chaque profil
$targets = @()
foreach ($profil in $profiles) {
    $profilePath = Join-Path $userDataDir $profil.Name

    $targets += Join-Path $profilePath "Cache"
    $targets += Join-Path $profilePath "Cookies"       # Fichier SQLite
    $targets += Join-Path $profilePath "History"       # Fichier SQLite
    $targets += Join-Path $profilePath "Network Action Predictor"
    $targets += Join-Path $profilePath "Top Sites"
    $targets += Join-Path $profilePath "Visited Links"
    $targets += Join-Path $profilePath "Downloads"     # pour les fichiers de téléchargements internes à Chrome
    # Tu peux ajouter/répéter selon d'autres fichiers spécifiques à traiter
}

# Affichage de tous les dossiers/fichiers trouvés
# $targets | ForEach-Object { Write-Host $_ }
$totalChromeTest = 0
foreach ($target in $targets) {
    $size = (Get-ChildItem -Path $target -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $mo = "{0:N2}" -f ($size / 1MB)
    Write-Host "$target : $mo Mo" -ForegroundColor Cyan
    $totalChromeTest += $size
}
$totalMoChromeTest = "{0:N2}" -f ($totalChromeTest / 1MB)
Write-Host "------------------------------"
Write-Host "Total : $totalMoChromeTest Mo" -ForegroundColor Yellow


Write-Host "------------------------------------------------------------------"
Write-Host "Total Windows : $totalMo Mo" -ForegroundColor Yellow
Write-Host "Total Chrome Default : $totalMoChrome Mo" -ForegroundColor Yellow
Write-Host "Total Chrome All Profile : $totalMoChromeTest Mo" -ForegroundColor Yellow