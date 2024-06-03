# Guide Utilisateur : Création d'une GPO

Ce guide vous aidera à créer et configurer une GPO (Group Policy Object) dans un environnement Windows Server.

## Prérequis

- Un domaine Active Directory fonctionnel.
- Accès à un contrôleur de domaine (DC) avec les outils de gestion des stratégies de groupe installés.

## Étapes de Création d'une GPO

### 1. Ouvrir la Console de Gestion des Stratégies de Groupe

1. Connectez-vous à votre contrôleur de domaine.
2. Ouvrez la console "Group Policy Management" :
   - Appuyez sur `Windows + R`, tapez `gpmc.msc` et appuyez sur `Entrée`.

### 2. Créer une Nouvelle GPO

1. Dans la console "Group Policy Management", cliquez droit sur le conteneur "Group Policy Objects" et sélectionnez "New".
2. Donnez un nom à votre nouvelle GPO (par exemple, "Politique de Sécurité") et cliquez sur "OK".

### 3. Lier la GPO à une Unité d'Organisation (OU)

1. Dans la console "Group Policy Management", trouvez l'OU à laquelle vous souhaitez appliquer la GPO.
2. Cliquez droit sur l'OU et sélectionnez "Link an Existing GPO".
3. Sélectionnez la GPO que vous avez créée et cliquez sur "OK".

### 4. Modifier la GPO

1. Dans la console "Group Policy Management", cliquez droit sur la GPO que vous avez créée et sélectionnez "Edit".
2. La console de l'Éditeur de gestion des stratégies de groupe s'ouvre, vous permettant de configurer les paramètres de votre GPO.

### 5. Configurer les Paramètres de la GPO

1. **Configuration de l'ordinateur** :
   - Allez dans "Computer Configuration" > "Policies".
   - Configurez les paramètres souhaités sous "Windows Settings" et "Administrative Templates".

2. **Configuration de l'utilisateur** :
   - Allez dans "User Configuration" > "Policies".
   - Configurez les paramètres souhaités sous "Windows Settings" et "Administrative Templates".

### 6. Appliquer et Vérifier la GPO

1. Fermez l'Éditeur de gestion des stratégies de groupe.
2. La GPO sera appliquée lors de la prochaine mise à jour des stratégies de groupe sur les ordinateurs et utilisateurs ciblés.
   - Vous pouvez forcer une mise à jour immédiate en exécutant `gpupdate /force` sur un client cible.

### 7. Dépannage

1. Utilisez la commande `gpresult /r` pour vérifier quelles GPO sont appliquées à un utilisateur ou ordinateur spécifique.
2. Vérifiez les journaux d'événements pour les erreurs de stratégie de groupe sous "Applications and Services Logs" > "Microsoft" > "Windows" > "GroupPolicy".



# Ajout d'une serveur Windows Core à l'Active Directory via un script

Se placer sur le serveur principal dans le dossier `C:\Ressources` et récupérer les deux deux fichiers aux adresses suivantes :
- Script : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/script_AD-DS.ps1
- Fichier de configuration : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/configAD-DS.csv

Ensuite, il faut lancer un serveur Windows Core, le mettre sur le sur le même réseau que le serveur (172.16.3.0/24) Principal et récupérer le script et le fichier de configuration grâce aux commande suivantes :
- Création d'un répertoire : `New-Item -ItemType Directory C:\Script`.
- Copie du script : `Copy \\Winserv\Ressources\script_AD-DS.ps1 C:\Script`.
- Copie du fichier de configuration : `Copy \\Winserv\Ressources\ConfigAD-DS.csv C:\Script`.

Vous pouvez modifier le fichier **ConfigAD-DS.CSV**, grâce à la commande suivante :
- Se placer dans le bon répertoire où est enregistré le fichier, puis lancer `notepad.exe ConfigAD-DS.csv`.
- Attention, dans la modification des champs cela peut entrainer des erreurs.
- Les deux premiers champs correspondent au nouveau nom donné au serveur et le second à sa nouvelle adresse IP.  

Exécuter le script et, après un redémarrage automatique, le serveur a bien été renommé et intégré au domaine.
![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/c0ec11a2-cbf7-47c5-af48-197a4a433e94)

Vous pouvez maintenant ajouter le serveur core sur le serveur principal via l'outil **Serveur Manager** (S10_UserGuide.md) et vous pouvez voir que le serveur est bien ajouté et à son rôle AD-DS.

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/b2da02b5-eded-4720-beef-c4b980f9e359)

# Script automatisation GLPI sur Debian

Afin de récupérer le script et le fichier de configuration sur Debian :

- `wget https://raw.githubusercontent/](https://raw.githubusercontent.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/main/Ressources/Script/glpi_install.sh`
- `wget https://raw.githubusercontent.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/main/Ressources/config.txt`

Dans le fichier `config.txt`, entrez le nom de la base de données dans `db_name`, le nom de l'utilisateur dans `db_user`, le mot de passe dans `db_pass`, et le nom de l'interface réseau dans `network_interface`

Ensuite faire un `bash glpi_install.sh`.


Une fois le script terminé, aller sur un client et taper l'adresse IP de votre serveur, rentrez ensuite les informations que vous aurez précisé dans le `config.txt` et installer GLPI.

# Création d'un ticket dans GLPI

Après vous être identifié sur GLPI avec vos identifiants, vous arrivez sur cette page : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/10f739f3-8a99-4656-87ba-0df5a952aa16)

Cliquez sur "Créer un ticket" et remplissez les informations demandées.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d58ec196-5769-4ca4-ae03-b76d69d83694)

Puis cliquez sur "Soumettre la demande."




