######################################################################################################
#                                                                                                    #
#   Création OU  #
#                                                                                                    #
######################################################################################################

### Fichier a récupérer
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\s09_Pharmgreen.csv"
$DomainDN = (Get-ADDomain).DistinguishedName
### Initialisation
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

# Définir le nom des deux OU Principal
$DomainDN = (Get-ADDomain).DistinguishedName
$OUPrincipaleUser = "User_Pharmgreen"
$OUUserDisable = "User_Pharmgreen_Disable"
$OUPrincipaleComputer = "Computer_Pharmgreen"
$PathOUUser= "OU=$OUPrincipaleUser,$DomainDN"
$PathOUComputer= "OU=$OUPrincipaleComputer,$DomainDN"

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

        }
        Catch
        {
            Write-Host "Création de l'OU `"ou=$OUPrincipal,$DomainDN) échoué" -ForegroundColor Green
        }
    }
    Else
    {
        Write-Host "L'OU `"ou=$OUPrincipal,$DomainDN`" existe déjà" -ForegroundColor Yellow
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
            }
            catch
            {
                Write-Host "Création de l'OU `"ou=$Departement,$PathOU`" échoué" -ForegroundColor Green
            }
        }
        else
        {
            Write-Host "L'OU `"ou=$Departement,$PathOU`" existe déjà" -ForegroundColor Yellow
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
                }
                catch
                {
                    Write-Host "Création de l'OU `"ou=$Service,$PathService`" échoué" -ForegroundColor red
                }
            }
            else
            {
                Write-Host "L'OU `"ou=$Service,$PathService`" existe déjà" -ForegroundColor Yellow
            }
        }
    }
}

# Appeler la fonction CreateOUPrincipal
CreateOUPrincipal -OUPrincipal $OUPrincipaleUser
CreateOUPrincipal -OUPrincipal $OUUserDisable
CreateOU -PathOU $PathOUUser
CreateousOU -PathOU $PathOUUser

CreateOUPrincipal -OUPrincipal $OUPrincipaleComputer
CreateOU -PathOU $PathOUComputer
CreateousOU -PathOU $PathOUComputer
