####################################################
####################################################
########   SCRIPT AJOUT ORDINATEUR OU ##############
####################################################
####################################################

####################################################
################### FONCTION #######################
####################################################

############## DEBUT FONCTION ######################

# Fonction Log
function Log
{
    param([string]$Content,[string]$Head)

    # Vérifie si le fichier existe, sinon le crée
    # Construit la ligne de journal
    $Date = Get-Date -Format "MM-dd-yyyy"  
    $Heure = Get-Date -Format "HH:mm:ss.fffffff"  
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $Thread = [Threading.Thread]::CurrentThread.ManagedThreadId
    switch ($Head) 
        {
            "INFO" {   
                    $Entete = "INFO - Message information"
                    $Type=0 
                    }
            "DEBUG" { 
                    $Entete = "DEBUG - Message debugage"
                    $Type=4 
                    }
            "TRACE" { 
                    $Entete = "TRACE - Message tracabilite" 
                    $Type=0 
                    }
            "ERROR" { 
                    $Entete = "ERROR - Message erreur" 
                    $Type=2 
                    }
            "FATAL" { 
                    $Entete = "FATAL - Message critique" 
                    $Type=3 
                    }
        }

   $logLine = "<![LOG[$Content]LOG]!><time=`"$Heure`" date=`"$Date`" component=`"$Entete`" context=`"$User`" type=`"$Type`" thread=`"$Thread`" file=`"$User`">"

}
    

function FtcAjoutORdinateur
{ 
    $Computers = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
    $ADComputer = Get-ADComputer -Filter * -Properties *
    $DomainDN = (Get-ADDomain).DistinguishedName
    $Count = 1
    foreach ($Computer in $Computers)
    {
        Write-Progress -Activity "Création des ordinateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Computers.Length*100)
        # Gestion de présence de Sous OU
        if ( $Computer.Service -eq "NA" )
        {
            # Chemin complet
            $Path = "OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        }
        Else
        {
            # Chemin sans sous OU
            $Path ="OU=$($Computer.Service),OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        }
        # Ajout automatique des ordinateurs
        If (($ADComputer | Where {$_.Name -eq $Computer.PC}) -eq $Null)
        {
            Try {
                New-ADComputer -Name $Computer.PC -Path $Path -Description "ID $Ordinateur"
                Write-Host "Création de l'ordinateur $($Computer.PC) dans l'OU $Path réussie" -ForegroundColor Green
                Log -FilePath $LogFile -Content "Création de l'ordinateur $($Computer.PC) dans l'OU $Path réussie"  -Head "INFO"
            }
            Catch
            {
                Write-Host "Création de l'ordinateur $($Computer.PC) dans l'OU $Path échoué" -ForegroundColor Red
                Log -FilePath $LogFile -Content "Création de l'ordinateur $($Computer.PC) dans l'OU $Path échoué"  -Head "FATAL"
            }
        }
        Else
        {
            Write-Host "L'ordinateur $($Computer.PC) dans l'OU $Path existe déjà" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'ordinateur $($Computer.PC) dans l'OU $Path existe déjà" -Head "ERROR"
        }
        $Count++
        sleep -Milliseconds 100
    }
}


############## FIN FONCTION ######################


####################################################
############# DEBUT SCRIPT #########################
####################################################

############## INITIALISATION ######################

### Chemin des dossiers et fichiers à lire et exploiter
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\s14_Pharmgreen.csv"
$LogPath = "C:\Log"
$LogFile = "$LogPath\Log_Script_Ajout_Auto_PC.log"

# Crée le dossier s'il n'existe pas
if (-Not (Test-Path -Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}

# Crée le fichier s'il n'existe pas
if (-Not (Test-Path -Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile | Out-Null
}


# Définition des en-têtes de colonnes du fichier CSV
$Headers = "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail", "Groupe_User","Groupe_Computer"

# Appel module Active Directory si pas présent
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

Write-Host "Debut ajout des Oridnateur dans l'Active Directory" -ForegroundColor Blue
Write-Host "" 
FtcAjoutOrdinateur
Write-Host "" 
Write-Host "Fin ajout des Oridnateur dans l'Active Directory"  -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1

############## FIN DU SCRIPT ######################