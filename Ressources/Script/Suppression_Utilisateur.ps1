

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Fichier a récupérer
$File = "$FilePath\Difference.csv"

$Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom" | Select-Object -Skip 1
$ADUsers = Get-ADUser -Filter * -Properties *
$Count = 1
Foreach ($User in $Users)
{
    $targetname = "ou=User_Pharmgreen_Disable,dc=pharmgreen,dc=org"
    $SamAccountName    = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
    $info = Get-ADUser -Identity $samaccountname -Properties MemberOf
    Disable-ADAccount -Identity $samAccountName
    Move-ADObject -Identity $info.distinguishedname -TargetPath $targetname -Confirm:$false

    # Retirer l'utilisateur de tous les groupes
    $groups = $info.MemberOf
    Foreach ($group in $groups) 
    {
        Remove-ADGroupMember -Identity $group -Members $SamAccountName -Confirm:$false
    }

    # Afficher un message de confirmation
    Write-Host "Désactivation et retrait des groupes de l'utilisateur $SamAccountName" -ForegroundColor Green
}
                                                                   