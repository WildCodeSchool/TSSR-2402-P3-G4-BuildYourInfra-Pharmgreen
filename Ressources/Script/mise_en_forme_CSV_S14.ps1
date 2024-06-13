####################################################
####################################################
############ SCRIPT CREATION FICHIER CSV ###########                                           
####################################################
####################################################

####################################################
################### FONCTION #######################
####################################################

############## DEBUT FONCTION ######################



# Appel Fonction ajout colonne pour groupe fonction des utilisateur et des ordinateur
Function ajout_colonne 
{   
    # Récupérattion du contenue du fichier CSV
    $NouvelleColonne = Import-Csv -Path $fichierCSV 
    # Ajouter de nouvelles colonnes à la variable $filteredData
    
    $NouvelleColonne | Add-Member -MemberType NoteProperty -Name 'Groupe_Fonction_User'-Value ''
    $NouvelleColonne | Add-Member -MemberType NoteProperty -Name 'Groupe_Fonction_Computer' -Value ''
    # Ecriture dans le fichier CSV
    $NouvelleColonne | Export-Csv -Path $fichierCSV -NoTypeInformation
}


# Fonction remplacement nom Département, Sevice
Function FctRemplacement
{
    # Récupérattion du contenue du fichier CSV
    $Remplacement = Import-Csv -Path $fichierCSV 
    foreach ($row in $Remplacement) 
    {
        # Extraire la valeur des colonnes "Departement" et "Service"
        $departement = $row.Département
        $service = $row.Service

        # Remplacement du nom de département par le nom de l'OU
        switch ($departement) 
        {
            "Communication" { $row.Département = "Communication" }
            "Direction Financière" { $row.Département = "Direction_Financiere" }
            "Direction Marketing" { $row.Département = "Direction_Marketing" }
            "Direction Générale" { $row.Département = "Direction_Generale" }
            "R&D" { $row.Département = "Recherche_Developpement" }
            "RH" { $row.Département = "Ressources_Humaines" }
            "Service Généraux" { $row.Département = "Services_Generaux" }
            "Service Juridique" { $row.Département = "Service_Juridique" }
            "Systèmes d'Information" { $row.Département = "Systemes_Information" }
            "Ventes et Développement Commercial" { $row.Département = "Ventes_Developpement_Commercial" }            
            "Direction des Ressources Humaines" { $row.Département = "Direction_Ressources_Humaines" }
            "Services Généraux" { $row.Département = "Services_Generaux" }
            "-" { $row.Département = "NA" }
        }
        # Remplacement du nom de service par le nom de l'OU
        switch ($service) 
        {
            "Publicité" { $row.service = "Publicite" }
            "Relation Publique et Presse" { $row.service = "Relation_Publique_Presse" }
            "Contrôle de Gestion" { $row.service = "Controle_Gestion" }
            "Service Comptabilité" { $row.service = "Service_Comptabilite" }
            "Finance" { $row.service = "Finance" }
            "Marketing Digital" { $row.service = "Marketing_Digital" }
            "Marketing Opérationnel" { $row.service = "Marketing_Operationnel" }
            "Marketing Produit" { $row.service = "Marketing_Produit" }
            "Marketing Stratégique" { $row.service = "Marketing_Strategique" }
            "Innovation et Stratégie" { $row.service = "Innovation_Strategie" }
            "Laboratoire" { $row.service = "Laboratoire" }
            "Formation" { $row.service = "Formation" }
            "Gestion des performances" { $row.service = "Gestion_Performances" }
            "Recrutement" { $row.service = "Recrutement" }
            "Santé et sécurité au travail" { $row.service = "Sante_Securite_Travail" }
            "Gestion Immobilière" { $row.service = "Gestion_Immobiliere" }
            "Logistique" { $row.service = "Logistique" }
            "Contrats" { $row.service = "Contrats" }
            "Contentieux" { $row.service = "Contentieux" }
            "Développement logiciel" { $row.service = "Developpement_Logiciel" }
            "Data" { $row.service = "Data" }
            "Systèmes Réseaux" { $row.service = "Systemes_Reseaux" }
            "ADV" { $row.service = "ADV" }
            "B2B" { $row.service = "B2B" }
            "B2C" { $row.service = "B2C" }
            "Développement internationnal" { $row.service = "Developpement_Internationnal" }
            "Grands Comptes" { $row.service = "Grands_Comptes" }
            "Service Achat" { $row.service = "Service_Achat" }
            "Service Client" { $row.service = "Service_Client" }
            "Service Recrutement" { $row.service = "Service_Recrutement" }
            "e-Marketing" { $row.service = "Emarketing" }
            "-" { $row.service = "NA" }
        }
    }
  # Exporter les données mis à jour dans un nouveau fichier CSV
    $Remplacement | Export-Csv -Path $fichierCSV -NoTypeInformation
}


