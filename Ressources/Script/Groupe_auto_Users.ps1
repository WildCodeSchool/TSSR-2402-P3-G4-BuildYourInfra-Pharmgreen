#######################################
#                                     #
#         Création et ajout           #
#         groupes automatique         #
#                                     #
#######################################

### Fichier a récupérer
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\Groupe_User.csv"

### Initialisation
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}


function FctCreationGroupe
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header "OU_Principal","OU_Service","Affectation_Groupe","NomGroupe"| Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1
        foreach ($Group in $Groups) 
        {  
                Write-Progress -Activity "Création des groupes dans les OU" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
                # Gestion de présence de Sous OU
                if ( $Group.OU_Service -eq "NA" )
                # Chemin complet
                { 
                        $Path = "OU=$($Group.OU_Principal),OU=User_Pharmgreen,DC=pharmgreen,DC=org"
                }
                Else
                # Chemin sans sous OU
                { 
                        $Path ="OU=$($Group.OU_Service),OU=$($Group.OU_Principal),OU=User_Pharmgreen,DC=pharmgreen,DC=org"      
                }
                
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $Group.NomGroupe}) -eq $Null)
                {
                                Try {
                                New-AdGroup -Name $Group.NomGroupe -Path $Path -GroupScope Global -GroupCategory Security
                        Write-Host "Création du groupe $($Group.NomGroupe) dans l'OU $Path réussie" -ForegroundColor Green
                        }
                        Catch 
                        { write-host "Création du groupe $($Group.NomGroupe) dans l'OU $Path échoué" -ForegroundColor red
                        }
                        }
                Else
                        {
                        Write-Host "Le groupe $($Group.NomGroupe) dans l'OU $Path existe déjà" -ForegroundColor Yellow
                        }
                $Count++
                sleep -Milliseconds 100
        }
}


function FctAjoutSousGRoupAGroup
{
        $Groups = Import-Csv -Path $File -Delimiter "," -Header "OU_Principal","OU_Service","Affectation_Groupe","NomGroupe"| Select-Object -Skip 1
        $ADGroup = Get-ADGroup -Filter * -Properties *
        $Count = 1
        foreach ($Group in $Groups) 
        {  
            $NomGroupe=$Group.NomGroupe
            $NomGroupMember =$Group.Affectation_Groupe
            Write-Progress -Activity "Ajout des sous-groupes dans les groupes" -Status "% effectué" -PercentComplete ($Count/$Groups.Length*100)
            # Gestion de présence de Sous OU
            if ( $NomGroupMember -ne "NA" )
            # Chemin sans sous OU
            { 
                # Ajout automatique des groupes
                If (($ADGroup | Where {$_.Name -eq $NomGroupe}) -ne $Null)
                {
                        Try {
                        Add-ADGroupMember -Identity $NomGroupMember -Members $NomGroupe
                        Write-Host "Ajout groupe $NomGroupe dans le $NomGroupMember réussit" -ForegroundColor Green
                        }
                        Catch 
                        { write-host "Ajout groupe $NomGroupe dans le $NomGroupMember échoué " -ForegroundColor red
                        }
                }
                Else
                {
                        Write-Host "Le groupe $NomGroupe n'exite pas" -ForegroundColor Yellow
                }
        }            
            $Count++
            sleep -Milliseconds 100
    }
}

# Création groupe Global 
$GroupNamePrincipal = "GRP_U_Users"
$groupPath = "OU=User_Pharmgreen,DC=pharmgreen,DC=org"
Write-Host "Vérification Groupe Global Utilisateurs existe, si non existant il sera créé " -ForegroundColor Blue
Write-Host "" 
$ADGroup = Get-ADGroup -Filter * -Properties *
if (($ADGroup  | Where {$_.Name -eq $GroupNamePrincipal }) -ne $Null)
{
    # Le groupe existe déjà, afficher un message
    Write-Host "Le groupe $GroupNamePrincipal existe déjà." -ForegroundColor Green
} else 
{
    # Le groupe n'existe pas, le créer
    New-ADGroup -Name $GroupNamePrincipal -Path $groupPath -GroupScope Global -GroupCategory Security
    Write-Host "Le groupe $GroupNamePrincipal a été créé avec succès ." -ForegroundColor Green
}
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Debut création de Groupe" -ForegroundColor Blue
Write-Host "" 
FctCreationGroupe
Write-Host "Fin création de Groupe" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 2
clear-host

Write-Host "Debut ajout de Groupe dans groupe" -ForegroundColor Blue
Write-Host "" 
FctAjoutSousGRoupAGroup
Write-Host "Fin ajout de Groupe dans groupe" -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
