# ========================================
# VERIFICATION PRIVILEGES ADMINISTRATEUR
# ========================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur. Redémarrage..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    exit
}
# ========================================
# DEFINITION DES VARIABLES
# ========================================
$link = "https://scsinformatique.com/script"
$dirInstall = "C:\Install"
$dirTemp = "$env:TEMP\scs"
$dirTempConf = "$dirTemp\conf"
$dirTempShortcut = "$dirTemp\raccourcis"
$Global:desktop = [System.Environment]::GetFolderPath('Desktop') # Emplacement du bureau
$userSID = (Get-WmiObject -Class Win32_UserAccount -Filter "Name='$env:USERNAME'").SID # Recuperation du SID de l'utilisateur
$RegistrySettings = @{
    'ADMINISTRATION' = @{}
    'RESEAUX'        = @{
        'RESETNETWORK' = @{
            Name    = "Réinitialisation des carte réseaux"
            Command = {
                netsh.exe int ip reset all
                netsh.exe winsock reset all
            }
        }
    }
    'SYSTEME'        = @{
        'BACKGROUNDAPP' = @{
            Desc         = "Désactivation des applications en arrière plan";
            Path         = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"; 
            Name         = "LetAppsRunInBackground"; 
            Value        = 0; 
            Type         = "DWORD"; 
            CreateParent = $true 
        }
        'RIGHTCLICK'    = @{
            Desc         = "Clique droit classique"; 
            Path         = "HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32"; 
            Name         = "(Default)"; 
            Value        = ""; 
            Type         = "String"; 
            CreateParent = $true 
        }
        'SYSTRAYOPEN'   = @{
            Desc =
        }
    }
    
}
# ========================================
# CREATION DES FONCTIONS COMMUNES
# ========================================
function Set-RegistrySettings {
    [Parameter(Mandatory = $true)]
    [array]$RegKeys,
    [Parameter(Mandatory = $true)]
    [ValidateSet("ADMINISTRATION", "RESEAUX", "SYSTEME")]
    [string]$Categories,
    [ValidateSet("BACKGROUNDAPP", "RIGHTCLICK")]
    [string]$SubCategories

    # Reglage registre
    foreach ($reg in $RegKeys) {
        # Créer le dossier parent si nécessaire
        if ($reg.CreateParent -and -not (Test-Path $reg.Path)) {
            New-Item -Path $reg.Path -Force | Out-Null
        }
    
        try {
            Write-Host "$(Get-Timestamp) - [INFO] - Réglage de : $($reg.Desc) en cours ..." -ForegroundColor White
            Set-ItemProperty -Path $reg.Path -Name $reg.Name -Value $reg.Value -Type $reg.Type -Force -ErrorAction Stop
            Write-Host "$(Get-Timestamp) - [SUCCESS] - Réglage de : $($reg.Desc) réussie" -ForegroundColor Green
        }
        catch {
            Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# ========================================
# CREATION DES FONCTIONS 
# ========================================
function Get-Timestamp {
    return Get-Date -Format "[dd/MM/yy HH:mm:ss]"
}
function Show-Logo {
    Clear-Host
    Write-Host "                @@@@@@@                   " -ForegroundColor Green
    Write-Host "               @@@ @@@@@@@                  /SSSSSS   /SSSSSS   /SSSSSS        /SSSSSS /SS   /SS /SSSSSSSS /SSSSSS " -ForegroundColor Green
    Write-Host "              @@@@@    @@@@                /SS__  SS /SS__  SS /SS__  SS      |_  SS_/| SSS | SS| SS_____//SS__  SS" -ForegroundColor Green
    Write-Host "             @ @@         @@              | SS  \__/| SS  \__/| SS  \__/        | SS  | SSSS| SS| SS     | SS  \ SS" -ForegroundColor Green
    Write-Host "            @ @@           @@             |  SSSSSS | SS      |  SSSSSS         | SS  | SS SS SS| SSSSS  | SS  | SS" -ForegroundColor Green
    Write-Host "           @@@@             @@             \____  SS| SS       \____  SS        | SS  | SS  SSSS| SS__/  | SS  | SS" -ForegroundColor Green
    Write-Host "           @ @     @@@@      @             /SS  \ SS| SS    SS /SS  \ SS        | SS  | SS\  SSS| SS     | SS  | SS" -ForegroundColor Green
    Write-Host "          @@ @    @@  @@@    @@           |  SSSSSS/|  SSSSSS/|  SSSSSS/       /SSSSSS| SS \  SS| SS     |  SSSSSS/" -ForegroundColor Green
    Write-Host "          @ @@   @@     @     @            \______/  \______/  \______/       |______/|__/  \__/|__/      \______/ " -ForegroundColor Green
    Write-Host "          @ @    @       @    @           " -ForegroundColor Green
    Write-Host "          @ @@   @@ @    @    @                          ╔══════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "          @  @    @@@    @    @                          ║        GESTIONNAIRE DE SCRIPT        ║" -ForegroundColor Green
    Write-Host "          @  @           @    @                          ╠══════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "          @@ @@         @@   @@                          ║  [S] - Système                       ║" -ForegroundColor Green
    Write-Host "           @  @@        @    @                           ║  [R] - Réseaux                       ║" -ForegroundColor Green
    Write-Host "           @@  @@     @@@   @@                           ║  [A] - Administration                ║" -ForegroundColor Green
    Write-Host "            @   @@@@@@@     @                            ║  [ ] -                               ║" -ForegroundColor Green
    Write-Host "             @             @                             ║  [Q] - Quitter                       ║" -ForegroundColor Green
    Write-Host "              @@         @@                              ╚══════════════════════════════════════╝" -ForegroundColor Green
    Write-Host "               @@@     @@@                " -ForegroundColor Green
    Write-Host "                 @@@@@@@                  " -ForegroundColor Green
}
function Delete-CacheWinUpdate {
    Stop-Service -Name wuauserv, bits, cryptsvc, msiserver -Force
    Remove-Item "$env:windir\SoftwareDistribution" -Recurse -Force
    Remove-Item "$env:windir\System32\catroot2" -Recurse -Force
    Start-Service -Name wuauserv, bits, cryptsvc, msiserver

}
function a {}
function b {}
function c {}
function d {}
function e {}
function f {}
function g {}
function h {}
function i {}
function j {}
function k {}
function l {}
function m {}
function n {}
function o {}
function p {}
function q {}
function r {}
function Systray {
    $RegistryPath = 'HKCU:\Control Panel\NotifyIconSettings'
    $Name = 'IsPromoted'
    $Value = '1'
    Get-ChildItem -path $RegistryPath -Recurse | ForEach-Object { New-ItemProperty -Path $_.PSPath -Name $Name -Value $Value -PropertyType DWORD -Force }
}
function t {}
function u {}
function v {}
function w {}
function x {}
function y {}
function z {}




# ========================================
# EXECUTION DES FONCTIONS
# ========================================
do {
    Show-Logo
    $choice = Read-Host "Votre choix"
    $choice = $choice.Trim().ToUpper()
    
    switch ($choice) {
        'A' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🚀 Installation en cours..." -ForegroundColor Magenta
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'R' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🔧 Configuration de l'utilisateur en cours..." -ForegroundColor Magenta
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'S' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🧹 Installation des outils de nettoyage en cours..." -ForegroundColor Magenta
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'D' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🗑️ Désinstallation en cours..." -ForegroundColor Magenta
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'Q' {
            Write-Host "$(Get-Timestamp) - [INFO] - Au revoir !" -ForegroundColor White
            break
        }
        default {
            Write-Host "$(Get-Timestamp) - [ERROR] - ❌ Choix invalide !" -ForegroundColor Red
            Start-Sleep 2
        }
    }
} while ($choice -notin @('A', 'R', 'S', 'D', 'Q'))

function RegistrySettings {
    [Parameter(Mandatory = $true)]
    [array]$RegKey
    # Reglage registre
    foreach ($reg in $RegKey) {
        # Créer le dossier parent si nécessaire
        if ($reg.CreateParent -and -not (Test-Path $reg.Path)) {
            New-Item -Path $reg.Path -Force | Out-Null
        }
    
        try {
            Write-Host "$(Get-Timestamp) - [INFO] - Réglage de : $($reg.Desc) en cours ..." -ForegroundColor White
            Set-ItemProperty -Path $reg.Path -Name $reg.Name -Value $reg.Value -Type $reg.Type -Force -ErrorAction Stop
            Write-Host "$(Get-Timestamp) - [SUCCESS] - Réglage de : $($reg.Desc) réussie" -ForegroundColor Green
        }
        catch {
            Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

"C:\Windows\Temp" "$env:WINDIR\Temp"
"%TEMP%" "$env:TMP"
"C:\Windows\SoftwareDistribution\Download" "$env:WINDIR\SoftwareDistribution\Download"
"C:\Windows\Logs\CBS" "$env:WINDIR\Logs\CBS"
"C:\Windows\Prefetch" "$env:WINDIR\Prefetch"
"C:\Windows\WinSxS\Temp" "$env:WINDIR\WinSxS\Temp"

"C:\Users\%Username%\AppData\Local\Microsoft\Windows\INetCache" "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
"C:\Users\%Username%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*" "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*"
"C:\Users\%Username%\AppData\Local\Microsoft\Windows\WebCache" "$env:LOCALAPPDATA\Microsoft\Windows\WebCache"

"C:\Windows\Downloaded Program Files" "$env:WINDIR\Downloaded Program Files"
"C:\ProgramData\Microsoft\Windows\Caches" "$env:PROGRAMDATA\Microsoft\Windows\Caches"