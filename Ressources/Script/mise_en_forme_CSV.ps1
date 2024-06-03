Function FctSuppressionLignesVides
{
# Récupérattion du contenue du fichier CSV
   $contenuCSV = Get-Content $fichierCSV
   # Filtrer les lignes vides
   $contenuFiltré = $contenuCSV | Where-Object { $_ -ne "" }
   # Écrire le contenu filtré dans le fichier CSV
   Set-Content $fichierCSV $contenuFiltré
}

# Fonction remplacement nom Département, Sevice, fonction
Function FctRemplacement
{
   (Get-Content -Path $fichierCSV) `
      -replace 'Communication', 'Communication' -replace 'Direction Financière', 'Direction_Financiere' -replace 'Direction Générale', 'Direction_Generale' -replace 'Direction Marketing', 'Direction_Marketing' `
      -replace 'R&D', 'Recherche_Developpement' -replace 'RH', 'Ressources_Humaines' -replace 'Service Généraux', 'Services_Generaux' -replace 'Service Juridique', 'Service_Juridique' -replace "Systèmes d'InFormation", 'Systemes_Information' `
      -replace 'Ventes et Développement Commercial', 'Ventes_Developpement_Commercial' -replace 'Publicité', 'Publicite' -replace 'Relation Publique et Presse', 'Relation_Publique_Presse' -replace 'Contrôle de Gestion', 'Controle_Gestion' `
      -replace 'Service Comptabilité', 'Service_Comptabilite' -replace 'Finance', 'Finance' -replace 'Marketing Digital', 'Marketing_Digital'  -replace 'Marketing Opérationnel', 'Marketing_Operationnel' `
      -replace 'Marketing Produit', 'Marketing_Produit' -replace 'Marketing Stratégique', 'Marketing_Strategique' -replace 'Innovation et Stratégie', 'Innovation_Strategie' -replace 'Laboratoire', 'Laboratoire' `
      -replace 'Formation', 'Formation' -replace 'Gestion des performances', 'Gestion_Performances' -replace 'Recrutement', 'Recrutement' -replace 'Santé et sécurité au travail', 'Sante_Securite_Travail' -replace 'Gestion Immobilière', 'Gestion_Immobiliere' `
      -replace 'Logistique', 'Logistique' -replace 'Contrats', 'Contrats' -replace 'Contentieux', 'Contentieux' -replace 'Développement logiciel', 'Developpement_Logiciel' -replace 'Data', 'Data' -replace 'Systèmes Réseaux', 'Systemes_Reseaux' `
      -replace 'ADV', 'ADV' -replace 'B2B', 'B2B' -replace 'B2C', 'B2C' -replace 'Développement internationnal', 'Developpement_Internationnal' -replace 'Grands Comptes', 'Grands_Comptes' -replace 'Service Achat', 'Service_Achat' `
      -replace 'Service Client', 'Service_Client' | Set-Content -Path $fichierCSV
}

# Fonction gestion absence de service  
Function FctServiceVide 
{
    # Récupérattion du contenue du fichier CSV
    $csvContent = Import-Csv -Path $fichierCSV
        foreach ($row in $csvContent) 
        {
            if ($row.Service -eq "-") 
            {
               $row.Service = "NA"
            }   
    }
    # Ecriture dans le fichier CSV
    $csvContent | Export-Csv -Path $fichierCSV 
}

# Fonction remplacement caractère spéciaux, supression espaces, ...
Function FctSuppressionCaractere {
    param ([string]$DataCaractere)
    Begin {
        # Début du processus
    }
    Process {
        # Processus de traitement de chaque ligne
        $DataCaractere = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($DataCaractere))
        $DataCaractere = $DataCaractere -replace '-', '' `
                          -replace ' ', '' `
                          -replace '/', '' `
                          -replace '\*', '' `
                          -replace "'", ""
    }
    End {
        # Fin du processus
        return $DataCaractere
    }
}

Function FctMenageCSV
{ 
   (Get-Content -Path $fichierCSV) `
   -replace '"","","","","","","","","","","","","",""', '' | Set-Content -Path $fichierCSV
}

Function FctRenomagePC
{ 
    $NomPC = Import-Csv -Path $fichierCSV
    $NumberInterne = 0001
    $NumberExterne = 0001
    foreach ($row in $NomPC) 
    {
        if ($row.Société -eq "Pharmgreen" )
        {
            $NumberFormateInterne = $NumberInterne.ToString("D4")
            $Nom_PC_Interne="PC-PI-"+$NumberFormateInterne
            # Incrémenter le numéro et formater le nouveau numéro
            $NumberInterne++
            $row.PC = $Nom_PC_Interne
        }
        if ($row.Société -eq "Kamera" )
        { 
            $NumberFormateExterne = $NumberExterne.ToString("D4")
            $Nom_PC_Externe="PC-PE-"+$NumberFormateExterne
            # Incrémenter le numéro et formater le nouveau numéro
            $NumberExterne++
            $row.PC = $Nom_PC_Externe
        }
    }
    $NomPC | Export-Csv -Path $fichierCSV -NoTypeInformation
}



# Chemin d'accès du fichier XLSX d'entrée et du fichier CSV de sortie
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$fichierXLSX = "$FilePath\s09_Pharmgreen.xlsx"
$fichierCSV = "$FilePath\s09_Pharmgreen.csv"

# Charger le contenu du fichier XLSX
$Fichier = Import-Excel -Path $fichierXLSX
# Exporter le contenu filtré vers le fichier CSV
$Fichier | Export-Csv -Path $fichierCSV 

# Appel Fonction remplacement nom service, départment, fonction pour coller à la nomenclature
FctRemplacement 
# Appel Fonction gestion absence de service
FctServiceVide

# Appel Fonction suppression caractère seulement sur les colonnes noms et prénom
# Récupérattion du contenue du fichier CSV
$NomPrenom = Import-Csv -Path $fichierCSV
# Selections des colonnes prenom et nom
foreach ($row in $NomPrenom) 
  {
    # Appeler la fonction sur les colonnes "prénom" et "nom"
    $row.Prenom = FctSuppressionCaractere $row.Prenom
    $row.Nom = FctSuppressionCaractere $row.Nom
    $row.'Manager - nom' = FctSuppressionCaractere $row.'Manager - nom'
    $row.'Manager - prénom' = FctSuppressionCaractere $row.'Manager - prénom'
}
# Ecriture dans le fichier CSV
$NomPrenom | Export-Csv -Path $fichierCSV -NoTypeInformation

# Appel Fonction Renomage PC
FctRenomagePC
# Appel Fonction Ménage fichier CSV
FctMenageCSV
# Appel Suprression lignes supplémentairs
FctSuppressionLignesVides

