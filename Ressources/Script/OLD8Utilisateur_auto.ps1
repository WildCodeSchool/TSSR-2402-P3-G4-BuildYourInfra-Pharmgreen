######################################################################################################
#                                                                                                    #
#   Création USER automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "$FilePath\liste_utilisateur.csv"

### Main program

If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom","Nom","City","Departement","Service","Date de naissance","Telf","Telp"
$ADUsers = Get-ADUser -Filter * -Properties *
$Count = 1
Foreach ($User in $Users)
{
    Write-Progress -Activity "Création des utilisateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Users.Length*100)
    $Name              = "$($User.Nom) $($User.Prenom)"
    $DisplayName       = "$($User.Nom) $($User.Prenom)"
    $SamAccountName    = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
    $UserPrincipalName = $(($User.Prenom.ToLower() + "." + $User.Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $User.Prenom
    $Surname           = $User.Nom
    $OfficePhone       = $User.Telf
    $PortablePhone     = $User.Telp
    $EmailAddress      = $UserPrincipalName
    $Path              = "ou=$($User.Service),ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
    $Department        = "$($User.Departement)"
    $Service           = "$($User.Service)"
    $Company           = "Pharmgreen"

       # Gestion de présence de Sous OU
        if ( $User.Service -eq "NA" )
        # Chemin complet
        { 
                $Path = "ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"
        }
        Else
        # Chemin sans sous OU
        { 
                $Path = "ou=$($User.Service),ou=$($User.Departement),ou=User_Pharmgreen,dc=pharmgreen,dc=org"      
        }



    If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        Try 
        {
            New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
            -GivenName $GivenName -Surname $Surname -HomePhone $OfficePhone -MobilePhone $PortablePhone -EmailAddress $EmailAddress `
            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty12024* -Force) -Enabled $True `
            -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True
            
            Write-Host "Création du USER" $SamAccountName -ForegroundColor Green
        }
        Catch  
        {
            write-host "Création du USER" $SamAccountName  "échoué" -ForegroundColor red

        }
    }
    Else
        {
            Write-Host "Le USER $SamAccountName existe déjà" -ForegroundColor Yellow 
        }
    
    $Count++
    sleep -Milliseconds 100

}
    