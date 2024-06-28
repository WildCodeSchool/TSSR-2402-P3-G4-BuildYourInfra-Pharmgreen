####################################################
####################################################
### SCRIPT MODIFICATION INFORMATION UTILISATEUR ###
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

# Fonction pour ajouter les managers
function AddUserManager
{
    param (
        [string]$SamAccountName,
        [string]$Manager
    )

    # Récupérer le DN du manager
    if ($Manager -ne '.')
    {
        $ManagerDN = (Get-ADUser -Identity $Manager).DistinguishedName
    }

    if ($Manager -eq '.')
    {
        Write-Host "L'utilisateur $SamAccountName n'a pas de manager" -ForegroundColor Yellow
        Log -FilePath $LogFile -Content "L'utilisateur $SamAccountName n'a pas de manager" -Head "ERROR"
    }
    else
    {
        try
        {
            Set-ADUser -Identity $SamAccountName -Manager $ManagerDN
            Write-Host "Manager $Manager ajouté à $SamAccountName" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Manager $Manager ajouté à $SamAccountName" -Head "INFO"
        }
        catch
        {
            write-host "Manager $Manager n'a pas pu être ajouté à $SamAccountName" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            Log -FilePath $LogFile -Content "Manager $Manager n'a pas pu être ajouté à $SamAccountName" -Head "FATAL"
        }
    }
}

# Fonction pour modifier les informations de l'utilisateur
function ModifyUserInfo
{
    # Importation des données
    $Users = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
    $ADUsers = Get-ADUser -Filter * -Properties *
    $Count = 1

    Foreach ($User in $Users)
    {
        Write-Progress -Activity "Modification des informations utilisateurs" -Status "% effectué" -PercentComplete ($Count/$Users.Length*100)
        $Name              = "$($User.Nom) $($User.Prenom)"
        $SamAccountName    = $($User.Prenom.ToLower()) + "." + $($User.Nom.ToLower())
        $UserPrincipalName = $(($User.Prenom.ToLower() + "." + $User.Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
        $GivenName         = $User.Prenom
        $Surname           = $User.Nom
        $OfficePhone       = $User.Telf
        $PortablePhone     = $User.Telp
        $EmailAddress      = $UserPrincipalName
        $Site              = $User.Site
        $birthday          = $User.DateDeNaissance
        $Department        = "$($User.Departement)"
        $Service           = "$($User.Service)"
        $Fonction          = "$($User.fonction)"
        $Company           = $User.Societe
        $Manager           = $($User.ManagerPrenom.ToLower())+ "." + $($User.ManagerNom.ToLower())
        $ManagerPrenom     = $User.ManagerPrenom
        $ManagerNom        = $User.ManagerNom


        # Gestion de présence de Sous OU
        if ($User.Service -eq "NA")
        {
            $Path = "ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        }
        else
        {
            $Path = "ou=$($User.Service),ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        }

        $existingUser = $ADUsers | Where-Object { $_.GivenName -eq $GivenName -and $_.Description -eq $birthday }

        if ($existingUser -ne $Null)
        {
            try
            {
                #Modification des infos utilisateurs
                Set-ADUser -Identity $SamAccountName `
                -HomePhone $OfficePhone -MobilePhone $PortablePhone `
                -Office $Site -Description $birthday -Title $Fonction -City $Site `
                -Department $Department -Company $Company
                #Deplacement des utilisateurs dans les nouvelles OU
                $NewOU = Get-ADUser -Identity $SamAccountName
                Move-ADObject -Identity $NewOU.DistinguishedName -TargetPath $Path -Confirm:$false

                Write-Host "Modification de l'utilisateur $SamAccountName effectuée" -ForegroundColor Green
                Log -FilePath $LogFile -Content "Modification de l'utilisateur $SamAccountName effectuée" -Head "INFO"
            }
            catch
            {
                Write-Host "Modification de l'utilisateur $SamAccountName échouée" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
                Log -FilePath $LogFile -Content "Modification de l'utilisateur $SamAccountName échouée" -Head "FATAL"
            }

            # Appel de la fonction pour ajouter le manager
            AddUserManager -SamAccountName $SamAccountName -Manager $Manager
        }
        else
        {
            Write-Host "L'utilisateur $SamAccountName n'existe pas" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'utilisateur $SamAccountName n'existe pas" -Head "ERROR"
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
$LogFile = "$LogPath\Log_Script_Modif_User.log"

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

############## APPEL FONCTION ######################

Write-Host "Debut modification des informations utilsiateurs " -ForegroundColor Blue
Write-Host "" 
ModifyUserInfo
Write-Host "" 
Write-Host "Fin des modifications des informations utilsiateurs " -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script et si il y a des utilisateurs qui doivent être modifié manuellement" -ForegroundColor blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

############## FIN DU SCRIPT ######################
