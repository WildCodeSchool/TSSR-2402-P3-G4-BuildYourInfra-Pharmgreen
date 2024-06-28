####################################################
####################################################
### SCRIPT MODIFICAITON INFORMATION  UTILISATEUR ###                                           
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


function FctAjoutUtilisateurs
{ 
    # Importation des données
    $Users = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
    $ADUsers = Get-ADUser -Filter * -Properties *

    $Count = 1

    Foreach ($User in $Users)
    {
        Write-Progress -Activity "Création des utilisateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Users.Length*100)
        $Name              = "$($User.Nom) $($User.Prenom)"
        $DisplayName       = "$($User.Nom) $($User.Prenom)"
        $SamAccountName    = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
        $UserPrincipalName = $(($User.Prenom.ToLower() + "." + $User.Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
        $GivenName         = $User.Prenom
        $Surname           = $User.Nom
        $OfficePhone       = $User.Telf
        $PortablePhone     = $User.Telp
        $EmailAddress      = $UserPrincipalName
        $Path              = "ou=$($User.Service),ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        $Department        = "$($User.Departement)"
        $Service           = "$($User.Service)"
        $Fonction          = "$($User.fonction)"
        $Company           = $User.Societe
        $Manager           = $($User.ManagerNom.ToLower())+ "." + $($User.ManagerPrenom.ToLower())
        $ManagerPrenom     = $User.ManagerPrenom
        $ManagerNom        = $User.ManagerNom
        $Site              = $User.Site
        $birthday          = $User.DateDeNaissance

        # Gestion de présence de Sous OU
        if ( $User.Service -eq "NA" )
        # Chemin complet
        {
            $Path = "ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        }
        Else
        # Chemin sans sous OU
        {
            $Path = "ou=$($User.Service),ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        }

        # Vérifier si l'utilisateur existe déjà
        $existingUser = $ADUsers | Where-Object { $_.GivenName -eq $GivenName -and $_.Description -eq $birthday }

        # Création Utilisateur
        If ($existingUser -eq $Null)
        {
            Try
            {
                New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
                -GivenName $GivenName -Surname $Surname -HomePhone $OfficePhone -MobilePhone $PortablePhone -EmailAddress $EmailAddress `
                -Office $Site -Description $birthday -Title $Fonction -City $Site -Path $Path `
                -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty12024* -Force) -Enabled $True `
                -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True

                Write-Host "Création du USER" $SamAccountName -ForegroundColor Green
                Log -FilePath $LogFile -Content "Création du USER $SamAccountName" -Head "INFO"
            }
            Catch
            {
                write-host "Création du USER" $SamAccountName  "échoué" -ForegroundColor red
                Log -FilePath $LogFile -Content "Création du USER $SamAccountName échoué" -Head "FATAL"
            }
        }
        Else
        {
            Write-Host "L'utilsateur $SamAccountName existe déjà" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'utilsateur $SamAccountName existe déjà"   -Head "ERROR"
        }

        $Count++
        sleep -Milliseconds 100
    }
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
$LogFile = "$LogPath\Log_Script_Utilisateurs_Auto.log"

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

Write-Host "Debut création Utilisateurs" -ForegroundColor Blue
Write-Host "" 
FctAjoutUtilisateurs
Write-Host "" 
Write-Host "Fin création Utilisateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ..."
sleep -Seconds 1
clear-host


Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1


############## FIN DU SCRIPT ######################