# Fonction création groupe utilisateur
Function FctCreationGroupeUser
{
    # Récupérattion du contenue du fichier CSV
    $CreaGroupe = Import-Csv -Path $fichierCSV 
    foreach ($row in $CreaGroupe) 
    {
        # Extraire la valeur de la colonne "Fonction"
        $fonction = $row.fonction

        # Création du groupe utilisateur représentant la fonction
        switch ($fonction) 
        {
            "Directrice communication" { $row.Groupe_Fonction_User= "GRP_U_Direction_Communication" }
            "Designer graphique" { $row.Groupe_Fonction_User= "GRP_U_Designer_Graphique" }
            "photographe" { $row.Groupe_Fonction_User= "GRP_U_Photographe" }
            "Publicitaire" { $row.Groupe_Fonction_User= "GRP_U_Publicitaire" }
            "Responsable publicité" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Publicite" }
            "Webmaster" { $row.Groupe_Fonction_User= "GRP_U_Webmaster" }
            "Chargé de communication" { $row.Groupe_Fonction_User= "GRP_U_Charge_Communication" }
            "Chargé de presse" { $row.Groupe_Fonction_User= "GRP_U_Charge_Presse" }
            "Chargé en droit de la communication" { $row.Groupe_Fonction_User= "GRP_U_Charge_Droit_Communication" }
            "Responsable relation média" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Relation_Media" }
            "DAF" { $row.Groupe_Fonction_User= "GRP_U_DAF" }
            "Analyste financier" { $row.Groupe_Fonction_User= "GRP_U_Analyste_Financier" }
            "Comptable" { $row.Groupe_Fonction_User= "GRP_U_Comptable" }
            "Contrôleur de gestion" { $row.Groupe_Fonction_User= "GRP_U_Controleur_Gestion" }
            "Assistant de direction" { $row.Groupe_Fonction_User= "GRP_U_Assistant_Direction" }
            "Secrétaire" { $row.Groupe_Fonction_User= "GRP_U_Secretaire" }
            "Directeur adjoint" { $row.Groupe_Fonction_User= "GRP_U_Directeur_Adjoint" }
            "CEO" { $row.Groupe_Fonction_User= "GRP_U_CEO" }
            "COMEX" { $row.Groupe_Fonction_User= "GRP_U_COMEX" }
            "CODIR" { $row.Groupe_Fonction_User= "GRP_U_CODIR" }
            "Community manager" { $row.Groupe_Fonction_User= "GRP_U_Community_Manager" }
            "Responsable marketing digital" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Marketing_Digital" }
            "Analyste web" { $row.Groupe_Fonction_User= "GRP_U_Analyste_Web" }
            "Content manager" { $row.Groupe_Fonction_User= "GRP_U_Content_Manager" }
            "Chargé de promotion" { $row.Groupe_Fonction_User= "GRP_U_Charge_Promotion" }
            "Chef de projet" { $row.Groupe_Fonction_User= "GRP_U_Chef_Projet" }
            "Assistant marketing" { $row.Groupe_Fonction_User= "GRP_U_Assistant_Marketing" }
            "Coordinateur Marketing" { $row.Groupe_Fonction_User= "GRP_U_Coordinateur_Marketing" }
            "Responsable Marketing Operationnel" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Marketing_Operationnel" }
            "Chef de produit" { $row.Groupe_Fonction_User= "GRP_U_Chef_Produit" }
            "Gestionaire de marque" { $row.Groupe_Fonction_User= "GRP_U_Gestionaire_Marque" }
            "Responsable de gamme" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Gamme" }
            "Directeur Marketing Stratégique" { $row.Groupe_Fonction_User= "GRP_U_Direction_Marketing_Strategique" }
            "Analyste marketing" { $row.Groupe_Fonction_User= "GRP_U_Analyste_Marketing" }
            "Chef de produit stratégique" { $row.Groupe_Fonction_User= "GRP_U_Chef_Produit_Strategique" }
            "Chercheur" { $row.Groupe_Fonction_User= "GRP_U_Chercheur" }
            "Responsable Recherche" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Recherche" }
            "Laborantin" { $row.Groupe_Fonction_User= "GRP_U_Laborantin" }
            "Responsable Laboratoire" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Laboratoire" }
            "Directeur RH" { $row.Groupe_Fonction_User= "GRP_U_Direction_RH" }
            "Directeur-Adjoint RH" { $row.Groupe_Fonction_User= "GRP_U_Direction_Adjoint_RH" }
            "Formateur" { $row.Groupe_Fonction_User= "GRP_U_Formateur" }
            "Agent RH" { if  ($row.Service -eq "Gestion_Performances") {  $row.Groupe_Fonction_User= "GRP_U_Agent_RH_GP" } }
            "Recruteur RH" { $row.Groupe_Fonction_User= "GRP_U_Recruteur_RH" }
            "Animateur sécurité" { $row.Groupe_Fonction_User= "GRP_U_Animateur_securite" }
            "Auditeur" { $row.Groupe_Fonction_User= "GRP_U_Auditeur" }
            "Technicien HSE" { $row.Groupe_Fonction_User= "GRP_U_Technicien_HSE" }
            "Agent logistique" { $row.Groupe_Fonction_User= "GRP_U_Agent_logistique" }
            "Responsable Logistique" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Logistique" }
            "Gestionnaire immobilier" { $row.Groupe_Fonction_User= "GRP_U_Gestionnaire_immobilier" }
            "Data scientist" { $row.Groupe_Fonction_User= "GRP_U_Data_Scientist" }
            "Développeur" { $row.Groupe_Fonction_User= "GRP_U_Developpeur" }
            "Directrice informatique" { $row.Groupe_Fonction_User= "GRP_U_Direction_Informatique" }
            "Administrateur systemes et réseaux" { $row.Groupe_Fonction_User= "GRP_U_Administrateur_Systemes_Reseaux" }
            "Juriste" { if  ($row.Service -eq "Contrats") {  $row.Groupe_Fonction_User= "GRP_U_Juriste_CTR" } else { $row.Groupe_Fonction_User= "GRP_U_Juriste_CTX" } }
            "Responsable Juridique" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Juridique" }
            "Gestionnaire ADV" { $row.Groupe_Fonction_User= "GRP_U_Gestionnaire_ADV" }
            "Responsable ADV" { $row.Groupe_Fonction_User= "GRP_U_Responsable_ADV" }
            "Commercial" { if  ($row.Service -eq "B2B") { $row.Groupe_Fonction_User= "GRP_U_Commercial_B2B" } }
            "Responsable B2B" { $row.Groupe_Fonction_User= "GRP_U_Responsable_B2B" }
            "Commercial" { if  ($row.Service -eq "B2C") { $row.Groupe_Fonction_User= "GRP_U_Commercial_B2C" }}
            "Responsable B2C" { $row.Groupe_Fonction_User= "GRP_U_Responsable_B2C" }
            "Commercial" { if  ($row.Service -eq "Developpement_Internationnal") { $row.Groupe_Fonction_User= "GRP_U_Commercial_DI" }}
            "Directrice Commercial" { $row.Groupe_Fonction_User= "GRP_U_Direction_Commercial_DI" }
            "Commercial" { if  ($row.Service -eq "Grands_Comptes") { $row.Groupe_Fonction_User= "GRP_U_Commercial_GC" }}
            "Responsable Grands Comptes" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Grands_Comptes" }
            "Acheteur" { $row.Groupe_Fonction_User= "GRP_U_Acheteur" }
            "Responsable achat" { $row.Groupe_Fonction_User= "GRP_U_Responsable_achat" }
            "Agent Client" { $row.Groupe_Fonction_User= "GRP_U_Agent_Client" }
            "Responsable Service Client" { $row.Groupe_Fonction_User= "GRP_U_Responsable_Service_Client" }
            "Caméraman" { $row.Groupe_Fonction_User= "GRP_U_Cameraman" }
            "Réalisateur" { $row.Groupe_Fonction_User= "GRP_U_Realisateur" }
            "Ingénieur son" { $row.Groupe_Fonction_User= "GRP_U_Ingenieur_son" }

        }
    }
    # Exporter les données mis à jour dans un nouveau fichier CSV
    $CreaGroupe | Export-Csv -Path $fichierCSV -NoTypeInformation
}

