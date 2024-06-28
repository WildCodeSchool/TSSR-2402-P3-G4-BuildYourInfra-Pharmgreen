
####################################################
####################################################
########   SCRIPT SUPPPRESSION UTILISATEUR #########
####################################################
####################################################

####################################################
################### FONCTION #######################
####################################################

############## DEBUT FONCTION ######################

# Fonction Log
function Log
{
    param([string]$Content,[string]$Head)

    # Vérifie si le fichier existe, sinon le crée
    # Construit la ligne de journal
    $Date = Get-Date -Format "MM-dd-yyyy"  
    $Heure = Get-Date -Format "HH:mm:ss.fffffff"  
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $Thread = [Threading.Thread]::CurrentThread.ManagedThreadId
    switch ($Head) 
        {
            "INFO" {   
                    $Entete = "INFO - Message information"
                    $Type=0 
                    }
            "DEBUG" { 
                    $Entete = "DEBUG - Message debugage"
                    $Type=4 
                    }
            "TRACE" { 
                    $Entete = "TRACE - Message tracabilite" 
                    $Type=0 
                    }
            "ERROR" { 
                    $Entete = "ERROR - Message erreur" 
                    $Type=2 
                    }
            "FATAL" { 
                    $Entete = "FATAL - Message critique" 
                    $Type=3 
                    }
        }

   $logLine = "<![LOG[$Content]LOG]!><time=`"$Heure`" date=`"$Date`" component=`"$Entete`" context=`"$User`" type=`"$Type`" thread=`"$Thread`" file=`"$User`">"

}
    

function FctSuppressionUtilsateurs
{ 
    $Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom" | Select-Object -Skip 1
    $ADUsers = Get-ADUser -Filter * -Properties *
    $Count = 1
    Foreach ($User in $Users)
    {
       
        $targetname = "ou=User_Pharmgreen_Disable,dc=pharmgreen,dc=org"
        $SamAccountName    = $($User.Prenom.ToLower())+ "." + $($User.Nom.ToLower())
        $info = Get-ADUser -Identity $samaccountname -Properties MemberOf

        If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -ne $Null)
        { 
            # Désactivation de l'utilisateurs
            Try 
            {
                Disable-ADAccount -Identity $samAccountName
                Write-Host "Désactivation de l'utilisateur $SamAccountName " -ForegroundColor Green
                Move-ADObject -Identity $info.distinguishedname -TargetPath $targetname -Confirm:$false
            }
            Catch 
            {
                Write-Host "Désactivation de l'utilisateur $SamAccountName  échouée" -ForegroundColor red
                Log -FilePath $LogFile -Content "Désactivation de l'utilisateur $SamAccountName  échouée"  -Head "ERROR"
            }

            # Retirer l'utilisateur de tous les groupes
            $groups = $info.MemberOf
            Foreach ($group in $groups) 
            {
                Try 
                {
                    Remove-ADGroupMember -Identity $group -Members $SamAccountName -Confirm:$false
                    Write-Host "Retrait des groupes de l'utilisateur $SamAccountName réussit" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Désactivation et retrait des groupes de l'utilisateur $SamAccountName réussit"  -Head "INFO"
                }

                Catch 
                {
                    Write-Host "Retrait des groupes de l'utilisateur $SamAccountName échouée" -ForegroundColor red
                    Log -FilePath $LogFile -Content "Désactivation et retrait des groupes de l'utilisateur $SamAccountName échouée"  -Head "ERROR"
                }
            }

        }
          Else
        {
            Write-Host "L'utilsateur $SamAccountName n'existe pas" -ForegroundColor Yellow
            Log -FilePath $LogFile -Content "L'utilsateur $SamAccountName n'existe pas"  -Head "ERROR"
        }
    }
}                                                             

############## FIN FONCTION ######################


####################################################
############# DEBUT SCRIPT #########################
####################################################

############## INITIALISATION ######################

### Chemin des dossiers et fichiers à lire et exploiter
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\Difference.csv"
$LogPath = "C:\\Log\\"
$LogFile = "$LogPath\\Log_Script_Suppresssion_User.log"

# Crée le dossier s'il n'existe pas
if (-Not (Test-Path -Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}

# Crée le fichier s'il n'existe pas
if (-Not (Test-Path -Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile | Out-Null
}

# Appel module Active Directory si pas présent
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

Write-Host "Debut suppression des Utilisateurs" -ForegroundColor Blue
Write-Host "" 
FctSuppressionUtilsateurs
Write-Host "" 
Write-Host "Fin suppression des Utilisateursy"  -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
clear-host

Write-Host "Reportez vous au fichier Log $LogFile pour vérifier si il y a eu des souci lors de l'exécution du script" -ForegroundColor Red
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1

############## FIN DU SCRIPT ######################