
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

$Users = Import-Csv -Path $File -Delimiter "," -Header $Headers | Select-Object -Skip 1
$ADUsers = Get-ADUser -Filter * -Properties *
### Main
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
                        }
                        Catch 
                        { write-host "Ajout compte $SamAccountName dans le $Groupmenber  échoué " -ForegroundColor red
                        }
                }
                Else
                {
                        Write-Host "Le compte $SamAccountName n'exite pas" -ForegroundColor Yellow
                }
                $Count++
                sleep -Milliseconds 100
     }