# Fonction création groupe Computer
Function FctCreationGroupePC
{
    # Récupérattion du contenue du fichier CSV
    $CreaGroupe = Import-Csv -Path $fichierCSV 
    foreach ($row in $CreaGroupe) 
    {
        # Extraire la valeur de la colonne "Fonction"
        $fonction = $row.fonction

        # Création du groupe ordinateur représentant la fonction
        switch ($fonction) 
        {
            "Directrice communication" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_Communication" }
            "Designer graphique" { $row.Groupe_Fonction_Computer= "GRP_C_Designer_Graphique" }
            "photographe" { $row.Groupe_Fonction_Computer= "GRP_C_Photographe" }
            "Publicitaire" { $row.Groupe_Fonction_Computer= "GRP_C_Publicitaire" }
            "Responsable publicité" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Publicite" }
            "Webmaster" { $row.Groupe_Fonction_Computer= "GRP_C_Webmaster" }
            "Chargé de communication" { $row.Groupe_Fonction_Computer= "GRP_C_Charge_Communication" }
            "Chargé de presse" { $row.Groupe_Fonction_Computer= "GRP_C_Charge_Presse" }
            "Chargé en droit de la communication" { $row.Groupe_Fonction_Computer= "GRP_C_Charge_Droit_Communication" }
            "Responsable relation média" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Relation_Media" }
            "DAF" { $row.Groupe_Fonction_Computer= "GRP_C_DAF" }
            "Analyste financier" { $row.Groupe_Fonction_Computer= "GRP_C_Analyste_Financier" }
            "Comptable" { $row.Groupe_Fonction_Computer= "GRP_C_Comptable" }
            "Contrôleur de gestion" { $row.Groupe_Fonction_Computer= "GRP_C_Controleur_Gestion" }
            "Assistant de direction" { $row.Groupe_Fonction_Computer= "GRP_C_Assistant_Direction" }
            "Secrétaire" { $row.Groupe_Fonction_Computer= "GRP_C_Secretaire" }
            "Directeur adjoint" { $row.Groupe_Fonction_Computer= "GRP_C_Directeur_Adjoint" }
            "CEO" { $row.Groupe_Fonction_Computer= "GRP_C_CEO" }
            "COMEX" { $row.Groupe_Fonction_Computer= "GRP_C_COMEX" }
            "CODIR" { $row.Groupe_Fonction_Computer= "GRP_C_CODIR" }
            "Community manager" { $row.Groupe_Fonction_Computer= "GRP_C_Community_Manager" }
            "Responsable marketing digital" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Marketing_Digital" }
            "Analyste web" { $row.Groupe_Fonction_Computer= "GRP_C_Analyste_Web" }
            "Content manager" { $row.Groupe_Fonction_Computer= "GRP_C_Content_Manager" }
            "Chargé de promotion" { $row.Groupe_Fonction_Computer= "GRP_C_Charge_Promotion" }
            "Chef de projet" { $row.Groupe_Fonction_Computer= "GRP_C_Chef_Projet" }
            "Assistant marketing" { $row.Groupe_Fonction_Computer= "GRP_C_Assistant_Marketing" }
            "Coordinateur Marketing" { $row.Groupe_Fonction_Computer= "GRP_C_Coordinateur_Marketing" }
            "Responsable Marketing Operationnel" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Marketing_Operationnel" }
            "Chef de produit" { $row.Groupe_Fonction_Computer= "GRP_C_Chef_Produit" }
            "Gestionaire de marque" { $row.Groupe_Fonction_Computer= "GRP_C_Gestionaire_Marque" }
            "Responsable de gamme" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Gamme" }
            "Directeur Marketing Stratégique" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_Marketing_Strategique" }
            "Analyste marketing" { $row.Groupe_Fonction_Computer= "GRP_C_Analyste_Marketing" }
            "Chef de produit stratégique" { $row.Groupe_Fonction_Computer= "GRP_C_Chef_Produit_Strategique" }
            "Chercheur" { $row.Groupe_Fonction_Computer= "GRP_C_Chercheur" }
            "Responsable Recherche" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Recherche" }
            "Laborantin" { $row.Groupe_Fonction_Computer= "GRP_C_Laborantin" }
            "Responsable Laboratoire" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Laboratoire" }
            "Directeur RH" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_RH" }
            "Directeur-Adjoint RH" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_Adjoint_RH" }
            "Formateur" { $row.Groupe_Fonction_Computer= "GRP_C_Formateur" }
            "Agent RH" { if  ($row.Service -eq "Gestion_Performances") {  $row.Groupe_Fonction_Computer= "GRP_C_Agent_RH_GP" } else { $row.Groupe_Fonction_Computer= "GRP_C_Agent_RH_REC" } }
            "Recruteur RH" { $row.Groupe_Fonction_Computer= "GRP_C_Recruteur_RH" }
            "Animateur sécurité" { $row.Groupe_Fonction_Computer= "GRP_C_Animateur_securite" }
            "Auditeur" { $row.Groupe_Fonction_Computer= "GRP_C_Auditeur" }
            "Technicien HSE" { $row.Groupe_Fonction_Computer= "GRP_C_Technicien_HSE" }
            "Agent logistique" { $row.Groupe_Fonction_Computer= "GRP_C_Agent_logistique" }
            "Responsable Logistique" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Logistique" }
            "Gestionnaire immobilier" { $row.Groupe_Fonction_Computer= "GRP_C_Gestionnaire_immobilier" }
            "Data scientist" { $row.Groupe_Fonction_Computer= "GRP_C_Data_Scientist" }
            "Développeur" { $row.Groupe_Fonction_Computer= "GRP_C_Developpeur" }
            "Directrice informatique" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_Informatique" }
            "Administrateur systemes et réseaux" { $row.Groupe_Fonction_Computer= "GRP_C_Administrateur_Systemes_Reseaux" }
            "Juriste" { if  ($row.Service -eq "Contrats") {  $row.Groupe_Fonction_Computer= "GRP_C_Juriste_CTR" } else { $row.Groupe_Fonction_Computer= "GRP_C_Juriste_CTX" } }
            "Responsable Juridique" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Juridique" }
            "Gestionnaire ADV" { $row.Groupe_Fonction_Computer= "GRP_C_Gestionnaire_ADV" }
            "Responsable ADV" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_ADV" }
            "Commercial" { if  ($row.Service -eq "B2B") { $row.Groupe_Fonction_Computer= "GRP_C_Commercial_B2B" } }
            "Responsable B2B" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_B2B" }
            "Commercial" { if  ($row.Service -eq "B2C") { $row.Groupe_Fonction_Computer= "GRP_C_Commercial_B2C" }}
            "Responsable B2C" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_B2C" }
            "Commercial" { if  ($row.Service -eq "Developpement_Internationnal") { $row.Groupe_Fonction_Computer= "GRP_C_Commercial_DI" }}
            "Directrice Commercial" { $row.Groupe_Fonction_Computer= "GRP_C_Direction_Commercial_DI" }
            "Commercial" { if  ($row.Service -eq "Grands_Comptes") { $row.Groupe_Fonction_Computer= "GRP_C_Commercial_GC" }}
            "Responsable Grands Comptes" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Grands_Comptes" }
            "Acheteur" { $row.Groupe_Fonction_Computer= "GRP_C_Acheteur" }
            "Responsable achat" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_achat" }
            "Agent Client" { $row.Groupe_Fonction_Computer= "GRP_C_Agent_Client" }
            "Responsable Service Client" { $row.Groupe_Fonction_Computer= "GRP_C_Responsable_Service_Client" }
            "Caméraman" { $row.Groupe_Fonction_Computer= "GRP_C_Cameraman" }
            "Réalisateur" { $row.Groupe_Fonction_Computer= "GRP_C_Realisateur" }
            "Ingénieur son" { $row.Groupe_Fonction_Computer= "GRP_C_Ingenieur_son" }

        }
    }
    # Exporter les données mis à jour dans un nouveau fichier CSV
    $CreaGroupe | Export-Csv -Path $fichierCSV -NoTypeInformation
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

############## FIN FONCTION ######################


####################################################
############# DEBUT SCRIPT #########################
####################################################

############## INTIALISAITON ######################


# Chemin d'accès du fichier XLSX d'entrée et du fichier CSV de sortie
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$fichierXLSX = "$FilePath\s14_Pharmgreen.xlsx"
$fichierCSV = "$FilePath\s14_Pharmgreen.csv"

#Installez le module ImportExcel s'il n'est pas déjà installé
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
  Install-Module -Name ImportExcel -Force
}

