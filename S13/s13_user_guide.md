# **Sommaire**

1. [Création dossiers partagés utilisateurs](#1-création-dossiers-partagés-utilisateurs)
2. [Création dossiers partagés départements et services](#2-création-dossiers-partagés-départements-et-services)
3. [Surveillance et placement des ordinateurs dans les bonnes Organization Units](#3-surveillance-et-placement-des-ordinateurs-dans-les-bonnes-organization-units)
4. [Sauvegardes](#4-sauvegardes)
5. [GPO LAPS](#5-gpo-laps)
6. [Restriction Horaires](#6-restriction-horaires)
   
# **1. Création dossiers partagés utilisateurs.**

- Dans le lecteur `E:` créer un dossier utilisateur
- Faire un clic droit dessus -> `Properties -> sharing -> Advanced Sharing`
- Cocher la case `Share this folder`
- En Share name : utilisateurs$ (le $ sert a cacher le chemin réseau)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0cfbad3c-bb73-4b04-a780-100b77ae9d64)

- Cliquer sur `permission` et faire comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0fc32638-52f3-4a0a-a586-0a33588805ec)


- Valider, de retour sur la fenetre `Properties` allez a l'onglet `Security`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7c5e044c-bcad-40ad-827b-05cfab72e61e)


- Cliquer sur `Advanced`
- Cliquer sur le bouton `Disable inheritence`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b84b4ce7-a1b9-4fa4-97ba-e6cb8af1ff55)


- Cliquer sur `add` et ajouter les permissions comme sur l'image au-dessus et mettre `Full control` sur toutes les Permissions

### Création de la GPO

- `User Configuration -> Preferences -> windows Settings -> Drive maps`  
- Créer un nouveau mappage comme cela :  

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/139cba92-a24d-4bdb-9d93-e8d16b87c868)

- Et dans l'onglet `common` :  

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/994ca9e9-3600-4444-a1e7-5408333f1bda)

- `User Configuration -> Preferences -> windows Settings -> Folders`  
- Créer un nouveau dossier comme cela :  

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a7499789-35dd-456b-b328-1ef4dd9c5948)

- Et dans l'onglet `common` : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9aa01851-0ea8-4e98-9d9b-1f3caa800be8)

- Appliquer la GPO a l'OU `User_Pharmgreen`  
- Connectez-vous avec un compte client et vous devriez voir apparaitre un dossier "Dossier Perso" dans les emplacement réseau de l'ordinateur.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/59adb6ba-935f-4694-b65a-cb12853a6ae8)

# **2. Création dossiers partagés départements et services**

- Dans le lecteur `E:` créer un dossier par département
- Pour chaque dossier et sous-dossier, faire un clic droit dessus -> `Properties -> sharing -> Advanced Sharing`
- Cocher la case `Share this folder`
- En Share name : le_nom_du_dossier$ (le $ sert a cacher le chemin réseau)
- Suivre les mêmes étapes que pour la création des dossiers partagés utilisateurs, mais pour chaque dossier et sous-dossire

### Création de la GPO

Aller dans `User Configuration -> Preferences -> windows Settings -> Drive maps` et configurer comme ceci pour chaque département et service :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/de999fa0-89fa-4325-8f1b-74efa3469596)

Avec `N:` en lettre de disque pour les départements et `M:` pour les services.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/88981d50-b2cc-48a0-a531-668441f06c67)

# **3. Surveillance et placement des ordinateur dans les bonne Organization Units.**

## **Etape 1 : Mise en place du script**

**Manipulation à faire sur le poste serveur gloabal qui contient l'Active Directory.**
Tout d'abord il faur récupérer le script mis à dispo ici :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Verification_computer.ps1    
Et le placer comme pour les autres Scritpts (voir S10_User_Guide) dans le dossier `c:\Script`.  

## **Etape 2 : Configuration de la Tâche Planifiée**

Lancer le **Planificateur de Taches** en tapant `Task Scheduler` dans la barre de recherche du **menu démarrer** du serveur.  

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/1dcfd6a8-f8b2-454b-861d-4e800476e80e)

