Clear-Host
##############################################
#                                            #
#   Remplissage des groupe automatiquement   #
#                                            #
##############################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
### Initialisation
$File = "$FilePath\USER_Creation_auto_Liste.txt"
Users = Import-Csv -Path $File -Delimiter ";" -Header "Prenom","Nom","fonction"
### Main
foreach ($User in $Users) {
    $SamAccountName = ($User.Prenom + "." + $User.Nom).ToLower()
    
    if ($User.fonction -ne ""){
        Switch ($User.fonction) {
            "Cameraman" {Add-ADGroupMember -Identity "Group_Cameraman" -Members $SamAccountName}
            "Chargé de communication" {Add-ADGroupMember -Identity "GRP_U_Charge_Communication" -Members $SamAccountName}
            "Chargé de presse" {Add-ADGroupMember -Identity "GRP_U_Charge_Presse" -Members $SamAccountName}
            "Chargé en droit de la communication" {Add-ADGroupMember -Identity "GRP_U_Charge_Droit_Communication" -Members $SamAccountName}
            "Designer graphique" {Add-ADGroupMember -Identity "GRP_U_Designer_Graphique" -Members $SamAccountName}
            "Directrice communication" {Add-ADGroupMember -Identity "GRP_U_Direction_Communication" -Members $SamAccountName}
            "Ingénieur son" {Add-ADGroupMember -Identity "Group_Ingenieur_Son" -Members $SamAccountName}
            "Photographe" {Add-ADGroupMember -Identity "GRP_U_Photographe" -Members $SamAccountName}
            "Publicitaire" {Add-ADGroupMember -Identity "GRP_U_Publicitaire" -Members $SamAccountName}
            "Réalisateur" {Add-ADGroupMember -Identity "Group_Realisateur" -Members $SamAccountName}
            "Responsable publicité" {Add-ADGroupMember -Identity "GRP_U_Responsable_Publicite" -Members $SamAccountName}
            "Responsable relation média" {Add-ADGroupMember -Identity "GRP_U_Responsable_Relation_Media" -Members $SamAccountName}
            "Webmaster" {Add-ADGroupMember -Identity "GRP_U_Webmaster" -Members $SamAccountName}
            "Contrôleur de gestion" {Add-ADGroupMember -Identity "GRP_U_Controleur_Gestion" -Members $SamAccountName}
            "Comptable" {Add-ADGroupMember -Identity "GRP_U_Comptable" -Members $SamAccountName}
            "Analyste financier" {Add-ADGroupMember -Identity "GRP_U_Analyste_Financier" -Members $SamAccountName}
            "DAF" {Add-ADGroupMember -Identity "GRP_U_DAF" -Members $SamAccountName}
            "CEO" {Add-ADGroupMember -Identity "GRP_U_CEO" -Members $SamAccountName}
            "COMEX" {Add-ADGroupMember -Identity "GRP_U_COMEX" -Members $SamAccountName}
            "CODIR" {Add-ADGroupMember -Identity "GRP_U_CODIR" -Members $SamAccountName}
            "Assistant de direction" {Add-ADGroupMember -Identity "GRP_U_Assistant_Direction" -Members $SamAccountName}
            "Secrétaire" {Add-ADGroupMember -Identity "GRP_U_Secretaire" -Members $SamAccountName}
            "Directeur adjoint" {Add-ADGroupMember -Identity "GRP_U_Directeur_Adjoint" -Members $SamAccountName}
            "Community manager" {Add-ADGroupMember -Identity "GRP_U_Community_Manager" -Members $SamAccountName}
            "Responsable marketing digital" {Add-ADGroupMember -Identity "GRP_U_Responsable_Marketing_Digital" -Members $SamAccountName}
            "Analyste web" {Add-ADGroupMember -Identity "GRP_U_Analyste_Web" -Members $SamAccountName}
            "Content manager" {Add-ADGroupMember -Identity "GRP_U_Content_Manager" -Members $SamAccountName}
            "Chargé de promotion" {Add-ADGroupMember -Identity "GRP_U_Charge_Promotion" -Members $SamAccountName}
            "Chef de projet" {Add-ADGroupMember -Identity "GRP_U_Chef_Projet" -Members $SamAccountName}
            "Assistant marketing" {Add-ADGroupMember -Identity "GRP_U_Assistant_Marketing" -Members $SamAccountName}
            "Coordinateur Marketing" {Add-ADGroupMember -Identity "GRP_U_Coordinateur_Marketing" -Members $SamAccountName}
            "Responsable Marketing Opérationnel" {Add-ADGroupMember -Identity "GRP_U_Responsable_Marketing_Operationnel" -Members $SamAccountName}
            "Chef de produit" {Add-ADGroupMember -Identity "GRP_U_Chef_Produit" -Members $SamAccountName}
            "Gestionaire de marque" {Add-ADGroupMember -Identity "GRP_U_Gestionaire_Marque" -Members $SamAccountName}
            "Responsable de gamme" {Add-ADGroupMember -Identity "GRP_U_Responsable_Gamme" -Members $SamAccountName}
            "Directeur Marketing Stratégique" {Add-ADGroupMember -Identity "GRP_U_Direction_Marketing_Strategique" -Members $SamAccountName}
            "Analyste marketing" {Add-ADGroupMember -Identity "GRP_U_Analyste_Marketing" -Members $SamAccountName}
            "Chef de produit stratégique" {Add-ADGroupMember -Identity "GRP_U_Chef_Produit_Strategique" -Members $SamAccountName}
            "Chercheur" {Add-ADGroupMember -Identity "GRP_U_Chercheur" -Members $SamAccountName}
            "Responsable Recherche" {Add-ADGroupMember -Identity "GRP_U_Responsable_Recherche" -Members $SamAccountName}
            "Laborantin" {Add-ADGroupMember -Identity "GRP_U_Laborantin" -Members $SamAccountName}
            "Responsable Laboratoire" {Add-ADGroupMember -Identity "GRP_U_Responsable_Laboratoire" -Members $SamAccountName}
            "Directeur RH" {Add-ADGroupMember -Identity "GRP_U_Direction_RH" -Members $SamAccountName}
            "Directeur-Adjoint RH" {Add-ADGroupMember -Identity "GRP_U_Direction_Adjoint_RH" -Members $SamAccountName}
            "Formateur" {Add-ADGroupMember -Identity "GRP_U_Formateur" -Members $SamAccountName}
            "Agent RH" {Add-ADGroupMember -Identity "GRP_U_Agent_RH_GP"; Add-ADGroupMember -Identity "GRP_U_Agent_RH_REC" -Members $SamAccountName}
            "Animateur sécurité" {Add-ADGroupMember -Identity "GRP_U_Animateur_securite" -Members $SamAccountName}
            "Auditeur" {Add-ADGroupMember -Identity "GRP_U_Auditeur" -Members $SamAccountName}
            "Technicien HSE" {Add-ADGroupMember -Identity "GRP_U_Technicien_HSE" -Members $SamAccountName}
            "Agent logistique" {Add-ADGroupMember -Identity "GRP_U_Agent_logistique" -Members $SamAccountName}
            "Responsable Logistique" {Add-ADGroupMember -Identity "GRP_U_Responsable_Logistique" -Members $SamAccountName}
            "Gestionnaire immobilier" {Add-ADGroupMember -Identity "GRP_U_Gestionnaire_immobilier" -Members $SamAccountName}
            "Data scientist" {Add-ADGroupMember -Identity "GRP_U_Data_Scientist" -Members $SamAccountName}
            "Développeur" {Add-ADGroupMember -Identity "GRP_U_Developpeur" -Members $SamAccountName}
            "Directrice informatique" {Add-ADGroupMember -Identity "GRP_U_Direction_Informatique" -Members $SamAccountName}
            "Administrateur systèmes et réseaux" {Add-ADGroupMember -Identity "GRP_U_Administrateur_Systemes_Reseaux" -Members $SamAccountName}
            "Juriste" {Add-ADGroupMember -Identity "GRP_U_Juriste_CTR"; Add-ADGroupMember -Identity "GRP_U_Juriste_CTX" -Members $SamAccountName}
            "Responsable Juridique" {Add-ADGroupMember -Identity "GRP_U_Responsable_Juridique" -Members $SamAccountName}
            "Gestionnaire ADV" {Add-ADGroupMember -Identity "GRP_U_Gestionnaire_ADV" -Members $SamAccountName}
            "Responsable ADV" {Add-ADGroupMember -Identity "GRP_U_Responsable_ADV" -Members $SamAccountName}
            "Commercial" {Add-ADGroupMember -Identity "GRP_U_Commercial_B2B"; Add-ADGroupMember -Identity "GRP_U_Commercial_B2C"; Add-ADGroupMember -Identity "GRP_U_Commercial_DI"; Add-ADGroupMember -Identity "GRP_U_Commercial_GC" -Members $SamAccountName}
            "Responsable B2B" {Add-ADGroupMember -Identity "GRP_U_Responsable_B2B" -Members $SamAccountName}
            "Responsable B2C" {Add-ADGroupMember -Identity "GRP_U_Responsable_B2C" -Members $SamAccountName}
            "Directrice Commercial" {Add-ADGroupMember -Identity "GRP_U_Direction_Commercial_DI" -Members $SamAccountName}
            "Responsable Grands Comptes" {Add-ADGroupMember -Identity "GRP_U_Responsable_Grands_Comptes" -Members $SamAccountName}
            "Acheteur" {Add-ADGroupMember -Identity "GRP_U_Acheteur" -Members $SamAccountName}
            "Responsable achat" {Add-ADGroupMember -Identity "GRP_U_Responsable_achat" -Members $SamAccountName}
            "Agent Client" {Add-ADGroupMember -Identity "GRP_U_Agent_Client" -Members $SamAccountName}
            "Responsable Service Client" {Add-ADGroupMember -Identity "GRP_U_Responsable_Service_Client" -Members $SamAccountName}
        }
}