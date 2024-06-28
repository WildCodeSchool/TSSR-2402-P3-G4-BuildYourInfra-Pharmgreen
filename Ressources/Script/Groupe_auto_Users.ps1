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

# Fonction création groupe OU et affection groupe user principal
function FctCreationGroupeOU
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1
        # Groupement des données par nom de département
        $OUGroups = $Groups | Group-Object -Property Departement
        foreach ($Group in $OUGroups) 
        {  
                
                # Récupération des données nécessaires à la création des Groupes
                $NomOu=$Group.Name
                $NomGroupe  = "GRP_U_" + $NomOu
                $PathOU = "OU=$($Group.Name),OU=User_Pharmgreen,DC=pharmgreen,DC=org"


                Write-Progress -Activity "Création des groupes Principaux des OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                {
                        Try 
                        {
                                New-AdGroup -Name $NomGroupe -Path $PathOU -GroupScope Global -GroupCategory Security
                                Write-Host "Création du groupe $NomGroupe dans l'OU $PathOU réussie" -ForegroundColor Green
                                Add-ADGroupMember -Identity "GRP_U_Users" -Members $NomGroupe
                                Write-Host "Ajout groupe $NomGroupe dans le GRP_U_Users réussit" -ForegroundColor Green
                                Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $PathOU réussie" -Head "INFO"
                                Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le GRP_U_Users réussit" -Head "INFO"
                        }
                        Catch 
                        { 
                                write-host "Création du groupe $NomGroupe dans l'OU $PathOU échoué" -ForegroundColor red
                                Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $PathOU échoué"  -Head "FATAL"
                        }
                        }
                Else
                        {
                        Write-Host "Le groupe $NomGroupe dans l'OU $PathOU existe déjà" -ForegroundColor Yellow
                        Log -FilePath $LogFile -Content "Le groupe $NomGroupe dans l'OU $PathOU existe déjà" - -Head "ERROR"
                        }
                $Count++
                sleep -Milliseconds 100
        }
}

# Fonction création groupe sous OU
function FctCreationGroupeSousOU
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1
        # Groupement des données par nom de département et service
        $OUGroups = $Groups | Group-Object -Property Departement, Service

        foreach ($Group in $OUGroups) 
        {  
                # Récupération des données nécessaires à la création des Groupes
                $Departement = $Group.Name.Split(',')[0].Trim()
                $Service = $Group.Name.Split(',')[1].Trim()
                
                # Si la collone Service à le nom "NA" exclure de la création
                if ($Service -ne "NA")
                {
                        $NomOu=$Service
                        $NomGroupe  = "GRP_U_" + $Service
                        # Définir le chemin d'accès à l'OU du service
                        $PathService = "OU=$Service,Ou=$Departement,OU=User_Pharmgreen,DC=pharmgreen,DC=org"
                        $NomGroupMember="GRP_U_" + $Departement

                        Write-Progress -Activity "Création des groupes Principaux des sous OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                        # Ajout automatique des groupes
                        If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                        {
                                Try 
                                {
                                        New-AdGroup -Name $NomGroupe -Path $PathService -GroupScope Global -GroupCategory Security
                                        Write-Host "Création du groupe $NomGroupe dans l'OU $PathService réussie" -ForegroundColor Green
                                        Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $PathService réussie" -Head "INFO"
                                }
                                Catch 
                                { 
                                        write-host "Création du groupe $NomGroupe dans l'OU $PathService échoué" -ForegroundColor red
                                        Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $PathService échoué" -Head "FATAL"
                                }
                                }
                        Else
                                {
                                Write-Host "Le groupe $NomGroupe dans l'OU $Path existe déjà" -ForegroundColor Yellow
                                Log -FilePath $LogFile -Content "Le groupe $NomGroupe dans l'OU $Path existe déjà"  -Head "ERROR"
                                }

                        $Count++
                        sleep -Milliseconds 100
                }
        }
}

# Fonction affection groupe sous OU au groupe superieur
function FctAffectationGroupeSousOU
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1
        # Groupement des données par nom de département et service
        $OUGroups = $Groups | Group-Object -Property Departement, Service

        foreach ($Group in $OUGroups) 
        {  
                # Récupération des données nécessaires à la création des Groupes
                $Departement = $Group.Name.Split(',')[0].Trim()
                $Service = $Group.Name.Split(',')[1].Trim()
                
                # Si la collone Service à le nom "NA" exclure de la création
                if ($Service -ne "NA")
                {
                        $NomOu=$Service
                        $NomGroupe  = "GRP_U_" + $Service
                        # Définir le chemin d'accès à l'OU du service
                        $NomGroupMember="GRP_U_" + $Departement

                        Write-Progress -Activity "Création des groupes Principaux des sous OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                        # Ajout automatique des groupes
                        If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -ne $Null)
                        {
                                Try 
                                {
                                        Add-ADGroupMember -Identity $NomGroupMember -Members $NomGroupe
                                        Write-Host "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -ForegroundColor Green
                                        Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -Head "INFO"
                                }
                                Catch 
                                { 
                                        write-host "Ajout groupe $NomGroupe dans le $NomGroupMember échoué" -ForegroundColor red
                                        Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le $NomGroupMember échoué" -Head "FATAL"
                                }
                        }
                        Else
                        {       
                                Write-Host "Le groupe $NomGroupe n'exite pas" -ForegroundColor Yellow
                                Log -FilePath $LogFile -Content "Le groupe $NomGroupe n'exite pas"  -Head "ERROR"
                        }


                        $Count++
                        sleep -Milliseconds 100
                }
        }
}

