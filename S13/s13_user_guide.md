# **Sommaire**

1) Creation dossier partager utilisateur

2) Surveillance et placement des ordinateur dans les bonne Organizaion Units.



## **1. Creation dossier partager utilisateur.**

- Dans le lecteur E: creer un dossier utilisateur
- faire un clique droit dessus -> Properties -> sharing -> Advanced Sharing
- cocher la case Share this folder
- en Share name : utilisateurs$ (le $ sert a cacher le chemin reseau)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0cfbad3c-bb73-4b04-a780-100b77ae9d64)

- cliquer sur permission et faire comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0fc32638-52f3-4a0a-a586-0a33588805ec)


- valider, de retour sur la fenetre Properties allez a l'onglet Security

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7c5e044c-bcad-40ad-827b-05cfab72e61e)


- cliquer sur Advanced
- cliquer sur le bouton Disable inheritence

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b84b4ce7-a1b9-4fa4-97ba-e6cb8af1ff55)


- cliquez sur add et ajouter les permissions comme sur l'image au dessus et mettre Full control sur toutes les Permissions

## creation de la GPO

- User Configuration/Preferences/windows Settings/Drive maps
- creer un nouveau mappage comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/139cba92-a24d-4bdb-9d93-e8d16b87c868)



- et dans l'onglet common : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/994ca9e9-3600-4444-a1e7-5408333f1bda)


- User Configuration/Preferences/windows Settings/Folders
- creer un nouveau dossier comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a7499789-35dd-456b-b328-1ef4dd9c5948)


- et dans l'onglet common : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9aa01851-0ea8-4e98-9d9b-1f3caa800be8)


- User Configuration/Preferences/windows Settings/Shortcuts
- creer un nouveau racourci comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c9e6b6a7-08c8-4f94-88f3-334a10561fd4)


- et dans l'onglet common 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c4dbaecc-aca8-4c80-b8b1-f00ef35bc898)

- appliquer la GPO a l'OU User_Pharmgreen
- connecter vous avec un compte client et vous devriez voir apparaitre un dossier "Dossier Perso" dans les emplacement réseau de l'ordinateur.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/59adb6ba-935f-4694-b65a-cb12853a6ae8)



## **2. Surveillance et placement des ordinateur dans les bonne Organizaion Units.**

### **Etape 1 : Mise en place du script**

**Manipulation à faire sur le poste serveur gloabal qui contient l'Active Directory.**
Tout d'abord il faur récupérer le script mis à dispo ici :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Verification_computer.ps1  
Et le placer comme pour les autres Scritpts (voir S10_User_Guide) dans le dossier `c:\Script`.  

### **Etape 2 : Configuration de la Tâche Planifié**

Lancé le **Planificateur de Taches** en tappant `Task Scheduler` dans la barre de recherche du **menu démarrer** du serveur.  

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/1dcfd6a8-f8b2-454b-861d-4e800476e80e)

- Choisir **Action** puis **Create Task**  
- Dans l'onglet **General**, donnez lui un nom expliciite dans notre exemple `Verif_Placement_PC_AD` et une description explicite par la même occasion.  
- Laissez les autres options par défaut pas besoin de les modifer pour le moment. *(Si besoin de changer des paramètres nous vous ferons un rappel dans un futur User Guide)*  
- Dans l'onglet **Trigger**, on définit le *trigger/déclencheur* en cliquant sur *new* :  
  - Choisir *Daily* dans la colonne *Settings*.  
  - Selection une date et heure de début via le selecteur date et heure de la ligne *Start*  
  - *Recur every* : mettre 1, pour que cela s'éffectue tous les jours.  
  - Cocher bien *Enabled* tout en bas de la fênetre.

- Le résultat final devrait ressembler à ça :  
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/38941a49-f667-4ecf-b9fb-cf96d1428fff)  

- Dans l'onglet **Action**, on définit l'action à réaliser en cliquant sur *new* :  
  - On choisit *Start a program*, dans le menu Action.  
  - *Program/Script* : `pwsh.exe` si Powershell 7 (ou supérieur) est installé, sinon `Powershell.exe`.  
  - *Add Arguments* : lui indiquer le chemin d'enregistrement du script dans notre exemple `C:\Script\Verification_computer.ps1`.  

-  Le résultat final devrait ressembler à ça :
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/0d5f5983-f2af-45e6-96ed-ae5548b89a5d)  

- Validez vos modifications, voila votre tâche planifié éxecutant un script permettant de vérifier et déplacer ordinateur dans les bonnes Organizaion Units est en place.



