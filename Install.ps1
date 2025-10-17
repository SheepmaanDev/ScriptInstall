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
$filesDownload = @(
    @{
        name            = "Arreter.ico";
        location        = $dirTempShortcut;
        hash            = "5FBB5C3B5BF08F6E014D65A870FB08850D45491DEF50EC8441A2D035D91969EF";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Arreter.ico" -OutFile "$dirTempShortcut\Arreter.ico" }
    },
    @{
        name            = "Arreter.lnk";
        location        = $dirTempShortcut;
        hash            = "CEFDD37B0772DA0AC29ED7DEA4A7795B3F01AC258BF73DCEA73EB70F24F81CBC";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Arreter.lnk" -OutFile "$dirTempShortcut\Arreter.lnk" }
    },
    @{
        name            = "ccleaner.ini";
        location        = $dirTempConf;
        hash            = "0EE58F378BEEF1C4D168D9497625774BAFC652902E510141C296969F43BE59C7";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/ccleaner/ccleaner.ini" -OutFile "$dirTempConf\ccleaner.ini" }
    },
    @{
        name            = "CuteWriter.inf";
        location        = $dirTempConf;
        hash            = "B8D9F8A12DCD1A3FE0C7446504D0B3930B3443734C940F5217F01F1A41585471";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/cutewriter/CuteWriter.inf" -OutFile "$dirTempConf\CuteWriter.inf" }
    },
    @{
        name            = "Deconnexion.ico";
        location        = $dirTempShortcut;
        hash            = "ECE2ACC473C2EB35C61A04A6E00449E4D96D9A4CF764DF31AF10BB486FEAF145";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Deconnexion.ico" -OutFile "$dirTempShortcut\Deconnexion.ico" }
    },
    @{
        name            = "Deconnexion.lnk";
        location        = $dirTempShortcut;
        hash            = "7C4A6260BCB3EEACFB8DF2D474AA211F6607AB62678BDBFF1E1F7332BC5F61D7";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Deconnexion.lnk" -OutFile "$dirTempShortcut\Deconnexion.lnk" }
    },
    @{
        name            = "French.dll";
        location        = $dirTempConf;
        hash            = "4597C97A0A5341BAD6A3B5AB0BBBE02F442256206CC064AB54D8EDED8E4B502F";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/irfanview/French.dll" -OutFile "$dirTempConf\French.dll" }
    },
    @{
        name            = "I_view64.ini";
        location        = $dirTempConf;
        hash            = "F6274DDFA51F6E9395F450C7F6ABE731B65D91C979A3592DDE35EF84CE56034C";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/irfanview/i_view64.ini" -OutFile "$dirTempConf\i_view64.ini" }
    },
    @{
        name            = "IP_French.lng";
        location        = $dirTempConf;
        hash            = "535874125BA092D5AE9CC97DA0F296505C57522053C22B149A44187915D385AE";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/irfanview/IP_French.lng" -OutFile "$dirTempConf\IP_French.lng" }
    },
    @{
        name            = "Presentation.lnk";
        location        = $dirTempShortcut;
        hash            = "825A74942A2AAC839701664973AB193033FD0033A30118880485B756AEAE3204";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Presentation.lnk" -OutFile "$dirTempShortcut\Presentation.lnk" }
    },
    @{
        name            = "Redemarrer.ico";
        location        = $dirTempShortcut;
        hash            = "7C0107A2BD36297E636F593366BEE9F309783AE08072432BA63E85474C8DBC15";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Redemarrer.ico" -OutFile "$dirTempShortcut\Redemarrer.ico" }
    },
    @{
        name            = "Redemarrer.lnk";
        location        = $dirTempShortcut;
        hash            = "4251A0DC23A1C1FE5F3CC01E8F2FAE0A8D26A4938DFE71FAD49FFD7A78FB7AD2";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Redemarrer.lnk" -OutFile "$dirTempShortcut\Redemarrer.lnk" }
    },
    @{
        name            = "Tableur.lnk";
        location        = $dirTempShortcut;
        hash            = "A9E4DC1E1A7786370EE7283C53CA2E4D2B3E6C57268C4328E6B9FD152EB90BAB";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Tableur.lnk" -OutFile "$dirTempShortcut\Tableur.lnk" }
    },
    @{
        name            = "TeleAssistance SCSInformatique.exe";
        location        = $dirTempShortcut;
        hash            = "68AAF3EAF5549498A5AF73B074863F483CE30E39EB55EF69AAE731CD87FD94BF";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/TeleAssistance SCSInformatique.exe" -OutFile "$dirTempShortcut\TeleAssistance SCSInformatique.exe" }
    },
    @{
        name            = "Traitement de texte.lnk";
        location        = $dirTempShortcut;
        hash            = "2D1C0623CF4ED39D1CD1BA745B073DC1ACD16A9C0D828EEEC67C5A81EB5173BD";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/raccourcis/Traitement de texte.lnk" -OutFile "$dirTempShortcut\Traitement de texte.lnk" }
    },
    @{
        name            = "Vlc-qt-interface.ini";
        location        = $dirTempConf;
        hash            = "9E703A5DE6F274E06E14750669005F370F37257AA15759DF5F3D3A5BC60070E8";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/vlc/vlc-qt-interface.ini" -OutFile "$dirTempConf\vlc-qt-interface.ini" }
    },
    @{
        name            = "Vlcrc";
        location        = $dirTempConf;
        hash            = "B22AEF8F7EA2241F035A327789BF59A5C67075E501D97011CEC747878B486C45";
        downloadCommand = { param($link) Invoke-WebRequest -Uri "$link/conf/vlc/vlcrc" -OutFile "$dirTempConf\vlcrc" }
    },
    @{
        name            = "ToolsScript.zip";
        location        = $dirTemp;
        hash            = "63EC0BC5B5158F6AEC0E20AA98CC81E41D3E483ECE82B5AB99D414E049F6A041";
        downloadCommand = { param($link) curl.exe "$link/tools/ToolsScript.zip" --output "$dirTemp\ToolsScript.zip" }
    }
)
$excludeProfiles = @{
    "U" = @("ToolsScript.zip", "ccleaner.ini", "CuteWriter.inf", "French.dll", "I_view64.ini", "IP_French.lng", "Vlc-qt-interface.ini", "Vlcrc")
    "N" = @("ToolsScript.zip", "CuteWriter.inf", "French.dll", "I_view64.ini", "IP_French.lng", "Presentation.lnk", "Tableur.lnk", "Traitement de texte.lnk", "Vlc-qt-interface.ini", "Vlcrc")
}
$programWingetInstall = @(
    @{
        name        = "Visual C++ 2015";
        packageId   = "Microsoft.VCRedist.2015+.x64";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "7zip";
        packageId   = "7zip.7zip";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "Adobe Acrobat Reader";
        packageId   = "Adobe.Acrobat.Reader.64-bit";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "Ccleaner Slim";
        packageId   = "Piriform.CCleaner.Slim";
        postInstall = { Copy-Item -Path "$dirTempConf\ccleaner.ini" -Destination "$env:Programfiles\CCleaner\" -Force }
        source      = "winget"
    },
    @{
        name        = "CrystalDiskInfo";
        packageId   = "CrystalDewWorld.CrystalDiskInfo";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "Cute PDF Writer";
        packageId   = "AcroSoftware.CutePDFWriter";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "Mozilla Firefox";
        packageId   = "Mozilla.Firefox.fr";
        postInstall = $null
        source      = "winget"
    }
    @{
        name        = "IrfanView";
        packageId   = "IrfanSkiljan.IrfanView";
        postInstall = { 
            New-Item -Path "$env:Programfiles\IrfanView\Languages\" -ItemType Directory -Force | Out-Null
            Remove-Item -Path "$env:Programfiles\IrfanView\i_view64.ini" -Force
            Copy-Item -Path "$dirTempConf\French.dll" -Destination "$env:Programfiles\IrfanView\Languages\" -Force
            Copy-Item -Path "$dirTempConf\IP_French.lng" -Destination "$env:Programfiles\IrfanView\Languages\" -Force
            Copy-Item -Path "$dirTempConf\i_view64.ini" -Destination "$env:Programfiles\IrfanView\" -Force
        }
        source      = "winget"
    },
    @{
        name        = "LibreOffice";
        packageId   = "TheDocumentFoundation.LibreOffice";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "NAPS2";
        packageId   = "Cyanfish.NAPS2";
        postInstall = $null 
        source      = "winget"
    },
    @{
        name        = "Mozilla Thunderbird";
        packageId   = "Mozilla.Thunderbird.fr";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "TrayStatus";
        packageId   = "BinaryFortress.TrayStatus";
        postInstall = $null
        source      = "winget"
    },
    @{
        name        = "TreeSize Free";
        packageId   = "XP9M26RSCLNT88";
        postInstall = $null 
        source      = "msstore"
    },
    @{
        name        = "VLC Media Player";
        packageId   = "VideoLAN.VLC";
        postInstall = {
            New-Item -Path "$env:APPDATA\vlc" -ItemType Directory -Force | Out-Null
            Copy-Item -Path "$dirTempConf\vlc-qt-interface.ini" -Destination "$env:APPDATA\vlc\" -Force
            Copy-Item -Path "$dirTempConf\vlcrc" -Destination "$env:APPDATA\vlc\" -Force
        }
        source      = "winget"
    },
    @{
        name        = "XnView";
        packageId   = "XnSoft.XnViewMP";
        postInstall = $null
        source      = "winget"
    }
)
$programWingetNettoyage = @(
    @{
        name        = "Ccleaner Slim";
        packageId   = "Piriform.CCleaner.Slim";
        postInstall = { Copy-Item -Path "$dirTempConf\ccleaner.ini" -Destination "$env:Programfiles\CCleaner\" -Force }
    },
    @{
        name        = "CrystalDiskInfo";
        packageId   = "CrystalDewWorld.CrystalDiskInfo";
        postInstall = $null
    },
    @{
        name        = "MalwareBytes";
        packageId   = "Malwarebytes.Malwarebytes";
        postInstall = $null
    }
)
$appxPackages = @(
    @{
        Name    = "Outlook (new)";
        Package = "*Microsoft.OutlookForWindows*"
    },
    @{
        Name    = "Office Hub";
        Package = "*Microsoft.MicrosoftOfficeHub*"
    },
    @{
        Name    = "Bing Search";
        Package = "*Microsoft.BingSearch*"
    },
    @{
        Name    = "OneNote";
        Package = "*OneNote*"
    },
    @{
        Name    = "Facebook";
        Package = "*Facebook*"
    },
    @{
        Name    = "Twitter";
        Package = "*Twitter*"
    },
    @{
        Name    = "LinkedIn";
        Package = "*Linkedin*"
    }
)
$microsoftPackages = @(
    @{
        Name    = "Microsoft Office 365";
        Package = "*Microsoft*365*"
    },
    @{
        Name    = "Microsoft OneNote";
        Package = "*Microsoft*OneNote*"
    }
)
$regOps = @(
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; 
        Name         = "LaunchTo"; 
        Value        = 1; 
        Type         = "DWORD";
        Desc         = "Explorateur Ce PC"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; 
        Name         = "HideFileExt"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Extensions fichiers"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; 
        Name         = "SearchboxTaskbarMode"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Recherche taskbar"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; 
        Name         = "TaskbarAl"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Menu gauche"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; 
        Name         = "ShowTaskViewButton"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Vue tâches"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; 
        Name         = "TaskbarMn"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Conversation"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"; 
        Name         = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Icône Ce PC"; 
        CreateParent = $false 
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"; 
        Name         = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Icône Utilisateur"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"; 
        Name         = "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Icône Réseau"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Power"; 
        Name         = "HiberbootEnabled"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Démarrage rapide"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; 
        Name         = "EnableLUA"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "UAC"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKU:\$userSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; 
        Name         = "SubscribedContent-310093Enabled"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Notification experience d'acceuil"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKU:\$userSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; 
        Name         = "SubscribedContent-338389Enabled"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Notification conseils et suggestions"; 
        CreateParent = $false
    },
    @{ 
        Path         = "HKU:\$userSID\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"; 
        Name         = "ScoobeSystemSettingEnabled"; 
        Value        = 0; 
        Type         = "DWORD";
        Desc         = "Notification suggestion"; 
        CreateParent = $true
    },
    @{ 
        Path         = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"; 
        Name         = "LetAppsRunInBackground"; 
        Value        = 0; 
        Type         = "DWORD"; 
        Desc         = "Apps arrière-plan"; 
        CreateParent = $true 
    },
    @{ 
        Path         = "HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32"; 
        Name         = "(Default)"; 
        Value        = ""; 
        Type         = "String"; 
        Desc         = "Menu contextuel classique"; 
        CreateParent = $true 
    }
)
#Montage du registre HKU
if (-not (Test-Path HKU:)) {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
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
    Write-Host "          @@ @@         @@   @@                          ║  [I] - Préparer une machine          ║" -ForegroundColor Green
    Write-Host "           @  @@        @    @                           ║  [U] - Réglage nouvel utilisateur    ║" -ForegroundColor Green
    Write-Host "           @@  @@     @@@   @@                           ║  [N] - Installation nettoyage        ║" -ForegroundColor Green
    Write-Host "            @   @@@@@@@     @                            ║  [D] - Désinstallation nettoyage     ║" -ForegroundColor Green
    Write-Host "             @             @                             ║  [Q] - Quitter                       ║" -ForegroundColor Green
    Write-Host "              @@         @@                              ╚══════════════════════════════════════╝" -ForegroundColor Green
    Write-Host "               @@@     @@@                " -ForegroundColor Green
    Write-Host "                 @@@@@@@                  " -ForegroundColor Green
}
function DownloadAndVerifyFiles {
    param(
        [Parameter(Mandatory = $true)] # Parametre OBLIGATOIRE
        [array]$Files,
        [Parameter(Mandatory = $true)] # Parametre OBLIGATOIRE
        [string]$BaseLink,
        [array]$ExcludeFiles = @(),
        [switch]$Force = $false,
        [string]$ErrorLogPath = "$Global:desktop\download_errors.log"
    )
    
    # Créer les dossiers temporaires s'ils n'existent pas
    if (!(Test-Path $dirTemp)) {
        New-Item -ItemType Directory -Path $dirTemp -Force | Out-Null
        Write-Host "$(Get-Timestamp) - [INFO] - Création du dossier temporaire `"%tmp%\scs`"" -ForegroundColor White
    }
    if (!(Test-Path $dirTempConf)) {
        New-Item -ItemType Directory -Path $dirTempConf -Force | Out-Null
        Write-Host "$(Get-Timestamp) - [INFO] - Création du dossier temporaire `"%tmp%\scs\conf`"" -ForegroundColor White
    }
    if (!(Test-Path $dirTempShortcut)) {
        New-Item -ItemType Directory -Path $dirTempShortcut -Force | Out-Null
        Write-Host "$(Get-Timestamp) - [INFO] - Création du dossier temporaire `"%tmp%\scs\raccourcis`"" -ForegroundColor White
    }
    # Filtrer les fichiers exclus
    if ($ExcludeFiles.Count -gt 0) {
        $Files = $Files | Where-Object { $_.name -notin $ExcludeFiles }
    }
    
    $results = @()
    $totalFiles = $Files.Count
    $currentFile = 0
    
    Write-Host "$(Get-Timestamp) - [INFO] - Début du téléchargement et vérification de $totalFiles fichiers..." -ForegroundColor White

    foreach ($file in $Files) {
        $currentFile++
        $filePath = Join-Path $file.location $file.name
        $downloadNeeded = $true
        $verificationResult = @{
            Name       = $file.name
            Location   = $file.location
            Downloaded = $false
            HashValid  = $false
            Error      = $null
            Status     = "En cours..."
        }
        
        Write-Progress -Activity "Traitement des fichiers" -Status "[$currentFile/$totalFiles] $($file.name)" -PercentComplete (($currentFile / $totalFiles) * 100) # Ouvre la barre de telechargement

        try {
            # Test si le fichier existe et si le commutateur "Force" existe, si oui verifie le hash 
            if ((Test-Path $filePath) -and !$Force) {
                Write-Host "$(Get-Timestamp) - [INFO] - [$currentFile/$totalFiles] Vérification du fichier existant : $($file.name)" -ForegroundColor White
                $existingHash = Get-FileHash -Path $filePath -Algorithm SHA256

                if ($existingHash.Hash -eq $file.hash) {
                    Write-Host "$(Get-Timestamp) - [SUCCESS] - Hash valide, téléchargement ignoré" -ForegroundColor Green
                    $downloadNeeded = $false # Evite le telechargement si le fichier existe et que son hash est bon
                    $verificationResult.Downloaded = $false
                    $verificationResult.HashValid = $true
                    $verificationResult.Status = "Déjà présent et valide"
                }
                else {
                    Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : Hash invalide pour le fichier existant !" -ForegroundColor Red
                    Write-Host "$(Get-Timestamp) - [DEBUG] - Attendu : $($file.hash)" -ForegroundColor Cyan
                    Write-Host "$(Get-Timestamp) - [DEBUG] - Obtenu  : $($existingHash.Hash)" -ForegroundColor Cyan
                    $downloadNeeded = $false
                    $verificationResult.Downloaded = $false
                    $verificationResult.HashValid = $false
                    $verificationResult.Status = "Hash invalide (fichier existant)"
                    $verificationResult.Error = "Le fichier existant a un hash incorrect"
                }
            }

            # Telecharge le fichier si "$downloadNeeded" est true
            if ($downloadNeeded) {
                Write-Host "$(Get-Timestamp) - [INFO] - [$currentFile/$totalFiles] Téléchargement : $($file.name)" -ForegroundColor White
                
                # Exécuter la commande de téléchargement
                & $file.downloadCommand $BaseLink
                
                if (Test-Path $filePath) {
                    $verificationResult.Downloaded = $true
                    Write-Host "$(Get-Timestamp) - [SUCCESS] - Téléchargement réussi" -ForegroundColor Green
                    
                    # Vérifier le hash du fichier téléchargé
                    Write-Host "$(Get-Timestamp) - [INFO] - Vérification du hash..." -ForegroundColor White
                    $downloadedHash = Get-FileHash -Path $filePath -Algorithm SHA256
                    
                    if ($downloadedHash.Hash -eq $file.hash) {
                        Write-Host "$(Get-Timestamp) - [SUCCESS] - Hash valide : $($downloadedHash.Hash)" -ForegroundColor Green
                        $verificationResult.HashValid = $true
                        $verificationResult.Status = "Téléchargé et vérifié"
                    }
                    else {
                        Write-Host "$(Get-Timestamp) - [ERROR] - Hash invalide !" -ForegroundColor Red
                        Write-Host "$(Get-Timestamp) - [DEBUG] - Attendu : $($file.hash)" -ForegroundColor Cyan
                        Write-Host "$(Get-Timestamp) - [DEBUG] - Obtenu  : $($downloadedHash.Hash)" -ForegroundColor Cyan
                        $verificationResult.Status = "Hash invalide"
                        $verificationResult.Error = "Hash ne correspond pas"
                    }
                }
                else {
                    Write-Host "$(Get-Timestamp) - [ERROR] - Échec du téléchargement" -ForegroundColor Red
                    $verificationResult.Status = "Échec du téléchargement"
                    $verificationResult.Error = "Fichier non trouvé après téléchargement"
                }
            }
        }
        catch {
            Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
            $verificationResult.Status = "Erreur"
            $verificationResult.Error = $_.Exception.Message
        }

        $results += $verificationResult # Ajoute les infos dans results qui sera le fichier log 
    }

    Write-Progress -Activity "Traitement des fichiers" -Completed # Ferme la barre de telechargement
    if ($results | Select-String -Pattern "Erreur") {
        $results | Out-File -FilePath $ErrorLogPath -Encoding UTF8 -Force
    }
}
function InstallAndConfigWinget {
    param (
        [Parameter(Mandatory = $true)]
        [array]$Names,
        # [scriptblock]$PostInstall,
        [string]$ErrorLogPath = "$Global:desktop\installWinget_errors.log"
    )

    $results = @()
    $totalPrograms = $Names.Count
    $currentPrograms = 0

    Write-Host "$(Get-Timestamp) - [INFO] - Début de l'installation et du paramétrage de $totalPrograms programmes ..." -ForegroundColor White

    foreach ($name in $Names) {
        $currentPrograms++
        $verificationResult = @{
            Name               = $name.name
            PackageId          = $name.packageId
            CommandPostInstall = $name.postInstall
            Error              = $null
            Status             = "En cours..."
        }

        try {
            Write-Host "$(Get-Timestamp) - [INFO] - [$currentPrograms/$totalPrograms] Installation de $($name.name) ..." -ForegroundColor White
            & winget.exe install --id $name.packageId --exact --source $name.source --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force
            
            # Exécution des commandes post-installation si elles existent
            if ($name.postInstall) {
                if ($name.postInstall -is [scriptblock]) {
                    & $name.postInstall
                }
                else {
                    Invoke-Expression -Command $name.postInstall
                }
            }
            Write-Host "$(Get-Timestamp) - [SUCCESS] - [$currentPrograms/$totalPrograms] Installation de $($name.name) réussie" -ForegroundColor Green  
            $verificationResult.Status = "Installé"      
        }
        catch {
            Write-Host "$(Get-Timestamp) - [ERROR] - [$currentPrograms/$totalPrograms] ERREUR : $($_.Exception.Message)" -ForegroundColor Red
            $verificationResult.Status = "Erreur"
            $verificationResult.Error = $_.Exception.Message
        }
        $results += $verificationResult
    }

    if ($results | Select-String -Pattern "Erreur") {
        $results | Out-File -FilePath $ErrorLogPath -Encoding UTF8 -Force
    }
}
function InstallAndConfigChocolatey {

    try {
        # Test si Chocolatey est installé
        $testChoco = Get-Command choco
        if ($testChoco | Select-String -Pattern "choco") {
            # Test la version de Chocolatey
            $versionChoco = choco.exe --version
            if ($versionChoco -eq "2.5.0") {
                Write-Host "$Global:timestamp - [INFO] - Chocolatey est à jour" -ForegroundColor White
            }
            elseif ($versionChoco -lt "2.5.0") {
                Write-Host "$Global:timestamp - [INFO] - Début de la mise à jour de Chocolatey ..." -ForegroundColor White
                try {
                    choco.exe upgrade chocolatey -y
                    if ($LASTEXITCODE -ne 0) {
                        throw "Chocolatey a échoué avec le code $LASTEXITCODE"
                    }
                    Write-Host "$Global:timestamp - [SUCCESS] - Mise à jour de Chocolatey réussie" -ForegroundColor Green
                }
                catch {
                    Write-Host "$Global:timestamp - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            else {
                Write-Host "$Global:timestamp - [INFO] - Version de Chocolatey installé est plus recente" -ForegroundColor Cyan
                Write-Host "$Global:timestamp - [DEBUG] - Penser à mettre à jour la version de Chocolatey dans le script" -ForegroundColor Cyan
            }
        }
        else {
            # Install chocolatey
            Set-ExecutionPolicy Bypass -Scope Process -Force
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    }
    catch {
        Write-Host "$Global:timestamp - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }

    try {
        Write-Host "$Global:timestamp - [INFO] - Début de l'installation de Spybot ..." -ForegroundColor White
        choco.exe install spybot -y 
        if ($LASTEXITCODE -ne 0) {
            throw "Chocolatey a échoué avec le code $LASTEXITCODE"
        }
        Write-Host "$Global:timestamp - [SUCCESS] - Installation de Spybot réussi" -ForegroundColor Green
    }
    catch {
        Write-Host "$Global:timestamp - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
}
function UninstallSoftPreInstall {
    param(
        [Parameter(Mandatory = $true)]
        [array]$AppxPackages,
        [Parameter(Mandatory = $true)]
        [array]$MicrosoftPackages
    )

    $currentPrograms = 0
    $totalPrograms = $AppxPackages.Count + $MicrosoftPackages.Count

    Write-Host "$(Get-Timestamp) - [INFO] - Désinstallation de $($totalPrograms) pré-installé en cours..." -ForegroundColor White

    foreach ($package in $AppxPackages) {
        $currentPrograms++
        try {
            Write-Host "$(Get-Timestamp) - [INFO] - [$($currentPrograms)/$($totalPrograms)] Désinstallation de $($package.Name) en cours..." -ForegroundColor White
            Get-AppxPackage $package.Package | Remove-AppxPackage
            Write-Host "$(Get-Timestamp) - [SUCCESS] - [$($currentPrograms)/$($totalPrograms)] Désinstallation de $($package.Name) réussie" -ForegroundColor Green
        }
        catch {
            Write-Host "$(Get-Timestamp) - [ERROR] - [$($currentPrograms)/$($totalPrograms)] ERREUR : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    try {
        $currentPrograms++
        foreach ($package in $MicrosoftPackages) {
            Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Where-Object { $_.DisplayName -like $package.Package } |
            ForEach-Object {
                if ($_.UninstallString) {
                    $parts = $_.UninstallString -split '"'
                    $exe = $parts[1]
                    $arg = ($parts[2] -replace '^\s+') + " DisplayLevel=False"
                    Start-Process -FilePath $exe -ArgumentList $arg -Wait
                }
            }
        }
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Désinstallation de $($totalPrograms) pré-installé réussite" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - [$($currentPrograms)/$($totalPrograms)] ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
    
}
function UninstallNettoyage {
    Write-Host "$(Get-Timestamp) - [INFO] - Suppression du packet Spybot de Chocolatey en cours..." -ForegroundColor White
    try {
        choco.exe uninstall spybot --force --ignore-detected-reboot -n
        if ($LASTEXITCODE -ne 0) {
            throw "Chocolatey a échoué avec le code $LASTEXITCODE"
        }
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Suppression du packet Spybot de Chocolatey réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "$(Get-Timestamp) - [INFO] - Désinstallation de Spybot en cours..." -ForegroundColor White
    try {
        $uninstallKeys = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )
        $processSB = @(
            "SDFSSvc",
            "SDTray",
            "SDUpdSvc"
        )

        Write-Host "$(Get-Timestamp) - [INFO] - Fermeture des processus de Spybot en cours..." -ForegroundColor White
        foreach ($process in $processSB) {
            Stop-Process -Name $process -Force | Out-Null
        }
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Fermeture des processus de Spybot réussie" -ForegroundColor Green

        Write-Host "$(Get-Timestamp) - [INFO] - Recherche commande désinstalle de Spybot en cours..." -ForegroundColor White
        foreach ($keyPath in $uninstallKeys) {
            $programs = Get-ItemProperty $keyPath -ErrorAction SilentlyContinue | 
            Where-Object { 
                $_.DisplayName -like "*Spybot*" -or 
                $_.DisplayName -like "*Search*Destroy*" 
            }
            foreach ($program in $programs) {
                if ($program.UninstallString) {
                    Write-Host "$(Get-Timestamp) - [DEBUG] - Commande : $($program.UninstallString)" -ForegroundColor Cyan
                }
                $uninstallCmd = $program.UninstallString
                #$cmd = $uninstallCmd -replace '"', ''
                Start-Process $uninstallCmd "/SILENT /NORESTART"
            }
        }
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Désinstallation de Spybot réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "$(Get-Timestamp) - [INFO] - Désinstallation de MalwareBytes en cours..." -ForegroundColor White
    try {
        winget.exe uninstall --id "Malwarebytes.Malwarebytes" --exact --source winget --accept-source-agreements --disable-interactivity  --silent --force
        if ($LASTEXITCODE -ne 0) {
            throw "Winget a échoué avec le code $LASTEXITCODE"
        }
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Désinstallation de MalwareBytes réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "$(Get-Timestamp) - [INFO] - Suppression des fichiers de Spybot et MalwareBytes en cours..." -ForegroundColor White
    Get-Process explorer | Stop-Process -Force; Start-Process explorer # Redemarre l'explorateur pour etre sur que tout est supprime
    try {
        Remove-Item -Path "C:\Program Files (x86)\Spybot - Search & Destroy 2" -Force -Recurse
        Remove-Item -Path "C:\ProgramData\Spybot - Search & Destroy" -Force -Recurse
        Remove-Item -Path "C:\ProgramData\chocolatey\.chocolatey\spybot*" -Force -Recurse
        Remove-Item -Path "C:\Windows\System32\Tasks\Safer-Networking" -Force -Recurse
        Remove-Item -Path "$env:LOCALAPPDATA\Packages\Malwarebytes*" -Force -Recurse
        Remove-Item -Path "$env:ProgramData\Packages\Malwarebytes*" -Force -Recurse
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Suppression des fichiers de Spybot et MalwareBytes réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
}
function ConfigureOS {
    # Activation des points de restauration + Definition du quota a 20Go
    try {
        Write-Host "$(Get-Timestamp) - [INFO] - Activation des points de restauration ..." -ForegroundColor White
        Enable-ComputerRestore -Drive "C:\" -ErrorAction Stop  # Si erreur -> va directement au catch
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Activation des points de restauration réussie" -ForegroundColor Green

        Write-Host "$(Get-Timestamp) - [INFO] - Définition du quota des points de restauration ..." -ForegroundColor White
        Start-Process -FilePath "vssadmin.exe" -ArgumentList "resize shadowstorage /on=C: /for=C: /maxsize=20GB" -NoNewWindow -Wait -ErrorAction Stop | Out-Null
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Définition du quota des points de restauration réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
    # Activation .Net 3.5
    try {
        Write-Host "$(Get-Timestamp) - [INFO] - Activation de .Net 3.5 en cours ..." -ForegroundColor White
        Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -ErrorAction Stop | Out-Null
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Activation de .Net 3.5 en réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
    # Reglage registre
    foreach ($reg in $regOps) {
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
    # Activation menu F8
    try {
        Write-Host "$(Get-Timestamp) - [INFO] - Activation du menu F8 en cours ..." -ForegroundColor White
        bcdedit.exe /set "{default}" bootmenupolicy legacy -ErrorAction Stop | Out-Null
        Write-Host "$(Get-Timestamp) - [SUCCESS] - Activation du menu F8 en réussie" -ForegroundColor Green
    }
    catch {
        Write-Host "$(Get-Timestamp) - [ERROR] - ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    }
    # Profil alimentation - version compacte
    $customPower = "B1234567-6664-6664-6664-F00000111AFA"
    $powerCmds = @(
        "powercfg.exe /DUPLICATESCHEME 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c $customPower",
        "powercfg.exe /CHANGENAME $customPower `"Scsinfo`"",
        "powercfg.exe /SETACTIVE $customPower"
    )
        
    $success = $true
    foreach ($cmd in $powerCmds) {
        Invoke-Expression "$cmd | Out-Null"
        if ($LASTEXITCODE -ne 0) { $success = $false; break }
    }
        
    if ($success) {
        # Configuration rapide des paramètres d'alimentation
        $powerSettings = @(
            "/SETACVALUEINDEX $customPower 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0",
            "/SETDCVALUEINDEX $customPower 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0",
            "/SETACVALUEINDEX $customPower 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0",
            "/SETDCVALUEINDEX $customPower 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0",
            "/SETACVALUEINDEX $customPower 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0",
            "/SETDCVALUEINDEX $customPower 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0",
            "/CHANGE -monitor-timeout-ac 0", "/CHANGE -monitor-timeout-dc 0",
            "/CHANGE -disk-timeout-ac 0", "/CHANGE -disk-timeout-dc 0",
            "/CHANGE -standby-timeout-ac 0", "/CHANGE -standby-timeout-dc 0",
            "/CHANGE -hibernate-timeout-ac 0", "/CHANGE -hibernate-timeout-dc 0"
        )
        $powerSettings | ForEach-Object { powercfg.exe $_.Split(' ') | Out-Null }
    }
}
function CopyShortcutAndFiles {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("install", "nettoyage", "user")]
        [string]$Types
    )

    switch ($Types) {
        "install" {
            New-Item -Path $dirInstall -ItemType Directory -Force | Out-Null
            Copy-Item -Path "$dirTempShortcut\*.ico" -Destination "$env:windir\System32" -Force -Recurse
            Copy-Item -Path "$dirTempShortcut\*" -Destination "$Global:desktop\" -Include "*.lnk", "*.exe" -Force -Recurse
            Expand-Archive -Path "$dirTemp\ToolsScript.zip" -DestinationPath "$dirInstall\Tools"
            #Control si machine Terra et range les infos Terra
            $terraPath = "C:\SNr.txt"
            if (Test-Path $terraPath) {
                $copyTerra = "$dirInstall\Terra"
                New-Item -Path "$copyTerra" -ItemType Directory -Force | Out-Null
                Move-Item -Path "C:\Driver" -Destination "$copyTerra\Driver" -Force
                Move-Item -Path "C:\SNr.txt" -Destination "$copyTerra\" -Force
                Move-Item -Path "C:\PC-Test_Protocol.html" -Destination "$copyTerra\" -Force
            }
            Remove-Item -Path "$Global:desktop\CrystalDiskInfo.lnk" -Force
            Remove-Item -Path "$env:PUBLIC\Desktop\Adobe*.lnk" -Force
            Remove-Item -Path "$env:PUBLIC\Desktop\CCleaner.lnk" -Force
            Remove-Item -Path "$env:PUBLIC\Desktop\LibreOffice*.lnk" -Force
        }
        "nettoyage" {
            $shutdownPath = "$Global:desktop\Arreter.lnk"
            $shortcuts = @("Arreter.lnk", "Redemarrer.lnk", "Deconnexion.lnk", "TeleAssistance SCSInformatique.exe")
            if (-not (Test-Path $shutdownPath)) {
                Copy-Item -Path "$dirTempShortcut\*.ico" -Destination "$env:windir\System32" -Force -Recurse
                foreach ($shortcut in $shortcuts) {
                    Copy-Item -Path "$dirTempShortcut\$shortcut" -Destination "$Global:desktop\" -Force -Recurse
                }
            }
        }
        "user" {
            Copy-Item -Path "$dirTempShortcut\*.ico" -Destination "$env:windir\System32" -Force -Recurse
            Copy-Item -Path "$dirTempShortcut\*" -Destination "$Global:desktop\" -Include "*.lnk", "*.exe" -Force -Recurse
            Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\XnView MP\XnView MP.lnk" -Destination "$Global:desktop\" -Force -Recurse
        }
        Default {
            Write-Host "$(Get-Timestamp) - [ERROR] - Erreur dans le type d'éxécution d'install !" -ForegroundColor Red
        }
    }
}
function RenameComputer {
    #$escape = $true # Variable de contrôle pour la boucle
    do {
        $nameComputer = Read-Host "Quel nom de machine veux-tu lui donner ?"
        $validName = Read-Host "Tu es sur de vouloir l'appeler $nameComputer ? (O ou N)"
        if ($validName -eq "O" -or $validName -eq "o") {
            Rename-Computer -NewName $nameComputer
            Write-Host "Le nom de la machine a ete change en $nameComputer."
            #$escape = $false  # Mettre fin a la boucle
            break  # Sort de la boucle
        }
        else {
            Write-Host "Tu n'as pas mis O ou N !! Recommence !"
        }
    } while ($true)  # Boucle infinie jusqu'a obtenir une reponse valide
}
function AddWorkgroup {
    #$escape = $true # Variable de contrôle pour la boucle
    do {
        $nameWorkgroup = Read-Host "Quel groupe de travail veux-tu lui donner ?"
        $validWorkgroup = Read-Host "Es-tu sur de vouloir l'ajouter a $nameWorkgroup ? (O ou N)"
        if ($validWorkgroup -eq "O" -or $validWorkgroup -eq "o") {
            Add-Computer -WorkGroupName $nameWorkgroup
            Write-Host "La machine a ete ajoute au groupe $nameWorkgroup."
            #$escape = $false  # Mettre fin a la boucle
            break  # Sort de la boucle
        }
        else {
            Write-Host "Tu n'as pas mis O ou N !! Recommence !"
        }
    } while ($true)
}
# ========================================
# EXECUTION DES FONCTIONS
# ========================================
do {
    Show-Logo
    $choice = Read-Host "Votre choix"
    $choice = $choice.Trim().ToUpper()
    
    switch ($choice) {
        'I' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🚀 Installation en cours..." -ForegroundColor Magenta
            DownloadAndVerifyFiles -Files $filesDownload -BaseLink $link -Force
            InstallAndConfigWinget -Names $programWingetInstall
            UninstallSoftPreInstall -AppxPackages $appxPackages -MicrosoftPackages $microsoftPackages
            CopyShortcutAndFiles -Types "install"
            ConfigureOS
            RenameComputer
            AddWorkgroup
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'U' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🔧 Configuration de l'utilisateur en cours..." -ForegroundColor Magenta
            DownloadAndVerifyFiles -Files $filesDownload -BaseLink $link -Force -ExcludeFiles $excludeProfiles["U"]
            CopyShortcutAndFiles -Types "user"
            ConfigureOS
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'N' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🧹 Installation des outils de nettoyage en cours..." -ForegroundColor Magenta
            DownloadAndVerifyFiles -Files $filesDownload -BaseLink $link -Force -ExcludeFiles $excludeProfiles["N"]
            InstallAndConfigChocolatey
            InstallAndConfigWinget -Names $programWingetNettoyage
            CopyShortcutAndFiles -Types "nettoyage"
            $duration = (Get-Date) - $startTime
            Write-Host "$(Get-Timestamp) - [INFO] - ⏱️ Temps d'éxecution du script : $duration" -ForegroundColor Magenta
        }
        'D' {
            $startTime = Get-Date
            Write-Host "$(Get-Timestamp) - [INFO] - 🗑️ Désinstallation en cours..." -ForegroundColor Magenta
            UninstallNettoyage
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
} while ($choice -notin @('I', 'U', 'N', 'D', 'Q'))
# ========================================
# NETTOYAGE FICHIERS TEMP
# ========================================
if (Test-Path $dirTemp) {
    Remove-Item -Path $dirTemp -Force -Recurse
}

Read-Host "Appuyer sur Entrée pour quitter ..."