# Fonction création groupe
function FctCreationGroupe
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header $Headers| Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1

        # Groupement des données par nom de département et service
        $UserGroups = $Groups | Group-Object -Property Departement, Service, Groupe_User

        foreach ($Group in $UserGroups) 
        {  
                # Récupération des données nécessaires à la création des Groupes
                $Departement = $Group.Name.Split(',')[0].Trim()
                $Service = $Group.Name.Split(',')[1].Trim()
                $NomGroupe = $Group.Name.Split(',')[2].Trim()

                Write-Progress -Activity "Création des groupes dans les OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                # Gestion de présence de Sous OU
                if ( $Service -eq "NA" )
                # Chemin sans sous OU
                { 
                        $Path = "OU=$Departement,OU=User_Pharmgreen,DC=pharmgreen,DC=org"
                }
                Else
                # Chemin complet
                { 
                        $Path ="OU=$service,OU=$Departement,OU=User_Pharmgreen,DC=pharmgreen,DC=org"      
                }
                
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                {
                        Try 
                        {
                                New-AdGroup -Name $NomGroupe -Path $Path -GroupScope Global -GroupCategory Security
                                Write-Host "Création du groupe $NomGroupe dans l'OU $Path réussie" -ForegroundColor Green
                                Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $Path réussie" -Head "INFO"
                                

                        }
                        Catch 
                        { 
                                write-host "Création du groupe $NomGroupe dans l'OU $Path échoué" -ForegroundColor red
                                Log -FilePath $LogFile -Content "Création du groupe $NomGroupe dans l'OU $Path échoué" -Head "FATAL"
                        }
                }
                Else
                {
                        Write-Host "Le groupe $NomGroupe dans l'OU $Path existe déjà" -ForegroundColor Yellow
                        Log -FilePath $LogFile -Content "Le groupe $NomGroupe dans l'OU $Path existe déjà"  -Head "ERROR"
                }
                $Count++
                sleep -Milliseconds 100
        }
}

# Fonction Affectation automatique des groupes groupe
function FctAjoutSousGRoupAGroup
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header $Headers| Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1

        # Groupement des données par nom de département et service
        $UserGroups = $Groups | Group-Object -Property Departement, Service, Groupe_User

        foreach ($Group in $UserGroups) 
        {  
                # Récupération des données nécessaires à la création des Groupes
                $Departement = $Group.Name.Split(',')[0].Trim()
                $Service = $Group.Name.Split(',')[1].Trim()
                $NomGroupe = $Group.Name.Split(',')[2].Trim()

                Write-Progress -Activity "Création des groupes dans les OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                # Gestion de présence de Sous OU
                if ( $Service -eq "NA" )
                # Chemin sans sous OU
                { 
                        $NomGroupMember= "GRP_U_" + $Departement
                }
                Else
                # Chemin complet
                { 
                        $NomGroupMember= "GRP_U_" + $service
                }
                
                # Affectation automatique des groupes
               If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -ne $Null)
                {
                        Try {
                        Add-ADGroupMember -Identity $NomGroupMember -Members $NomGroupe
                        Write-Host "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -ForegroundColor Green
                        Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -Head "INFO"
                        }
                        Catch 
                        { write-host "Ajout groupe $NomGroupe dans le $NomGroupMember échoué" -ForegroundColor red
                        Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le $NomGroupMember échoué" -Head "FATAL"
                        }
                }
                Else
                {
                        Write-Host "Le groupe $NomGroupe n'exite pas" -ForegroundColor Yellow
                        Log -FilePath $LogFile -Content "Ajout groupe $NomGroupe dans le $NomGroupMember échoué"  -Head "ERROR"
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
$LogFile = "$LogPath\Log_Script_Groupe_Auto_Users.log"

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

# Création groupe Global 
$GroupNamePrincipal = "GRP_U_Users"
$groupPath = "OU=User_Pharmgreen,DC=pharmgreen,DC=org"
Write-Host "Vérification Groupe Global Utilisateurs existe, si non existant il sera créé " -ForegroundColor Blue
Write-Host "" 
$ADGroup = Get-ADGroup -Filter * -Properties *
if (($ADGroup  | Where {$_.Name -eq $GroupNamePrincipal }) -ne $Null)
{
    # Le groupe existe déjà, afficher un message
    Write-Host "Le groupe $GroupNamePrincipal existe déjà." -ForegroundColor Green
} else 
{
    # Le groupe n'existe pas, le créer
    New-ADGroup -Name $GroupNamePrincipal -Path $groupPath -GroupScope Global -GroupCategory Security
    Write-Host "Le groupe $GroupNamePrincipal a été créé avec succès ." -ForegroundColor Green
}
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création des Groupe des OU" -ForegroundColor Blue
Write-Host "" 
FctCreationGroupeOU
Write-Host "" 
Write-Host "Fin création de Groupe des OU" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création des Groupe des sous OU" -ForegroundColor Blue
Write-Host "" 
FctCreationGroupeSousOU
Write-Host "" 
Write-Host "Fin création des Groupe des sous OU" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut Affectation des Groupe des sous OU" -ForegroundColor Blue
Write-Host "" 
FctAffectationGroupeSousOU
Write-Host "" 
Write-Host "Fin Affectation des Groupe des sous OU" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création des Groupes Utilisateur" -ForegroundColor Blue
Write-Host "" 
FctCreationGroupe
Write-Host "" 
Write-Host "Fin création des Groupes Utilisateur" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut ajout de des Groupes Utilisateur dans Groupe Principal" -ForegroundColor Blue
Write-Host "" 
FctAjoutSousGRoupAGroup
Write-Host "" 
Write-Host "Fin ajout de des Groupes Utilisateur dans Groupe Principal" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1


############## FIN DU SCRIPT ######################
