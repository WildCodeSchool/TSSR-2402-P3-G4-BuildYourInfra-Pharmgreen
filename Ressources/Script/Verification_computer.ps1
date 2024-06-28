####################################################
####################################################
########   SCRIPT SUPPPRESSION UTILISATEUR #########
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

    # Ajoute la ligne de journal au fichier
    Add-Content -Path $LogFile -Value $logLine
}

############## FIN FONCTION ######################


####################################################
############# DEBUT SCRIPT #########################
####################################################

############## INTIALISAITON ######################
### Chemin des dossier et fichier à lire et exploiter
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\s14_Pharmgreen.csv"
$LogPath = "C:\Log"
$LogFile = "$LogPath\Log_Script_Verif_.log"

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

# Appel modul Active Directory si pas présent
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

############## APPEL FONCTION ######################


function FctVerifPC
{ 
$Computers = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
$ADComputer = Get-ADComputer -Filter * -Properties *
$DomainDN = (Get-ADDomain).DistinguishedName
$Count = 1

    foreach ($Computer in $Computers) {
        Write-Progress -Activity "Vérification des ordinateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Computers.Length*100)

        # Gestion de présence de Sous OU
        if ($Computer.Service -eq "NA") {
            # Chemin complet
            $Path = "OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        } else {
            # Chemin sans sous OU
            $Path = "OU=$($Computer.Service),OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        }

        # Vérifier si l'ordinateur est dans la bonne OU
        if ($ADComputer  | Where-Object { $_.Name -eq $Computer.PC -and $_.DistinguishedName -eq "CN=$($Computer.PC),$Path" }) 
        {
            Write-Host "L'ordinateur $($Computer.PC) dans l'OU $Path est bien présent" -ForegroundColor Green
            Log -FilePath $LogFile -Content "L'ordinateur $($Computer.PC) dans l'OU $Path est bien présent" -Head "INFO"
        } 
        
        else 
        
        {
            Write-Host "L'ordinateur $($Computer.PC) dans l'OU $Path est absent" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'ordinateur $($Computer.PC) dans l'OU $Path est absent" -Head "ERROR"

            #Récupération du nom de l'ordinateur
            $ADComputerToMove = Get-ADComputer -Filter "Name -eq '$($Computer.PC)'"

            if ($ADComputerToMove) 
            {
                # Déplacer l'ordinateur vers la bonne OU
                Try 
                {
                    Move-ADObject -Identity $ADComputerToMove.DistinguishedName -TargetPath $Path 
                    Write-Host "L'ordinateur $($Computer.PC) a été déplacé vers l'OU $Path " -ForegroundColor Green
                    Log -FilePath $LogFile -Content "L'ordinateur $($Computer.PC) a été déplacé vers l'OU $Path" -Head "INFO"
                }
                Catch 
                {
                    Write-Host "Le déplacement de l'ordinateur $($Computer.PC) vers l'OU $Path a échoué" -ForegroundColor Red
                    Log -FilePath $LogFile -Content "Le déplacement de l'ordinateur $($Computer.PC) vers l'OU $Path a échoué" -Head "FATAL"
                }
            }
            else
            {
                Write-Host "L'ordinateur $($Computer.PC) n'a pas été trouvé dans Active Directory" -ForegroundColor Yellow
                Log -FilePath $LogFile -Content "L'ordinateur $($Computer.PC) n'a pas été trouvé dans Active Directory" -Head "ERROR"
            }
        }

        $Count++
        sleep -Milliseconds 100
    }

}

FctVerifPC
