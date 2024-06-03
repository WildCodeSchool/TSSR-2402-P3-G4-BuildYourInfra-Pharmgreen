Function SuppressionLignesVides
{
# Récupérattion du contenue du fichier CSV
   $contenuCSV = Get-Content $fichierCSV
   # Filtrer les lignes vides
   $contenuFiltré = $contenuCSV | Where-Object { $_ -ne "" }
   # Écrire le contenu filtré dans le fichier CSV
   Set-Content $fichierCSV $contenuFiltré
}

# Fonction remplacement nom Département, Sevice, fonction
Function Remplacement
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
Function ServiceVide 
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
Function SuppressionCaractere {
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

Function MenageCSV
{ 
   (Get-Content -Path $fichierCSV) `
   -replace '"","","","","","","","","","","","","",""', '' | Set-Content -Path $fichierCSV
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
Remplacement 
# Appel Fonction gestion absence de service
ServiceVide

# Appel Fonction suppression caractère seulement sur les colonnes noms et prénom
# Récupérattion du contenue du fichier CSV
$NomPrenom = Import-Csv -Path $fichierCSV
    # Selections des colonnes prenom et nom
  foreach ($row in $NomPrenom) {
    # Appeler la fonction sur les colonnes "prénom" et "nom"
    $row.Prenom = SuppressionCaractere $row.Prenom
    $row.Nom = SuppressionCaractere $row.Nom
    $row.'Manager - nom' = SuppressionCaractere $row.'Manager - nom'
    $row.'Manager - prénom' = SuppressionCaractere $row.'Manager - prénom'
}
# Ecriture dans le fichier CSV
$NomPrenom | Export-Csv -Path $fichierCSV -NoTypeInformation

# Appel Fonction Ménage fichier CSV
MenageCSV
# Appel Suprression lignes supplémentairs
SuppressionLignesVides

