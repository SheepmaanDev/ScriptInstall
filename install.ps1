# Definition des repertoires
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.path #Emplacement d'execution du script
$desktop = [System.Environment]::GetFolderPath('Desktop') #Emplacement du dossier Bureau
#--------------------------------------------------------------------------------------------------------------------------------------

# Definition des variables
$software = @{
    ZIP = "7z2408-x64.msi"
    ADB = "AcroRdrDCUpd2001220041.msp"
    CC  = "ccsetup628_slim.exe"
    CW  = "CuteWriter.exe"
    CV  = "Setup.exe"
    FF  = "Firefox Setup 130.0.exe"
    IV  = "iview467_x64_setup.exe"
    LO  = "LibreOffice_24.8.2_Win_x86-64.msi"
    PF  = "pf7-setup-fr-7.2.1.exe" 
    TB  = "Thunderbird Setup 128.2.2esr.exe"
    TS  = "TrayStatusSetup-4.8.exe"
    VC  = "vc_redist.x64.exe"
    VLC = "vlc-3.0.21-win64.exe"
}
# Exemple d'appel à la fonction avec un compteur
$programs = @(
    # VisualC++2015
    @{ 
        directory      = "VisualC";
        installCommand = { Start-Process .\$($software.VC) -ArgumentList "/S" -Wait }
    }
    # 7zip
    @{
        directory      = "7zip";
        installCommand = { Start-Process msiexec.exe -ArgumentList "/qr /i $($software.ZIP)" -Wait }
    },
    # Adobe Acrobat Reader
    @{ 
        directory      = "Adobe";
        installCommand = { 
            Start-Process msiexec.exe -ArgumentList "/i AcroRead.msi /qr" -Wait 
            Start-Process msiexec.exe -ArgumentList "/p $($software.ADB) /qr" -Wait
        }
    },
    # CCleaner
    @{ 
        directory          = "CCleaner";
        installCommand     = { Start-Process .\$($software.CC) -ArgumentList "/S" -Wait };
        postInstallCommand = { Copy-Item -Path "ccleaner.ini" -Destination "$env:Programfiles\CCleaner\" -Force }
    },
    # CuteWriter + Converter
    @{ 
        directory      = "CuteWriter";
        installCommand = { 
            Start-Process .\$($software.CW) -ArgumentList "/loadinf='CuteWriter.inf' /silent /norestart /no3d"
            Start-Process .\converter\$($software.CV) 
        }
    },
    # Firefox
    @{ 
        directory          = "Firefox";
        installCommand     = { Start-Process .\$($software.FF) -ArgumentList "-ms" -Wait };
        postInstallCommand = { 
            Start-Process "$env:Programfiles\Mozilla Firefox\firefox.exe"
            Start-Sleep -Seconds 15
            Stop-Process -Name "firefox" -Force
            Start-Sleep -Seconds 2
            $profilDir = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles\" -Directory | Select-Object -Skip 1 -First 1
            Copy-Item -Path "Profile130\*" -Destination "$($profilDir.FullName)\" -Force
        }
    },
    # IrfanView
    @{ 
        directory          = "IrfanView";
        installCommand     = { Start-Process .\$($software.IV) -ArgumentList "/silent /desktop=1 /thumbs=1 /group=1 /allusers=1 /assoc=1" -Wait };
        postInstallCommand = { 
            New-Item -Path "$env:Programfiles\IrfanView\Languages\" -ItemType Directory -Force > $null
            Remove-Item -Path "$env:Programfiles\IrfanView\i_view64.ini" -Force
            Copy-Item -Path "French.dll" -Destination "$env:Programfiles\IrfanView\Languages\" -Force > $null
            Copy-Item -Path "IP_French.lng" -Destination "$env:Programfiles\IrfanView\Languages\" -Force > $null
            Copy-Item -Path "i_view64.ini" -Destination "$env:Programfiles\IrfanView\" -Force > $null
        }
    },
    # LibreOffice
    @{ 
        directory      = "LibreOffice";
        installCommand = { Start-Process msiexec.exe -ArgumentList " /i $($software.LO) /passive /norestart REGISTER_ALL_MSO_TYPES=1 ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 QUICKSTART=0 ADDLOCAL=ALL UI_LANGS=fr REMOVE=gm_r_ex_Dictionary_Af,gm_r_ex_Dictionary_An,gm_r_ex_Dictionary_Ar,gm_r_ex_Dictionary_Be,gm_r_ex_Dictionary_Bg,gm_r_ex_Dictionary_Bn,gm_r_ex_Dictionary_Br,gm_r_ex_Dictionary_Bs,gm_r_ex_Dictionary_Ca,gm_r_ex_Dictionary_Cs,gm_r_ex_Dictionary_Da,gm_r_ex_Dictionary_De,gm_r_ex_Dictionary_El,gm_r_ex_Dictionary_Et,gm_r_ex_Dictionary_Gd,gm_r_ex_Dictionary_Gl,gm_r_ex_Dictionary_Gu,gm_r_ex_Dictionary_He,gm_r_ex_Dictionary_Hi,gm_r_ex_Dictionary_Hr,gm_r_ex_Dictionary_Hu,gm_r_ex_Dictionary_It,gm_r_ex_Dictionary_Lt,gm_r_ex_Dictionary_Lv,gm_r_ex_Dictionary_Ne,gm_r_ex_Dictionary_Nl,gm_r_ex_Dictionary_No,gm_r_ex_Dictionary_Oc,gm_r_ex_Dictionary_Pl,gm_r_ex_Dictionary_Pt_Br,gm_r_ex_Dictionary_Pt_Pt,gm_r_ex_Dictionary_Ro,gm_r_ex_Dictionary_Ru,gm_r_ex_Dictionary_Si,gm_r_ex_Dictionary_Sk,gm_r_ex_Dictionary_Sl,gm_r_ex_Dictionary_Sr,gm_r_ex_Dictionary_Sv,gm_r_ex_Dictionary_Te,gm_r_ex_Dictionary_Th,gm_r_ex_Dictionary_Uk,gm_r_ex_Dictionary_Vi,gm_r_ex_Dictionary_Zu" -Wait }
    },
    # Photofiltre
    @{ 
        directory      = "PhotoFiltre";
        installCommand = { Start-Process .\$($software.PF) -ArgumentList "/silent" -Wait }
    },
    # Thunderbird
    @{ 
        directory      = "Thunderbird";
        installCommand = { Start-Process .\$($software.TB) -ArgumentList "-ms" -Wait }
    },
    # TrayStatus
    @{ 
        directory      = "TrayStatus";
        installCommand = { Start-Process .\$($software.TS) -ArgumentList "/loadinf=traystatus.inf /silent" }#;
        #postInstallCommand = { 
        #Start-Sleep -Seconds 2
        #Stop-Process -Name "TrayStatus" -Force
        #}
    },
    # VLC
    @{ 
        directory          = "VLC";
        installCommand     = { Start-Process .\$($software.VLC) -ArgumentList "/S" -Wait };
        postInstallCommand = { 
            New-Item -Path "$env:APPDATA\vlc" -ItemType Directory -Force > $null
            Copy-Item -Path "vlc-qt-interface.ini" -Destination "$env:APPDATA\vlc\" -Force > $null
            Copy-Item -Path "vlcrc" -Destination "$env:APPDATA\vlc\" -Force > $null
        }
    }
)
# Initialisation des compteurs
$counter = 1
$counterMax = 12

# Création fonction pour installer et configurer les softs
function InstallAndConfig {
    param ( # Définition des paramètres
        [string]$directory, # Le répertoire contenant les fichiers
        [scriptblock]$installCommand, # Le bloc de script qui exécute l'installation
        [scriptblock]$postInstallCommand # Le bloc de script pour les configurations après installation (optionnel)
    )

    Write-Host "=============================================================" -ForegroundColor Green
    Write-Host "[$counter/$counterMax] Installation de $directory en cours..." -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Green

    Set-Location -Path (Join-Path $scriptDir $directory) # Change le répertoire de travail courant au répertoire de l'installation
    & $installCommand # Exécute la commande d'installation spécifiée
    if ($postInstallCommand) {
        # Si un bloc de commande de post-installation est fourni, il est exécuté
        & $postInstallCommand
    }
    Set-Location -Path $scriptDir # Rétablit le répertoire de travail initial

    # Incrémenter le compteur après chaque installation
    $global:counter++
}
function ConfigureOS {
    # Activation des points de restauration + Definition du quota a 20Go
    Enable-ComputerRestore -Drive "C:\"
    Start-Process -FilePath "vssadmin.exe" -ArgumentList "resize shadowstorage /on=C: /for=C: /maxsize=20GB" -NoNewWindow -Wait

    #Ouvrir l'explorateur dans Ce PC
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type "DWORD" -Value "1" -Force

    #Desaction soft en arriere plan
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force  > $null
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsRunInBackground" -Value "0" -Force  > $null

    #Clique droit classic
    New-Item -Path "HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Force  > $null
    New-Item -Path "HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InProcServer32" -Value "" -Force  > $null

    #Afficher icone sur bureau (Utilisateur/Ce PC/Reseau)
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type "DWORD" -Value "0" -Force #Ce PC
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type "DWORD" -Value "0" -Force #User
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type "DWORD" -Value "0" -Force #Reseau

    #Afficher les extensions de fichier
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type "DWORD" -Value "0" -Force

    #Barre des taches
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type "DWORD" -Value "0" -Force #Recherche
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Type "DWORD" -Value "0" -Force #Menu demarrer a gauche
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type "DWORD" -Value "0" -Force #Vue taches
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Type "DWORD" -Value "0" -Force #Conversation
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

Write-Host "===================##################################################===================" -ForegroundColor Green
Write-Host "===================#          Installation + Configuration          #===================" -ForegroundColor Green
Write-Host "===================##################################################===================" -ForegroundColor Green
foreach ($program in $programs) {
    InstallAndConfig -directory $program.directory -installCommand $program.installCommand -postInstallCommand $program.postInstallCommand
}

Write-Host "===================##################################################===================" -ForegroundColor Green
Write-Host "===================#            Copie Raccourcis + Terra            #===================" -ForegroundColor Green
Write-Host "===================##################################################===================" -ForegroundColor Green
$copyDir = "$desktop\InstallPS\Copie"
Copy-Item -Path "$copyDir\*.ico" -Destination "$env:windir\System32" -Force -Recurse > $null
Copy-Item -Path "$copyDir\*" -Destination "$desktop\" -Include "*.lnk", "*.exe" -Force -Recurse > $null
Copy-Item -Path "$copyDir\*.exe" -Destination "$desktop\" -Force -Recurse > $null
#Control si machine Terra et range les infos Terra
$filePath = "C:\SNr.txt"
if (Test-Path $filePath) {
    $copyTerra = "C:\Install\Terra"
    New-Item -Path "$copyTerra" -ItemType Directory -Force
    Move-Item -Path "C:\Driver" -Destination "$copyTerra\Driver" -Force > $null
    Move-Item -Path "C:\SNr.txt" -Destination "$copyTerra\" -Force > $null
    Move-Item -Path "C:\PC-Test_Protocol.html" -Destination "$copyTerra\" -Force > $null
}

Write-Host "===================##################################################===================" -ForegroundColor Green
Write-Host "===================#         Suppression Raccourcis Inutiles        #===================" -ForegroundColor Green
Write-Host "===================##################################################===================" -ForegroundColor Green
Remove-Item -Path "$env:PUBLIC\Desktop\CCleaner.lnk" -Force
Remove-Item -Path "$env:PUBLIC\Desktop\Acrobat Reader DC.lnk" -Force -Recurse
Remove-Item -Path "$env:PUBLIC\Desktop\IrfanView 64 Thumbnails.lnk" -Force
Remove-Item -Path "$env:PUBLIC\Desktop\LibreOffice 24.8.lnk" -Force

Write-Host "===================##################################################===================" -ForegroundColor Green
Write-Host "===================#              Configuration Systeme             #===================" -ForegroundColor Green
Write-Host "===================##################################################===================" -ForegroundColor Green
ConfigureOS

Write-Host "===================##################################################===================" -ForegroundColor Green
Write-Host "===================#             Configuration Nom + Grp            #===================" -ForegroundColor Green
Write-Host "===================##################################################===================" -ForegroundColor Green
RenameComputer
AddWorkgroup

Unregister-ScheduledTask -TaskName "SCSIScript" -Confirm:$false

Read-Host "Appuie sur Entree pour redemarrer"
Restart-Computer