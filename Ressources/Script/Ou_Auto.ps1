####################################################
####################################################
########   SCRIPT CREATION/MODIFICATION OU  ########
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

function CreateOUPrincipal
{     
    param( [Parameter(Mandatory=$true)][string]$OUPrincipal )
    if ((Get-ADOrganizationalUnit -Filter {Name -like $OUPrincipal} -SearchBase $DomainDN) -eq $Null)
    {  
        Try 
        {
            New-ADOrganizationalUnit -Name $OUPrincipal -Path $DomainDN
            $OUObj = Get-ADOrganizationalUnit "ou=$OUPrincipal,$DomainDN"
            $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
            Write-Host "Création de l'OU `"ou=$OUPrincipal,$DomainDN réussit" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création de l'OU `"ou=$OUPrincipal,$DomainDN réussit" -Head "INFO"

        }
        Catch
        {
            Write-Host "Création de l'OU `"ou=$OUPrincipal,$DomainDN) échoué" -ForegroundColor Red
            Log -FilePath $LogFile -Content "Création de l'OU `"ou=$OUPrincipal,$DomainDN) échoué" -Head "FATAL"
        }
    }
    Else
    {
        Write-Host "L'OU `"ou=$OUPrincipal,$DomainDN`" existe déjà" -ForegroundColor Yellow
        Log -FilePath $LogFile -Content "L'OU `"ou=$OUPrincipal,$DomainDN`" existe déjà" -Head "ERROR"
    }
}


function CreateOU
{
    param( [Parameter(Mandatory=$true)][string]$PathOU )

    # Imporattation des données
    $OUData = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail" | Select-Object -Skip 1 

    # Groupement des données par nom de département et de service
    $OUGroups = $OUData | Group-Object -Property Departement

    foreach ($OUGroup in $OUGroups)
    {
        # Récupération des données nécessaires à la création des OU
        $Departement = $OUGroup.Name       

        # Vérifier si l'OU du département existe, sinon la créer
        if((Get-ADOrganizationalUnit -Filter {Name -like $Departement} -SearchBase $PathOU) -eq $Null)
        {
            try
            {
                New-ADOrganizationalUnit -Name $Departement -Path $PathOU
                $OUObj = Get-ADOrganizationalUnit "ou=$Departement,$PathOU"
                $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
                Write-Host "Création de l'OU `"ou=$Departement,$PathOU`" réussit" -ForegroundColor Green
                Log -FilePath $LogFile -Content "Création de l'OU `"ou=$Departement,$PathOU`" réussit"  -Head "INFO"
            }
            catch
            {
                Write-Host "Création de l'OU `"ou=$Departement,$PathOU`" échoué" -ForegroundColor Red
                Log -FilePath $LogFile -Content "Création de l'OU `"ou=$Departement,$PathOU`" échoué"  -Head "FATAL"
            }
        }
        else
        {
            Write-Host "L'OU `"ou=$Departement,$PathOU`" existe déjà" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'OU `"ou=$Departement,$PathOU`" existe déjà" -Head "ERROR"
        }        
    }
}

function CreateousOU
{
    param( [Parameter(Mandatory=$true)][string]$PathOU )

    # Imporattation des données
    $OUDatas = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail" | Select-Object -Skip 1

    # Groupement des données par nom de département et de service
    $OUGroups = $OUDatas | Group-Object -Property Departement, Service

    foreach ($OUGroup in $OUGroups)
    {
        # Récupération des données nécessaires à la création des OU
        $Departement = $OUGroup.Name.Split(',')[0].Trim()
        $Service = $OUGroup.Name.Split(',')[1].Trim()

        # Si la collone Service à le nom "NA" exclure de la création
        if ($Service -ne "NA")
        {
            # Définir le chemin d'accès à l'OU du service
            $PathService = "Ou=$Departement,$PathOU"

            # Vérifier si l'OU du service existe, sinon la créer
            if((Get-ADOrganizationalUnit -Filter {Name -like $Service} -SearchBase $PathOU) -eq $Null)
            {
                try
                {
                    New-ADOrganizationalUnit -Name $Service -Path $PathService
                    $OUObj = Get-ADOrganizationalUnit "ou=$Service,$PathService"
                    $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
                    Write-Host "Création de l'OU `"ou=$Service,$PathService`" réussit" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Création de l'OU `"ou=$Service,$PathService`" réussit"  -Head "INFO"
                }
                catch
                {
                    Write-Host "Création de l'OU `"ou=$Service,$PathService`" échoué" -ForegroundColor red
                    Log -FilePath $LogFile -Content "Création de l'OU `"ou=$Service,$PathService`" échoué"  -Head "FATAL"
                }
            }
            else
            {
                Write-Host "L'OU `"ou=$Service,$PathService`" existe déjà" -ForegroundColor Yellow
                Log -FilePath $LogFile -Content "L'OU `"ou=$Service,$PathService`" existe déjà" -Head "ERROR"
            }
        }
    }
}


############## FIN FONCTION ######################


####################################################
############# DEBUT SCRIPT #########################
####################################################

############## INITIALISATION ######################

### Chemin des dossiers et fichiers à lire et exploiter
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\\s14_Pharmgreen.csv"
$LogPath = "C:\Log"
$LogFile = "$LogPath\Log_Script_OU_Auto.log"

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

# Définir le nom des OU Principales
$DomainDN = (Get-ADDomain).DistinguishedName
$OUPrincipaleUser = "User_Pharmgreen"
$OUUserDisable = "User_Pharmgreen_Disable"
$OUPrincipaleComputer = "Computer_Pharmgreen"
$PathOUUser= "OU=$OUPrincipaleUser,$DomainDN"
$PathOUComputer= "OU=$OUPrincipaleComputer,$DomainDN"



############## APPEL FONCTION ######################

# Appel des fonction de création OU Utilisateurs


Write-Host "Debut création OU Principal Utilisateurs" -ForegroundColor Blue
Write-Host "" 
CreateOUPrincipal -OUPrincipal $OUPrincipaleUser
Write-Host "" 
Write-Host "Fin création OU Principal Utilisateurs " -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création OU Utilisateurs Désactivé" -ForegroundColor Blue
Write-Host "" 
CreateOUPrincipal -OUPrincipal $OUUserDisable
Write-Host "" 
Write-Host "Fin création OU Utilisateurs Désactivé" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création OU Départements Utilisateurs " -ForegroundColor Blue
Write-Host "" 
CreateOU -PathOU $PathOUUser
Write-Host "" 
Write-Host "Fin création OU Départements Utilisateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création OU Services Utilisateurs " -ForegroundColor Blue
Write-Host "" 
CreateousOU -PathOU $PathOUUser
Write-Host "" 
Write-Host "Fin création OU Services Utilisateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

# Appel des fonction de création OU Ordinateurs

Write-Host "Debut création OU Principal Ordinateurs" -ForegroundColor Blue
Write-Host "" 
CreateOUPrincipal -OUPrincipal $OUPrincipaleComputer
Write-Host "" 
Write-Host "Fin création OU Principal Ordinateurs " -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création OU Départements Ordinateurs " -ForegroundColor Blue
Write-Host "" 
CreateOU -PathOU $PathOUComputer
Write-Host "" 
Write-Host "Fin création OU Départements Ordinateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création OU Services Ordinateurs " -ForegroundColor Blue
Write-Host "" 
CreateousOU -PathOU $PathOUComputer
Write-Host "" 
Write-Host "Fin création OU Services Ordinateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host


