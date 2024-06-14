# **Sommaire**

1) Mise en place et Utilisation nouveau Script pour l'Active Directory

2)  2
   
## **1. Mise en place et Utilisation nouveau Script pour l'Active Directory.**

Suite aux nouvelles informations concernant la mise à jour de la base de donées des collaborateurs et collaboratrices, nous avons retravailler les Scripts associés à l'Active Directory :  
[Base de donnée orignale](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/s09_Pharmgreen.xlsx)  
[Base de donnée S14](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/s14_Pharmgreen.xlsx)  

La nomenclature a été mise à jour et trouvable ici :  
[Nomenclature S14](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Nomenclature_S14.xlsx)

Ensuite le fichier de mise en forme du fichier Excel en CSV a été mise à jour pour rajouter deux colonnes pour la gestion des Groupes Utilsiateurs et Ordinateur, cela nous permet d'avoir un seul fichier CSV pour effectuer une bonne partie des modifiation de l'AD.  
[Mise en forme CSV](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/mise_en_forme_CSV.ps1) ==> Prend en comtpe la base de donnée original  
[Mise en forme CSV S14](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/mise_en_forme_CSV_S14.ps1) ==> Prend en comtpe la base de donnée S14  

Certains script ont été repris pour plus clarté que ça soit dans la lecture du code ou des informations affiché une fois le script lancé ou pour gérer plus d'information.
[Modification information Utilisateur](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Modif_Utilisateur_auto.ps1)  
Script modifié pour intégrer les modification des informations utilisateur suite à la nouvelle base données (changement de service, département, numéro de téléphone, ...)  
Il ne modifie en aucun cas les noms, prénoms, adresse mail, ID de compte, si il y a des besoins (par exemple en cas de divorce/mariage/changement de nom) cela sera fait manuellement.

Il est impératif de vérifier avant l'éxcution du code que le script va cherche le bon fichier CSV (dans notre cas **s14_Pharmgreen.csv**) :
- Normalement l'information à changer se trouve sous cette forme la `$File = "$FilePath\s09_Pharmgreen.csv"` soit en début de script,  soit en fin script dans la partie `INITIALISATION`

Nouveau Script créés :
- [Script Difference Utilisateurs](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Difference_User.ps1)
  - Diiférencie deux base données (ici l'original et la version S14) et liste les utilsiateur à supprimer ==> le tout dans un nouveau fichier appelé `Difference.csv`
- [Script Suppression_Utilisateurs](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Suppression_Utilisateur.ps1)
  - A partir du fichier  `Difference.csv`,désactive et déplace les utilsateurs dans une nouvelle Organization Unit appelé **User_Pharmgreen_Disable** et les supprime des groupes dans lesquels ils étaient affectés.

### Cas Spéciaux

#### Changement de Nom Utilisateurs et Utilisatrices
En cas de changement de nom suite à un mariage / divorce ou autre raison, nous vous incitons à faire les potentiels modifications des utilisateur manuellement, lors du lancement du script **Modif_Utilisateur_auto.ps1** :
- Vous aurez un message d'erreur vous indiquant que la modification n'as pas put être effectué (se reférer soit à ce qui est indiqué à l'écran, soit au fichier log une fois implémenté correctement)
- Il vous suffit donc de reprendre la base de donnée qui vous a été transmise et donc faire les modifications sur l'utilisateur ou utilisatrice.
  - Ne surtout pas modifier ID de connexion et adresse mail, pour ne pas créée de problème dans la base de donnée de l'AD et pour l'utilisateur ou utilisatrice (connexion impossible, perte de donnée dans les dossier perso, ...)
 
#### Changement de Nom Département / Service / Fonction
Nous vous conseillons de faire les modifications manuellement et de reprendre les potentiels GPO ou autre qui pourrait être impactés (dossier partagé département/service vérifié les droit d'accès avec les nouveaux noms).  
Pensez ensuite à modifier le Script **mise_en_forme_CSV.ps1** et mettre à jour les remplacements des nom des Département / Service ou fonction qui ont été ajouté/modifié suite à une ise à jour de la base de données.  
Cela permettra aux autres scripts d'avoir les dernières informations à jour lors de leur utilsiation.
