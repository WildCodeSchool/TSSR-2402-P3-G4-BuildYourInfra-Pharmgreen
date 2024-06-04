# Récupération du répertoire du script en cours d'exécution
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

# Définition du chemin d'accès au fichier CSV
$File = "$FilePath\s09_Pharmgreen.csv"

# Définition des en-têtes de colonnes du fichier CSV
$Headers = "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail"

function CreateDossiers
{
    # Importation des données à partir du fichier CSV et sélection des lignes à partir de la deuxième ligne
    $Datas = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1

    # Groupement des données par nom de département
    $DossierDepartements = $Datas | Group-Object -Property Departement

    foreach ($DossierDepartement in $DossierDepartements)
    {
        $NomDepartement = $DossierDepartement.Name
        $PathFolder = "E:\Dossier_Departement\$NomDepartement"

        if (Test-Path -Path $PathFolder)
        {
            Write-Host "Le dossier $NomDepartement existe déjà." -ForegroundColor Yellow
        }
        else
        {
            try
            {
                New-Item -ItemType Directory -Path $PathFolder | Out-Null
                Write-Host "Le dossier $NomDepartement a été créé avec succès à l'emplacement $PathFolder." -ForegroundColor Green
            }
            catch
            {
                Write-Host "Échec de la création du dossier $NomDepartement. Erreur : $_" -ForegroundColor Red
            }
        }
    }

    # Groupement des données par nom de département et service
    $DossierServices = $Datas | Group-Object -Property Departement, Service

    foreach ($DossierService in $DossierServices)
    {
        $NomDepartement = $DossierService.Name.Split(',')[0]
        $NomService = $DossierService.Name.Split(',')[1]
        $PathFolder = "C:\Partage\$NomDepartement\$NomService"

        if (Test-Path -Path $PathFolder)
        {
            Write-Host "Le dossier $NomService du département $NomDepartement existe déjà." -ForegroundColor Yellow
        }
        else
        {
            try
            {
                New-Item -ItemType Directory -Path $PathFolder | Out-Null
                Write-Host "Le dossier $NomService du département $NomDepartement a été créé avec succès à l'emplacement $PathFolder." -ForegroundColor Green
            }
            catch
            {
                Write-Host "Échec de la création du dossier $NomService du département $NomDepartement. Erreur : $_" -ForegroundColor Red
            }
        }
    }
}

# Appel de la fonction pour créer les dossiers
CreateDossiers
