    
#######################################
#                                     #
#  Vérification PC Automatique        #
#                                     #
#######################################



$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$File = "$FilePath\s09_Pharmgreen.csv"
$Computers = Import-Csv -Path $File -Delimiter "," -Header "Prenom", "Nom", "Societe", "Site", "Departement", "Service", "fonction", "ManagerPrenom", "ManagerNom", "Ordinateur", "DateDeNaissance", "Telf", "Telp", "Nomadisme - Télétravail" | Select-Object -Skip 1
$ADComputer = Get-ADComputer -Filter * -Properties *
$DomainDN = (Get-ADDomain).DistinguishedName
$Count = 1

    foreach ($Computer in $Computers) {
        Write-Progress -Activity "Vérification des ordinateurs dans les OU" -Status "% effectué" -PercentComplete ($Count/$Computers.Length*100)

        # Gestion de présence de Sous OU
        if ($Computer.Service -eq "NA") {
            # Chemin complet
            $Path = "OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        } else {
            # Chemin sans sous OU
            $Path = "OU=$($Computer.Service),OU=$($Computer.Departement),OU=Computer_Pharmgreen,DC=pharmgreen,DC=org"
        }

        # Vérifier si l'ordinateur est dans la bonne OU
        
        if ($ADComputer  | Where-Object { $_.Name -eq $Computer.Ordinateur -and $_.DistinguishedName -eq "CN=$($Computer.Ordinateur),$Path" }) 
        {
            Write-Host "L'ordinateur $($Computer.Ordinateur) dans l'OU $Path est bien présent" -ForegroundColor Green
        } 
        
        else 
        
        {
            Write-Host "L'ordinateur $($Computer.Ordinateur) dans l'OU $Path est absente" -ForegroundColor Red

            $ADComputerToMove = Get-ADComputer -Filter "Name -eq '$($Computer.Ordinateur)'"

            if ($ADComputerToMove) 
            {
                    # Déplacer l'ordinateur vers la bonne OU
                    Try 
                    {
                        Move-ADObject -Identity $ADComputerToMove.DistinguishedName -TargetPath $Path 
                        Write-Host "L'ordinateur $($Computer.Ordinateur) a été déplacé vers l'OU $Path " -ForegroundColor Green
                    }
                    Catch 
                    {
                        Write-Host "Le déplacement de l'ordinateur $($Computer.Ordinateur) vers l'OU $Path a échoué" -ForegroundColor Red
                    }
                } else {
                    Write-Host "L'ordinateur $($Computer.Ordinateur) n'a pas été trouvé dans Active Directory" -ForegroundColor Yellow
            }
        }

        $Count++
        sleep -Milliseconds 100
    }

