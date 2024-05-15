﻿######################################################################################################
#                                                                                                    #
#   Création USER automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "$FilePath\user.csv"

### Main program

If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom","Nom","City","Departement","Service","fonction","Date de naissance","Telf","Telp"
$ADUsers = Get-ADUser -Filter * -Properties *
$Count = 1
Foreach ($User in $Users)
{
      Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "% effectué" -PercentComplete ($Count/$Users.Length*100)
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

    If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
        -GivenName $GivenName -Surname $Surname -HomePhone $OfficePhone -MobilePhone $PortablePhone -EmailAddress $EmailAddress `
        -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
        -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True
        
        Write-Host "Création du USER" $SamAccountName -ForegroundColor Green
    }
    Else
    {
        Write-Host "Le USER $SamAccountName existe déjà" -ForegroundColor Black -BackgroundColor Yellow
    }

    }
    $Count++
    sleep -Milliseconds 100
}