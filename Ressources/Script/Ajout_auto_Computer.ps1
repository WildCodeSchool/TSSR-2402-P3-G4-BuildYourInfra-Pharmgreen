#######################################
#                                     #
#   Création de PC Automatique        #
#                                     #
#######################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$File = "$FilePath\s09_Pharmgreen.csv"

$Computers = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "Ordinateur", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail" | Select-Object -Skip 1
$ADComputer = Get-ADComputer -Filter * -Properties *
$DomainDN = (Get-ADDomain).DistinguishedName
$Count = 1
foreach ($Computer in $Computers)
{
    Write-Progress -Activity "Création des ordinateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Computers.Length*100)
    # Gestion de présence de Sous OU
    if ( $Computer.Service -eq "NA" )
    {
        # Chemin complet
        $Path = "OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
    }
    Else
    {
        # Chemin sans sous OU
        $Path ="OU=$($Computer.Service),OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
    }
    # Ajout automatique des ordinateurs
    If (($ADComputer | Where {$_.Name -eq $Computer.Ordinateur}) -eq $Null)
    {
        Try {
            New-ADComputer -Name $Computer.Ordinateur -Path $Path -Description "ID $Ordinateur"
            Write-Host "Création de l'ordinateur $($Computer.Ordinateur) dans l'OU $Path réussie" -ForegroundColor Green
        }
        Catch
        {
            Write-Host "Création de l'ordinateur $($Computer.Ordinateur) dans l'OU $Path échoué" -ForegroundColor Red
        }
    }
    Else
    {
        Write-Host "L'ordinateur $($Computer.Ordinateur) dans l'OU $Path existe déjà" -ForegroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}