# Charger le contenu du fichier XLSX
$Fichier = Import-Excel -Path $fichierXLSX
# Exporter le contenu filtré vers le fichier CSV
$Fichier | Export-Csv -Path $fichierCSV -NoTypeInformation

Write-Host "Debut de mise en forme du ficher CSV pour intégration dans l'AD" -ForegroundColor Blue
Write-Host "" 
write-host "Le fichier suivant va être traité $fichierXLSX"
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1

# Appel Fonction ajout colonne pour groupe fonction des utilisateur et des ordinateur
ajout_colonne
# Appel Fonction remplacement nom service, départment, fonction pour coller à la nomenclature
FctRemplacement 
# Appel Fonction création de groupe utilisateur
FctCreationGroupeUser
# Appel Fonction création de groupe utilisateur
FctCreationGroupePC


# Appel Fonction suppression caractère seulement sur les colonnes noms et prénom
# Récupérattion du contenue du fichier CSV
$NomPrenom = Import-Csv -Path $fichierCSV
# Selections des colonnes prenom et nom
foreach ($row in $NomPrenom) 
  {
    # Appeler la fonction sur les colonnes "prénom" et "nom"
    $row.Prénom = FctSuppressionCaractere $row.Prénom
    $row.Nom = FctSuppressionCaractere $row.Nom
    $row.'Manager - nom' = FctSuppressionCaractere $row.'Manager - nom'
    $row.'Manager - prénom' = FctSuppressionCaractere $row.'Manager - prénom'
}
# Ecriture dans le fichier CSV
$NomPrenom | Export-Csv -Path $fichierCSV -NoTypeInformation

# Appel Fonction Renomage PC
FctRenomagePC

Write-Host "Fin de mise en forme du ficher CSV pour intégration dans l'AD" -ForegroundColor Blue
Write-Host "" 
write-host "Le fichier suivant a été créé $fichierCSV"
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
