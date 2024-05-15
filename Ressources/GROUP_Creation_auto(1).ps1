#######################################
#                                     #
#   Création de groupes automatique   #
#                                     #
#######################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$File = "$FilePath\Nomenclature.csv"

$Groups = Import-Csv -Path $File -Delimiter "," -Header "OU","SousOU","Designation"

$DomainDN = (Get-ADDomain).DistinguishedName

foreach ($Group in $Groups) {
    Try {
        New-AdGroup -Name $($Group.Designation) -Path "OU=$($Group.SousOU), OU=$($Group.OU),OU=User_Pharmgreen,DC=pharmgreen,DC=org" -GroupScope Global -GroupCategory Security
        Write-Host "Création du groupe $($Group.Designation) dans l'OU $($Group.OU)/$($Group.SousOU), $DomainDN réussie" -ForegroundColor Green
    } Catch {
        Write-Host "Le groupe $($Group.Designation) existe déjà" -ForegroundColor Yellow -BackgroundColor Black
    }
}