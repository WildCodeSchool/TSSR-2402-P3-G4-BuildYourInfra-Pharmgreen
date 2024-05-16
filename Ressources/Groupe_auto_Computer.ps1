#######################################
#                                     #
#   Création de groupes automatique   #
#                                     #
#######################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$File = "$FilePath\Groupe_Computer.csv"

$Groups = Import-Csv -Path $File -Delimiter "," -Header "OU","SousOU","Designation"
$ADGroup = Get-ADGroup -Filter * -Properties *
$DomainDN = (Get-ADDomain).DistinguishedName
$Count = 1
foreach ($Group in $Groups) 
{  
        Write-Progress -Activity "Création des groupes dans les OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
        # Gestion de présence de Sous OU
        if ( $Group.SousOU -eq "NA" )
                # Chemin complet
                { 
                        $Path = "OU=$($Group.OU),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
                }
        Else
                # Chemin sans sous OU
                { 
                        $Path ="OU=$($Group.SousOU),OU=$($Group.OU),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"      
                }
        # Ajout automatique des groupes
        If (($ADGroup | Where {$_.Name -eq $Group.Designation}) -eq $Null)
               {
                        Try {
                        New-AdGroup -Name $Group.Designation -Path $Path -GroupScope Global -GroupCategory Security
                       Write-Host "Création du groupe $($Group.Designation) dans l'OU $($Group.OU)/$($Group.SousOU), $DomainDN réussie" -ForegroundColor Green
                       }
                       Catch 
                       { write-host "Création du groupe $($Group.Designation) dans l'OU $($Group.OU)/$($Group.SousOU), $DomainDN échoué" -ForegroundColor red}
                       }
        Else
                {
                Write-Host "Le groupe $($Group.Designation) dans l'OU $($Group.OU)/$($Group.SousOU), $DomainDN  existe déjà" -ForegroundColor Yellow
                }
        $Count++
        sleep -Milliseconds 100
}