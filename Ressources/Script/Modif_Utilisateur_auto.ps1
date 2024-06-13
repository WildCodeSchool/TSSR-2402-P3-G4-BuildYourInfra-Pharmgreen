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
    param([string]$Content)

    # Vérifie si le fichier existe, sinon le crée
    # Construit la ligne de journal
    $Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$Date;$User;$Content"

    # Ajoute la ligne de journal au fichier
    Add-Content -Path $LogFile -Value $logLine
}
  
# Fonction modifcation utilisateur 
function ModifUserAD 
{ 
      # Imporation des données
    $Users = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
    $ADUsers = Get-ADUser -Filter * -Properties *
    $Count = 1
    Foreach ($User in $Users)
    {
        Write-Progress -Activity "Ajout des managers" -Status "% effectué" -PercentComplete ($Count/$Users.Length*100)
        $Name              = "$($User.Nom) $($User.Prenom)"
        $SamAccountName    = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
        $Manager           = $($User.ManagerPrenom.ToLower())+ "." + $($User.ManagerNom.ToLower())
        $ManagerPrenom     = $User.ManagerPrenom
        $ManagerNom        = $User.ManagerNom


            # Ajout des manager
            # Récupérer le DN du manager
            If ($Manager -ne '.')
            {
             $ManagerDN = (Get-ADUser -Identity $Manager ).DistinguishedName
            }

        If (($ADUsers | Where-Object {$_.SamAccountName -eq $SamAccountName}) -ne $Null)
        {
            If ($Manager -eq '.')
            {
                Write-Host "L'utilisateur $SamAccountName n'a pas de manager" -ForegroundColor Yellow 
                Log -FilePath $LogFile -Content "L'utilisateur $SamAccountName n'a pas de manager" 
            }
            Else
            {
                Try 
                {
                    Set-ADUser -Identity  $SamAccountName -Manager $ManagerDN 
                    Write-Host "Manager $ManagerNom $ManagerPrenom ajouté à $Name" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Manager $ManagerNom $ManagerPrenom ajouté à $Name" 
                }
                Catch 
                {
                    write-host "Manager $ManagerNom $ManagerPrenom n'a pas put être ajouté à  $Name échoué" -ForegroundColor red
                    Write-Host $_.Exception.Message -ForegroundColor Red
                    Log -FilePath $LogFile -Content "Manager $ManagerNom $ManagerPrenom n'a pas put être ajouté à  $Name échoué" 
                }
            }
        }
        Else
        {
            Write-Host "L'utilisateur $SamAccountName n'existe pas" -ForegroundColor Yellow 
            Log -FilePath $LogFile -Content "L'utilisateur $SamAccountName n'existe pas"
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
$LogPath=  "C:\Log\"
$LogFile=  "$LogPath\Log_ScripModif_User.log"
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

# Gestion des messages d'erreur

############## APPEL FONCTION ######################

#Initialisation fonction LOG

Write-Host "Debut de modification des informations utilsiateurs" -ForegroundColor Blue
Write-Host "" 
ModifUserAD 
Write-Host "Fin de modification des informations utilsiateurs" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "


############## FIN DU SCRIPT ######################