- Choisir `Action` puis `Create Task`
- Dans l'onglet `General`, donnez lui un nom explicite (dans notre exemple `Verif_Placement_PC_AD`) et une description explicite par la même occasion.  
- Laissez les autres options par défaut, pas besoin de les modifer pour le moment. *(Si besoin de changer des paramètres nous vous ferons un rappel dans un futur User Guide)*  
- Dans l'onglet `Trigger`, on définit le *trigger/déclencheur* en cliquant sur `new` :  
  - Choisir `Daily` dans la colonne `Settings`, 
  - Sélectionner une date et heure de début via le selecteur date et heure de la ligne `Start`,
  - `Recur every` : mettre 1, pour que cela s'éffectue tous les jours,
  - Cochez bien `Enabled` tout en bas de la fênetre.

- Le résultat final devrait ressembler à ça :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/38941a49-f667-4ecf-b9fb-cf96d1428fff)  

- Dans l'onglet `Action`, on définit l'action à réaliser en cliquant sur `new` :  
  - On choisit `Start a program`, dans le menu `Action`.  
  - `Program/Script` : `pwsh.exe` si Powershell 7 (ou supérieur) est installé, sinon `Powershell.exe`.  
  - `Add Arguments` : lui indiquer le chemin d'enregistrement du script dans notre exemple `C:\Script\Verification_computer.ps1`.  

-  Le résultat final devrait ressembler à ça :
  
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/0d5f5983-f2af-45e6-96ed-ae5548b89a5d)  

- Validez vos modifications, voilà votre tâche planifiée éxecutant un script permettant de vérifier et déplacer les ordinateurs dans les bonnes Organizaion Units est en place.

# **3. Sauvegarde du volume où sont stockés les dossiers partagés**

Nos dossiers partagés sont sur le volume `E:` et sont sauvegardés sur `F:` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/242b69c3-945a-4c81-abf2-b929f29e0aa8)

Afin de faire une sauvegarde, nous avons installé `Windows Server Backup` via le gestionnaire de serveur en passant par le chemin habituel `Add Roles and Features` et nous avons mis en place une autre tâche planifiée comme expliqué plus haut : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/20e6d52a-34aa-47f6-a7c5-14b6b7ad51ab)

Dans `Actions`, on peut voir la commande suivante : `wbadmin start backup -backupTarget:F: -include:E: -quiet` qui exécute donc une sauvegarde du volume `E:` à destination du volume `F:` et ce tous les dimanches à 16h.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d0f99574-993a-4548-9133-86b675fbab22)

# **4. LAPS** 

## Configurer la GPO Windows LAPS

Les paramètres de LAPS dans la GPO sont situés sous `Computer Organization -> Administrative Templates -> System -> LAPS`.

- La première que nous allons configurer est `Configure password backup directory` comme ceci : 

![image](https://github.com/JuGuillot/test/assets/161329881/be6de093-8e14-4c4c-8a9f-f704568e636a)

- Ensuite on passe à `Password settings` :

![image](https://github.com/JuGuillot/test/assets/161329881/fbdfaaec-8f2d-4a9d-8bc6-7fc6b714fe20)

- `Configure siez of encrypted password history` :

![image](https://github.com/JuGuillot/test/assets/161329881/81e4c2a8-fbbe-46b7-a094-2e516ea1bae4)

- `Enable password encryption` :

![image](https://github.com/JuGuillot/test/assets/161329881/7c2f6902-1a08-4f17-848d-df112f5a5b8d)

Votre GPO est désormais configurée, vous pouvez fermer la fenêtre.

## Vérification

Si vous retournez dans les propriétés d'un des PC du domaine, dans `LAPS`, on voit bien qu'un mot de passe pour l'administrateur local a été généré :

![image](https://github.com/JuGuillot/test/assets/161329881/5b16015e-8662-42f1-bcec-3f5e89f6fbdb)

## **5. Restriction Horaire.**

Il est possible de mettre en place une restriction horaire, pour limiter les heures de connexion sur les machines du parc informatique de l'Active Directory pour les membres non administrateur du domaine ou local.  
Il a été demandé d'autoriser la connexion de 7h30 à 20h, du lundi au samedi.  
Ne pouvant que définir des heures "rondes" (exemple 7h et pas 7h30) dans l'Active Directory, on a décidé de définir les plages d'autorisaton de 7h à 20h, du Lundi au Samedi.  

Pour ce faire, il faut récupérer le script situé ici :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Limitation_Horaire.ps1  

Le script autorise la connexion de 7h à 20h, du Lundi au Samedi puur tous les utilisateurs de l'Organizations Unit **User_Pharmgreen**.  
En cas d'ajout d'utilisateur dans cette OU, il faudra relancer le script.  

Il est prévu, dans le futur, de le faire évoluer le script pour donner le choix des jours, plages horaires et des Organization Units ciblées.  

