####################################################
####################################################
########   SCRIPT AJOUT UTILSIATEUR GROUPE #########
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

# Fonction ajout utilisateurs au groupes
function FctAjoutUserGroup
{
        # Imporattation des données
        $Users = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
        $ADUsers = Get-ADUser -Filter * -Properties *

        # ajout utilisateurs aux groupes
        foreach ($User in $Users) 
        {
                $Groupmenber = $User.Groupe_User
                $Name = "$($User.Nom) $($User.Prenom)"
                $SamAccountName = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
                
                $info = Get-ADUser -Identity $samaccountname -Properties MemberOf
                $groups = $info.MemberOf
                Foreach ($group in $groups) 
                {
                        Remove-ADGroupMember -Identity $group -Members $SamAccountName -Confirm:$false
                }

        If (($ADUsers | Where-Object {$_.SamAccountName -eq $SamAccountName}) -ne $Null)
                        {
                                Try {
                                Add-ADGroupMember -Identity $Groupmenber -Members $SamAccountName
                                Write-Host "Ajout compte $SamAccountName dans le $Groupmenber réussit" -ForegroundColor Green
                                Log -FilePath $LogFile -Content "Ajout compte $SamAccountName dans le $Groupmenber réussit"  -Head "INFO"
                                }
                                Catch 
                                { write-host "Ajout compte $SamAccountName dans le $Groupmenber échoué" -ForegroundColor red
                                Log -FilePath $LogFile -Content "Ajout compte $SamAccountName dans le $Groupmenber échoué"  -Head "FATAL"
                                }
                        }
                        Else
                        {
                                Write-Host "Le compte $SamAccountName n'exite pas" -ForegroundColor Yellow
                                Log -FilePath $LogFile -Content "Le compte $SamAccountName n'exite pas" -Head "ERROR"
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
$File = "$FilePath\\s09_Pharmgreen.csv"
$LogPath = "C:\\Log\\"
$LogFile = "$LogPath\\Log_Script_GRP_ADD_USER.log"

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


Write-Host "Debut ajout des Utilisateur dans leur Groupe Principaux" -ForegroundColor Blue
Write-Host "" 
FctAjoutUserGroup
Write-Host "" 
Write-Host "Fin ajout des Utilisateur dans leur Groupe Principaux" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Red
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1


############## FIN DU SCRIPT ######################
