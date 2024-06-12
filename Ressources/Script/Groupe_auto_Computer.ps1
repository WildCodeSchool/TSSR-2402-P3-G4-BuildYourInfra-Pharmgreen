####################################################
####################################################
### SCRIPT MODIFICAITON INFORMATION  Ordinateurs ###                                           
####################################################
####################################################

####################################################
################### FONCTION #######################
####################################################

############## DEBUT FONCTION ######################

# Fonction création groupe OU et affection groupe Computer principal
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
                $NomGroupe  = "GRP_C_" + $NomOu
                $PathOU = "OU=$($Group.Name),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"


                Write-Progress -Activity "Création des groupes Principaux des OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                {
                        Try 
                        {
                                New-AdGroup -Name $NomGroupe -Path $PathOU -GroupScope Global -GroupCategory Security
                                Write-Host "Création du groupe $NomGroupe dans l'OU $PathOU réussie" -ForegroundColor Green
                                Add-ADGroupMember -Identity "GRP_C_Computers" -Members $NomGroupe
                                Write-Host "Ajout groupe $NomGroupe dans le GRP_C_Computers réussit" -ForegroundColor Green
                        }
                        Catch 
                        { 
                                write-host "Création du groupe $NomGroupe dans l'OU $PathOU échoué" -ForegroundColor red
                        }
                        }
                Else
                        {
                        Write-Host "Le groupe $NomGroupe dans l'OU $PathOU existe déjà" -ForegroundColor Yellow
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
                        $NomGroupe  = "GRP_C_" + $Service
                        # Définir le chemin d'accès à l'OU du service
                        $PathService = "OU=$Service,Ou=$Departement,OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
                        $NomGroupMember="GRP_C_" + $Departement

                        Write-Progress -Activity "Création des groupes Principaux des sous OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                        # Ajout automatique des groupes
                        If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                        {
                                Try 
                                {
                                        New-AdGroup -Name $NomGroupe -Path $PathService -GroupScope Global -GroupCategory Security
                                        Write-Host "Création du groupe $NomGroupe dans l'OU $PathService réussie" -ForegroundColor Green
                                }
                                Catch 
                                { 
                                        write-host "Création du groupe $NomGroupe dans l'OU $PathService échoué" -ForegroundColor red
                                }
                                }
                        Else
                                {
                                Write-Host "Le groupe $NomGroupe dans l'OU $Path existe déjà" -ForegroundColor Yellow
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
                        $NomGroupe  = "GRP_C_" + $Service
                        # Définir le chemin d'accès à l'OU du service
                        $NomGroupMember="GRP_C_" + $Departement

                        Write-Progress -Activity "Création des groupes Principaux des sous OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                        # Ajout automatique des groupes
                        If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -ne $Null)
                        {
                                Try 
                                {
                                        Add-ADGroupMember -Identity $NomGroupMember -Members $NomGroupe
                                        Write-Host "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -ForegroundColor Green
                                }
                                Catch 
                                { 
                                        write-host "Ajout groupe $NomGroupe dans le $NomGroupMember échoué " -ForegroundColor red
                                }
                        }
                        Else
                        {       
                                Write-Host "Le groupe $NomGroupe n'exite pas" -ForegroundColor Yellow
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
        $ComputerGroups = $Groups | Group-Object -Property Departement, Service, Groupe_Computer

        foreach ($Group in $ComputerGroups) 
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
                        $Path = "OU=$Departement,OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
                }
                Else
                # Chemin complet
                { 
                        $Path ="OU=$service,OU=$Departement,OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"      
                }
                
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -eq $Null)
                {
                        Try 
                        {
                                New-AdGroup -Name $NomGroupe -Path $Path -GroupScope Global -GroupCategory Security
                                Write-Host "Création du groupe $NomGroupe dans l'OU $Path réussie" -ForegroundColor Green
                                

                        }
                        Catch 
                        { 
                                write-host "Création du groupe $NomGroupe dans l'OU $Path échoué" -ForegroundColor red
                        }
                }
                Else
                {
                        Write-Host "Le groupe $NomGroupe dans l'OU $Path existe déjà" -ForegroundColor Yellow
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
        $ComputerGroups = $Groups | Group-Object -Property Departement, Service, Groupe_Computer

        foreach ($Group in $ComputerGroups) 
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
                        $NomGroupMember= "GRP_C_" + $Departement
                }
                Else
                # Chemin complet
                { 
                        $NomGroupMember= "GRP_C_" + $service
                }
                
                # Affectation automatique des groupes
               If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -ne $Null)
                {
                        Try {
                        Add-ADGroupMember -Identity $NomGroupMember -Members $NomGroupe
                        Write-Host "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -ForegroundColor Green
                        }
                        Catch 
                        { write-host "Ajout groupe $NomGroupe dans le $NomGroupMember échoué " -ForegroundColor red
                        }
                }
                Else
                {
                        Write-Host "Le groupe $NomGroupe n'exite pas" -ForegroundColor Yellow
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
$File = "$FilePath\s09_Pharmgreen.csv"

# Définition des en-têtes de colonnes du fichier CSV
$Headers = "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail", "Groupe_User","Groupe_Computer"

# Appel modul Active Directory si pas présent
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

# Création groupe Global 
$GroupNamePrincipal = "GRP_C_Computers"
$groupPath = "OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
Write-Host "Vérification Groupe Global Ordinateurss existe, si non existant il sera créé " -ForegroundColor Blue
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


Write-Host "Debut création des Groupes Ordinateurs" -ForegroundColor Blue
Write-Host "" 
FctCreationGroupe
Write-Host "" 
Write-Host "Fin création des Groupes Ordinateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut ajout de des Groupes Ordinateurs dans Groupe Principal" -ForegroundColor Blue
Write-Host "" 
FctAjoutSousGRoupAGroup
Write-Host "" 
Write-Host "Fin ajout de des Groupes Ordinateurs dans Groupe Principal" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
