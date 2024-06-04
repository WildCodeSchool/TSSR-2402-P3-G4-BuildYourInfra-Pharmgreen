Clear-Host
##############################################
#                                            #
#   Remplissage des groupe automatiquement   #
#                                            #
##############################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
### Initialisation
$File = "$FilePath\liste_utilisateur_group.csv"
$Users = Import-Csv -Path $File -Delimiter "," -Header "Prenom","Nom","fonction"
### Main
foreach ($User in $Users) {
    $SamAccountName = ($User.Prenom + "." + $User.Nom).ToLower()
    
    if ($User.fonction -ne ""){
        Switch ($User.fonction) {
            "GRP_U_CEO" {Add-ADGroupMember -Identity "GRP_U_CEO" -Members $SamAccountName}
            "GRP_U_Charge_Communication" {Add-ADGroupMember -Identity "GRP_U_Charge_Communication" -Members $SamAccountName}
            "GRP_U_Charge_Presse" {Add-ADGroupMember -Identity "GRP_U_Charge_Presse" -Members $SamAccountName}
            "GRP_U_Charge_Droit_Communication" {Add-ADGroupMember -Identity "GRP_U_Charge_Droit_Communication" -Members $SamAccountName}
            "GRP_U_Designer_Graphique" {Add-ADGroupMember -Identity "GRP_U_Designer_Graphique" -Members $SamAccountName}
            "GRP_U_Direction_Communication" {Add-ADGroupMember -Identity "GRP_U_Direction_Communication" -Members $SamAccountName}
            "GRP_U_Photographe" {Add-ADGroupMember -Identity "GRP_U_Photographe" -Members $SamAccountName}
            "GRP_U_Publicitaire" {Add-ADGroupMember -Identity "GRP_U_Publicitaire" -Members $SamAccountName}
            "GRP_U_Responsable_Publicite" {Add-ADGroupMember -Identity "GRP_U_Responsable_Publicite" -Members $SamAccountName}
            "GRP_U_Responsable_Relation_Media" {Add-ADGroupMember -Identity "GRP_U_Responsable_Relation_Media" -Members $SamAccountName}
            "GRP_U_Webmaster" {Add-ADGroupMember -Identity "GRP_U_Webmaster" -Members $SamAccountName}
            "GRP_U_Controleur_Gestion" {Add-ADGroupMember -Identity "GRP_U_Controleur_Gestion" -Members $SamAccountName}
            "GRP_U_Comptable" {Add-ADGroupMember -Identity "GRP_U_Comptable" -Members $SamAccountName}
            "GRP_U_Analyste_Financier" {Add-ADGroupMember -Identity "GRP_U_Analyste_Financier" -Members $SamAccountName}
            "GRP_U_DAF" {Add-ADGroupMember -Identity "GRP_U_DAF" -Members $SamAccountName}
            "GRP_U_Assistant_Direction" {Add-ADGroupMember -Identity "GRP_U_Assistant_Direction" -Members $SamAccountName}
            "GRP_U_Secretaire" {Add-ADGroupMember -Identity "GRP_U_Secretaire" -Members $SamAccountName}
            "GRP_U_Directeur_Adjoint" {Add-ADGroupMember -Identity "GRP_U_Directeur_Adjoint" -Members $SamAccountName}
            "GRP_U_Community_Manager" {Add-ADGroupMember -Identity "GRP_U_Community_Manager" -Members $SamAccountName}
            "GRP_U_Responsable_Marketing_Digital" {Add-ADGroupMember -Identity "GRP_U_Responsable_Marketing_Digital" -Members $SamAccountName}
            "GRP_U_Analyste_Web" {Add-ADGroupMember -Identity "GRP_U_Analyste_Web" -Members $SamAccountName}
            "GRP_U_Content_Manager" {Add-ADGroupMember -Identity "GRP_U_Content_Manager" -Members $SamAccountName}
            "GRP_U_Charge_Promotion" {Add-ADGroupMember -Identity "GRP_U_Charge_Promotion" -Members $SamAccountName}
            "GRP_U_Chef_Projet" {Add-ADGroupMember -Identity "GRP_U_Chef_Projet" -Members $SamAccountName}
            "GRP_U_Assistant_Marketing" {Add-ADGroupMember -Identity "GRP_U_Assistant_Marketing" -Members $SamAccountName}
            "GRP_U_Coordinateur_Marketing" {Add-ADGroupMember -Identity "GRP_U_Coordinateur_Marketing" -Members $SamAccountName}
            "GRP_U_Responsable_Marketing_Operationnel" {Add-ADGroupMember -Identity "GRP_U_Responsable_Marketing_Operationnel" -Members $SamAccountName}
            "GRP_U_Chef_Produit" {Add-ADGroupMember -Identity "GRP_U_Chef_Produit" -Members $SamAccountName}
            "GRP_U_Gestionaire_Marque" {Add-ADGroupMember -Identity "GRP_U_Gestionaire_Marque" -Members $SamAccountName}
            "GRP_U_Responsable_Gamme" {Add-ADGroupMember -Identity "GRP_U_Responsable_Gamme" -Members $SamAccountName}
            "GRP_U_Directeur_Marketing_Strategique" {Add-ADGroupMember -Identity "GRP_U_Directeur_Marketing_Strategique" -Members $SamAccountName}
            "GRP_U_Chercheur" {Add-ADGroupMember -Identity "GRP_U_Chercheur" -Members $SamAccountName}
            "GRP_U_Responsable_Recherche" {Add-ADGroupMember -Identity "GRP_U_Responsable_Recherche" -Members $SamAccountName}
            "GRP_U_Laborantin" {Add-ADGroupMember -Identity "GRP_U_Laborantin" -Members $SamAccountName}
            "GRP_U_Formateur" {Add-ADGroupMember -Identity "GRP_U_Formateur" -Members $SamAccountName}
            "GRP_U_Agent_RH" {Add-ADGroupMember -Identity "GRP_U_Agent_RH" -Members $SamAccountName}
            "GRP_U_Animateur_securite" {Add-ADGroupMember -Identity "GRP_U_Animateur_securite" -Members $SamAccountName}
            "GRP_U_Auditeur" {Add-ADGroupMember -Identity "GRP_U_Auditeur" -Members $SamAccountName}
            "GRP_U_Technicien_HSE" {Add-ADGroupMember -Identity "GRP_U_Technicien_HSE" -Members $SamAccountName}
            "GRP_U_Agent_logistique" {Add-ADGroupMember -Identity "GRP_U_Agent_logistique" -Members $SamAccountName}
            "GRP_U_Responsable_Logistique" {Add-ADGroupMember -Identity "GRP_U_Responsable_Logistique" -Members $SamAccountName}
            "GRP_U_Gestionnaire_immobilier" {Add-ADGroupMember -Identity "GRP_U_Gestionnaire_immobilier" -Members $SamAccountName}
            "GRP_U_Juriste_CTR" {Add-ADGroupMember -Identity "GRP_U_Juriste_CTR" -Members $SamAccountName}
            "GRP_U_Responsable_Juridique" {Add-ADGroupMember -Identity "GRP_U_Responsable_Juridique" -Members $SamAccountName}
            "GRP_U_Developpeur" {Add-ADGroupMember -Identity "GRP_U_Developpeur" -Members $SamAccountName}
            "GRP_U_Data_Scientist" {Add-ADGroupMember -Identity "GRP_U_Data_Scientist" -Members $SamAccountName}
            "GRP_U_Gestionnaire_ADV" {Add-ADGroupMember -Identity "GRP_U_Gestionnaire_ADV" -Members $SamAccountName}
            "GRP_U_Responsable_ADV" {Add-ADGroupMember -Identity "GRP_U_Responsable_ADV" -Members $SamAccountName}
            "GRP_U_Commercial_B2B" {Add-ADGroupMember -Identity "GRP_U_Commercial_B2B" -Members $SamAccountName}
            "GRP_U_Responsable_B2B" {Add-ADGroupMember -Identity "GRP_U_Responsable_B2B" -Members $SamAccountName}
            "GRP_U_Commercial_B2C" {Add-ADGroupMember -Identity "GRP_U_Commercial_B2C" -Members $SamAccountName}
            "GRP_U_Responsable_B2C" {Add-ADGroupMember -Identity "GRP_U_Responsable_B2C" -Members $SamAccountName}
            "GRP_U_Commercial_DI" {Add-ADGroupMember -Identity "GRP_U_Commercial_DI" -Members $SamAccountName}
            "GRP_U_Responsable_Grands_Comptes" {Add-ADGroupMember -Identity "GRP_U_Responsable_Grands_Comptes" -Members $SamAccountName}
            "GRP_U_Acheteur" {Add-ADGroupMember -Identity "GRP_U_Acheteur" -Members $SamAccountName}
            "GRP_U_Responsable_achat" {Add-ADGroupMember -Identity "GRP_U_Responsable_achat" -Members $SamAccountName}
            "GRP_U_Agent_Client" {Add-ADGroupMember -Identity "GRP_U_Agent_Client" -Members $SamAccountName}
            "GRP_U_Responsable_Service_Client" {Add-ADGroupMember -Identity "GRP_U_Responsable_Service_Client" -Members $SamAccountName}
        }
    }
}