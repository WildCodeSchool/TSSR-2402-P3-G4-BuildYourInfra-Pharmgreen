######################################################################################################
#                                                                                                    #
#   Fichier de modificaiton utilisateur    #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "$FilePath\s09_Pharmgreen.csv"

### Main program

If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

# Imporation des données
$Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "PC", "DateDeNaissance", ` "Telf", "Telp", "Nomadisme - Télétravail" | Select-Object -Skip 1
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
        $ManagerDN = (Get-ADUser -Identity $Manager ).DistinguishedName

    If (($ADUsers | Where-Object {$_.SamAccountName -eq $SamAccountName}) -ne $Null)
    {
        Try 
        {
            Set-ADUser -Identity  $SamAccountName -Manager $ManagerDN
            Write-Host "Manageur $ManagerNom $ManagerPrenom ajouté à $Name" -ForegroundColor Green
        }
        Catch  
        {
            write-host "Manageur $ManagerNom $ManagerPrenom n'a pas put être ajouté à  $Name échoué" -ForegroundColor red

        }
    }
    Else
    {
        Write-Host "L'utilisateur $SamAccountName n'existe pas" -ForegroundColor Yellow 
    }
    
    $Count++
    sleep -Milliseconds 100

}



