#######################################
#                                     #
# Création de ordintauers automatique #
#                                     #
#######################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$File = "$FilePath\liste_Computer.csv"

$Computers = Import-Csv -Path $File -Delimiter "," -Header "Ordinateur","OU","SousOU"
$ADGroup = Get-ADGroup -Filter * -Properties *
$ADComputer = Get-ADComputer -Filter * -Properties *
$DomainDN = (Get-ADDomain).DistinguishedName
$Count = 1
foreach ($Computer in $Computers)
{
    Write-Progress -Activity "Création des ordinateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Computers.Length*100)
    # Gestion de présence de Sous OU
    if ( $Computer.SousOU -eq "NA" )
    {
        # Chemin complet
        $Path = "OU=$($Computer.OU),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
    }
    Else
    {
        # Chemin sans sous OU
        $Path ="OU=$($Computer.SousOU),OU=$($Computer.OU),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
    }
    # Ajout automatique des ordinateurs
    If (($ADComputer | Where {$_.Name -eq $Computer.Ordinateur}) -eq $Null)
    {
        Try {
            New-ADComputer -Name $Computer.Ordinateur -Path $Path -Description "ID $Ordinateur"
            Write-Host "Création de l'ordinateur $($Computer.Designation) dans l'OU $($Computer.OU)/$($Computer.SousOU), $DomainDN réussie" -ForegroundColor Green
        }
        Catch
        {
            Write-Host "Création de l'ordinateur $($Computer.Ordinateur) dans l'OU $($Computer.OU)/$($Computer.SousOU), $DomainDN échoué" -ForegroundColor Red
        }
    }
    Else
    {
        Write-Host "L'ordinateur $($Computer.Ordinateur) dans l'OU $($Computer.OU)/$($Computer.SousOU), $DomainDN existe déjà" -ForegroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}
