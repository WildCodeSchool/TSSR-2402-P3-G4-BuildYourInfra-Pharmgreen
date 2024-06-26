# Sommaire

1. [Guide Utilisateur : Création d'une GPO](#guide-utilisateur--création-dune-gpo)
    1. [Prérequis](#prérequis)
    2. [Étapes de Création d'une GPO](#étapes-de-création-dune-gpo)
        1. [Ouvrir la Console de Gestion des Stratégies de Groupe](#1-ouvrir-la-console-de-gestion-des-stratégies-de-groupe)
        2. [Créer une Nouvelle GPO](#2-créer-une-nouvelle-gpo)
        3. [Lier la GPO à une Unité d'Organisation (OU)](#3-lier-la-gpo-à-une-unité-dorganisation-ou)
        4. [Modifier la GPO](#4-modifier-la-gpo)
        5. [Configurer les Paramètres de la GPO](#5-configurer-les-paramètres-de-la-gpo)
        6. [Appliquer et Vérifier la GPO](#6-appliquer-et-vérifier-la-gpo)
        7. [Dépannage](#7-dépannage)
2. [Liste GPO](#liste-gpo)
    1. [GPO default Domain Policy](#gpo-default-domain-policy)
    2. [GPO_Secu_Acces_Base_Registre](#gpo_secu_acces_base_registre)
    3. [GPO_secu_Date_Time](#gpo_secu_date_time)
    4. [GPO secu_Ecran_veille_avec_password](#gpo-secu_ecran_veille_avec_password)
    5. [GPO_panneaux_configuration](#gpo_panneaux_configuration)
    6. [GPO_Secu_peripheriques_amovibles](#gpo_secu_peripheriques_amovibles)
    7. [GPO_secu_Regle_par-feu](#gpo_secu_regle_par-feu)
    8. [GPO_Secu_Restriction_Software](#gpo_secu_restriction_software)
    9. [GPO_Secu_Verouillage_de_compte](#gpo_secu_verouillage_de_compte)
    10. [GPO_Std_Alimentation](#gpo_std_alimentation)
    11. [GPO_Std_Dpl_7Zip](#gpo_std_dpl_7zip)
    12. [GPO_Std_Dpl_Firefox](#gpo_std_dpl_firefox)
    13. [GPO_Std_Firefox_defaut](#gpo_std_firefox_defaut)
    14. [GPO_Std_Parametres_Firefox](#gpo_std_parametres_firefox)
    15. [GPO_Std_Restriction_Edge](#gpo_std_restriction_edge)
    16. [GPO_Std_Wallpaper](#gpo_std_wallpaper)
3. [Ajout d'un serveur Windows Core à l'Active Directory via un script](#ajout-dun-serveur-windows-core-à-lactive-directory-via-un-script)
4. [Script automatisation GLPI sur Debian](#script-automatisation-glpi-sur-debian)
5. [Création d'un ticket dans GLPI](#création-dun-ticket-dans-glpi)
6. [Ajouter un Annuaire LDAP dans GLPI](#-Ajouter-un-Annuaire-LDAP-dans-GLPI)


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


# Liste GPO
**Ci-dessous une liste non exhaustive de GPO que vous pouvez mettre en place**

## GPO default Domain Policy
 - chemin : `computer configuration/policies/Windows Settings/security settings/Account policies/Password policies`
    - Enforce password history : 2 password remembered
    - Maximum password age : 90 days
    - minimum password age : 30 days
    - minimum password length : 12 characters
    - Minimum password length audit : Not defined
    - Password must meet complexity requierements : Enabled
    - Relax minimum password length limits : Not defined
    - Store password using reversible encryption : disabled
- chemin : `computer configuration/policies/Windows Settings/security settings/Account policies/account lockout policies`
    - Account lockout duration : 10 min
    - Account lockout threshold : 5 invalid logon attempts
    - Allow Administrator account lockout : not defined
    - Reset account lockout counter after : 10 min


## GPO_Secu_Acces_Base_Registre
- chemin : `User configuration/Policies/administrative Templates/System/`
    - Prevent access to registry editing tools : enabled
        - Disable regedit from running silently : yes

## GPO_secu_Date_Time
- chemin : `Computer Configuration/Policies/Administrative Templates/system/windows Time Service/time providers`
    - Configure Windows NTP Client : enabled
        - NTPServer : pool.ntp.br,0x1 time1.google.com,0x1
        - Type : NTP
        - CrossSiteSyncFlags : 2
        - ResolvePeerBackoffMinutes : 15
        - ResolvePeerBackoffMaxTimes : 7
        - SpecialPollInterval : 3600
        - EventLogFlags : 0


## GPO secu_Ecran_veille_avec_password
- chemin : `User configuration/Policies/administrative template/control panel/Personlization`
    - Enable screen saver : Enabled
    - Force specific screen saver : Enabled
        - Screen saver executable name : %windir%\system32/rundl32.exe user32.dll,lockWorkStation
    - Password protect the screen saver : Enabled
    - Screen saver timeout : Enabled
        - Number of second to wait to enable the screen saver : 900

## GPO_panneaux_configuration
- chemin : `User Configuration/Administrative Template/Control Panel/Add or Remove Programs`
    - Hide Add New Programs page : Enabled
    - Hide the "Add a Program from CD-ROM or floppy disk" option : Enabled
    - Remove Add or Remove Program : Enabled
- chemin : `User Configuration/Administrative Template/Control Panel/Regional and Language Options`
    - Hide Regional and Language Options administrative options : Enabled

## GPO_Secu_peripheriques_amovibles
- chemin : `Computer Configuration/Policies/Administrative Templates/system/Removable Storage Access`
    - All Removable Storage classes : Deny all access : Enabled

## GPO_secu_Regle_par-feu
- chemin : `Computer Configuration/Policies/Administrative Templates/Windows Components/Windows Security/Firewall and network protection`
    - Hide the Firewall and network protection area : Enabled

## GPO_Secu_Restriction_Software
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies\Enforcement`
    - cocher la case All Users Except local administrators
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies\Designated Fyle type Properties`
    - ajouter les extension PAF et VBS
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies/Security Levels/ Basic User`
    - appliquer set as default
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies/Additional Rules`
    - creer une nouvelles regles : %HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ProgramFilesDir%
        - security level : Unrestricted

## GPO_Secu_Verouillage_de_compte
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Account Policies/Account Lockout Policy`
    - Account lockout duration : 10 minutess
    - Account lockout threshold : 5 invalid logon attempts
    - Allow administrator account lockout : Enabled
    - Reset account lockout counter after : 10 minutes

## GPO_Std_Alimentation
- chemin : `Computer Configuration/Policies/Administrative Templates/System/Power Management/Sleep Settings`
    - Specify the system hibernate timeout (on battery) : Enabled
        - System Hibernate Timeout (seconds) : 3000
    - Specify the system sleep timeout (on battery) : Enabled
        - System Sleep Timeout (seconds) : 120
    - Specify the system sleep timeout (plugged in) : Enabled
        - System Sleep Timeout (seconds) : 2700
- chemin : `Computer Configuration/Policies/Administrative Templates/System/Power Management/Video and Display Settings`
    - Turn Off the Display (on battery) : Enabled
        - Turn Off the Dispplay (seconds) : 600
    - Turn off display (plugged in) : Enabled
        - Turn Off the Display (seconds) : 600

## GPO_Std_Dpl_7Zip
- chemin : `Computer Configuration/Policies/Software Settings`
    - faire new package ajouter l'instaleur de 7ZIP qui ce trouve dans \\\192.168.9.2\ressources

## GPO_Std_Dpl_Firefox
- chemin : `Computer Configuration/Policies/Software Settings`
    - faire new package ajouter l'instaleur de firefox qui ce trouve dans \\\192.168.9.2\ressources

## GPO_Std_Firefox_defaut
- chemin : `Computer Configuration/Policies/Administrative Templates/Windows Components/File Explorer`
    - Set a default associations configuration file : Enabled
        - Default Associations Configuration File : \\\192.168.9.2\Ressources\firefox.xml

## GPO_Std_Parametres_Firefox
- chemin : `Computer Configuration/Policies/Administrative Templates/Mozilla/Firefox/Addons`
    - Allow add-on installs from websites : Disabled
- chemin : `Computer Configuration/Policies/Administrative Templates/Mozilla/Firefox/Home`
    - Show Home button on toolbar : Enabled
    - Start Page : Enabled
    - URL for Home page : Enabled
        - URL : http://www.google.fr/
        - Don't allow the homepage to be changed : Enabled

## GPO_Std_Restriction_Edge
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restrictions Policies/Security levels/Additional Rules`
    - ajouter une regle de securité : C:\Prograam FIles(x86)\Microsoft\Edge
        - security level : Disalowed

## GPO_Std_Wallpaper
- chemin : `User Configuration/Policies/Administrative Templates/Desktop/Desktop`
    - Desktop Wallpaper : Enabled
        - Wallpaper Name : \\\192.168.9.2\Ressources\logo.png
        - Wallpaper Style : center



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

# Ajouter un Annuaire LDAP dans GLPI

## Introduction
Ce guide explique comment intégrer un annuaire LDAP, spécifiquement Active Directory, dans GLPI pour les besoins d'authentification. En suivant ces étapes, vous permettrez aux utilisateurs de s'authentifier en utilisant leurs identifiants Active Directory.

## Prérequis
- Accès à GLPI avec des droits administratifs.
- Adresse IP du contrôleur de domaine Active Directory.
- Informations de connexion d'un compte de service avec les droits nécessaires pour interroger l'annuaire LDAP.

## Ajout d'un Annuaire LDAP

1. **Connexion à GLPI :**
   Connectez-vous à GLPI avec un compte administrateur.

2. **Accéder aux Paramètres d'Authentification :**
   Dans le menu "Configuration", cliquez sur "Authentification".

3. **Ajouter un Annuaire LDAP :**
   - Cliquez sur "Annuaire LDAP".
   - Cliquez sur le bouton "Ajouter".

4. **Remplir le Formulaire :**
   Remplissez les champs du formulaire selon les indications suivantes :
   - **Nom :** Un nom convivial pour cet annuaire LDAP.
   - **Serveur par défaut :** Indiquez "Oui" s'il doit être utilisé par défaut.
   - **Actif :** Sélectionnez "Oui".
   - **Serveur :** Adresse IP du contrôleur de domaine.
   - **Port :** 389 (par défaut pour LDAP).
   - **Filtre de connexion :** Requête LDAP pour rechercher les utilisateurs actifs (`(&(objectClass=user)(objectCategory=person)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))`).
   - **BaseDN :** DN de l'OU où sont situés les utilisateurs (ex. `OU=Personnel,DC=it-connect,DC=local`).
   - **Utiliser bind :** Sélectionnez "Oui".
   - **DN du compte :** DN complet du compte de service (ex. `CN=Sync_GLPI,OU=Connecteurs,OU=Tiering,OU=IT,DC=it-connect,DC=local`).
   - **Mot de passe du compte :** Mot de passe du compte de service.
   - **Champ de l'identifiant :** `userprincipalname` ou `samaccountname`.
   - **Champ de synchronisation :** `objectguid`.
   - 
![config_glpi_connexion_ad_ds](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/6bdbf27a-97e0-4b62-ad2f-0d926175cda1)

5. **Sauvegarder la Configuration :**
   Cliquez sur "Ajouter" pour sauvegarder votre configuration.

## Forcer une Synchronisation Active Directory

1. **Accéder aux Utilisateurs :**
   Dans le menu "Administration", cliquez sur "Utilisateurs".
   

3. **Liaison Annuaire LDAP :**
   Cliquez sur le bouton "Liaison annuaire LDAP".

4. **Importer les Utilisateurs :**
   - Cliquez sur "Importation de nouveaux utilisateurs".
   - Lancez une recherche, sélectionnez les comptes à importer, puis cliquez sur "Actions" pour lancer l'import.

![Importation utilisateur](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/a4a28bdc-ca42-4335-84b9-9e849e7a9248)

![action_import_utilisateur](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/b06e6a85-9050-47ca-aa8b-37b2e468f129)


Remarque : Vous pouvez effectuer la même action pour un groupe il suffit de cliquer sur groupe.
