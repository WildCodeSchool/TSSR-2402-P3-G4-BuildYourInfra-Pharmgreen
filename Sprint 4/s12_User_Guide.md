# Tutoriel : Configuration de Firewall

## Prérequis

- Un serveur pfSense déjà installé
- Accès à l'interface web de pfSense

## Environnement

pfSense est configuré pour gérer les réseaux LAN, WAN et DMZ, avec les adresses suivantes :

- LAN : 172.16.2.253
- WAN : 10.0.0.3 (passerelle : 10.0.0.1)
- DMZ : 172.16.1.254

## Étape 1 : Configuration initiale de pfSense via l'interface web

1. Accéder à l'interface Web de pfSense :
    - Connecter un ordinateur au port LAN de pfSense.
    - Ouvrir un navigateur et aller à l'adresse : [http://172.16.2.253](http://172.16.2.253).
    - Se connecter avec les identifiants par défaut :
        - Nom d'utilisateur : admin
        - Mot de passe : pfsense.

![Image1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/24a6aa85-20ef-4465-8667-c367605e018a)


## Étape 2 : Configuration du réseau LAN, WAN et DMZ

1. Configurer le réseau LAN :
    - Aller dans **Interfaces > Assignments**.
    - Sélectionner **LAN**.
    - Configurer l'adresse IP LAN à `172.16.2.253/24`.
    - Sauvegarder les modifications.

2. Configurer le réseau WAN :
    - Aller dans **Interfaces > Assignments**.
    - Sélectionner **WAN**.
    - Configurer l'adresse IP WAN à `10.0.0.3/24`.
    - Configurer la passerelle WAN à `10.0.0.1`.
    - Sauvegarder les modifications.

3. Configurer le réseau DMZ :
    - Aller dans **Interfaces > Assignments**.
    - Ajouter une nouvelle interface pour la DMZ et nommer la DMZ.
    - Configurer l'adresse IP DMZ à `172.16.1.254/24`.
    - Sauvegarder les modifications.

![Image2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/9cd58a1c-ebaa-43de-87d2-65bb396fb1b4)


## Étape 3 : Configuration des routes statiques

1. Ajouter des routes statiques :
    - Aller dans **System > Routing**.
    - Sélectionner l'onglet **Static Routes**.
    - Cliquer sur **Add** pour ajouter une nouvelle route.
    - Configurer les routes pour permettre la communication entre les différents réseaux :
        - Destination Network : `172.16.3.0/24`
        - Gateway : `172.16.2.254`
    - Sauvegarder les modifications.
  
![Image3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/d1347fab-1f52-4aa7-b5fc-6e27a7661ed0)


## Étape 4 : Création d'un alias pour les ports HTTP et HTTPS

1. Créer un alias :
    - Aller dans **Firewall > Aliases**.
    - Cliquer sur **Add** pour créer un nouvel alias.
    - Nommer l'alias (par exemple, HTTP_HTTPS_ports).
    - Type : Port.
    - Ajouter `80` pour HTTP et `443` pour HTTPS dans le champ Port.
    - Sauvegarder et appliquer les modifications.

![Image4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/7055a3c9-84df-4d45-8aed-c75e7a5692c3)


## Étape 5 : Création des règles de pare-feu

1. Ajouter une règle pour autoriser le trafic HTTP et HTTPS :
    - Aller dans **Firewall > Rules**.
    - Sélectionner l'onglet **LAN**.
    - Cliquer sur **Add** pour ajouter une nouvelle règle.
    - Configurer la règle comme suit :
        - Action : Pass.
        - Interface : LAN.
        - Address Family : IPv4.
        - Protocol : TCP.
        - Source : any.
        - Destination : any.
        - Destination Port Range : choisir l'alias créé (HTTP_HTTPS_ports).
    - Sauvegarder et appliquer les modifications.

![Image5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/d1d3cdab-dcf3-4dc6-82e9-8f8664252e0a)


## Étape 6 : Vérification

1. Vérifier la connectivité :
    - Connecter un appareil au réseau LAN de pfSense.
    - Ouvrir un navigateur et essayer d'accéder à un site web (HTTP/HTTPS).
    - Naviguer sur Internet devrait être possible.


# Configuration du routeur Vyos :

En préambule, nous avons rajouté sur la VM qui nous sert de routeur les cartes réseau suivantes : 

- vmbr13 avec l'adresse `172.16.3.1/24` pour les machines "serveurs"
- vmbr14 avec l'adresse `192.168.9.1/24` pour les machines "client"

et modifié la vmbr10 en `172.16.2.1/24`.

La VM a donc 3 cartes réseau configurées de la sorte :

- `eth0 172.16.3.254/24`
- `eth1 192.168.9.254/24`
- `eth2 172.16.2.254/24`

Afin de les mettre en place il faut faire ceci, une fois connecté (id : vyos/mdp : vyos) :
- `config` pour rentrer en mode de configuration
- `set interfaces ehternet eth0 address 172.16.3.254/24`
- De même avec les autres interfaces (en précisant `eth1` et `eth2` ainsi que les bonnes adresses)
- `commmit`
- `exit`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/1507ba4c-ac58-49a7-a91d-316f0c287773)


Pour que nos différents réseaux communiquent entre eux, il faut établir les règles de routage :
- `config`
- `set protocols static route 172.16.1.0/24 next-hop 172.16.2.253`
- De même pour les autres routes que vous voudriez rajouter
- `commmit`
- `exit`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/b0cb8f8a-aada-46f7-bb29-311d1e074e70)


## GPO télemétrie

Ci-Dessous un example de configuration de Télémétrie qui peuvent être mise en place, vous pouvez baser sur les recommandations de l'ANSI :
https://cyber.gouv.fr/publications/restreindre-la-collecte-de-donnees-sous-windows-10

### GPO_C_Telemetrie pour Ordinateur

- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Local Policies/Security Options`
    - accounts : Block Microsoft Accounts
        - Users can't add or log on with Microsoft accounts
- chemin : `Computer Configuration/Administrative Templates/Control Panel/Regional and Language Options`
    - Allow users to enable online speech recognition services : Disabled
- chemin : `Computer Configuration/Administrative Templates/Control Panel/Regional and Language Options/Handwritting personalization`
    - Turn off automatic learning : Disabled
- chemin : `Computer Configuration/Administrative Templates/System/Internet Communication Management/Internet Communication settings`
    - Turn Off access to the store : Enabled
    - Turn off handwriting personalization data sharing : Enabled
    - Turn Off handwriting recognition error reporting : Enabled
    - Turn off help and Support Center "Did you Know ?" content : Enabled
    - Turn off Windows Customer Experience Improvement Program : Enabled
    - Turn off Windows Error Reporting : Enabled
- chemin : `Computer Configuration/Administrative Templates/System/User Profiles`
    - Turn off the adversiting ID : Enabled
- chemin : `Computer Configuration/Administrative Templates/Windows Component/Data Collection and Preview Builds`
    - Allow Diagnostics Data : Disabled
    - Do not show feedback notifications : Enabled
    - Toggle user control over Insider builds : Disabled
- chemin : `Computer Configuration/Administrative Templates/Windows Component/location and Sensors`
    - turn off location : Enabled
- chemin : `Computer Configuration/Administrative Templates/Windows Component/Microsoft Defender Antivirus/MAPS`
    - Configure Local setting override for reporting to Microsoft MAPS : Disabled
    - join Microsoft MAPS : Enabled
        - Join Microsoft MAPS : Disabled
    - Send file samples when further analysis is required : Enabled
        - Send file samples when further analysis is required : Never send
- chemin : `Computer Configuration/Administrative Templates/Windows Component/OneDrive`
    - Prevent the usage of OneDrive for file storage : Enabled
- chemin : `Computer Configuration/Administrative Templates/Windows Component/Search`
    - Allow Cortana : Disabled
    - Allow Cortana above lock screen : Disabled
    - Allow indexing of encrypted files : Disabled
    - Do not allow web search : Enabled
    - Don't search the web or display web results in Search : Enabled
    - Set what information is shared in Search : Enabled
        - Type of Information is shared in search : Anonymous info
- chemin : `Computer Configuration/Administrative Templates/Windows Component/Store`
    - Disable all apps from Microsoft Store : Enabled
    - Only display the private store within the Microsoft Store : Enabled
    - Turn off the Store apllication : Enabled
- chemin : `Computer Configuration/Administrative Templates/Windows Component/Windows Error Reporting`
    - Automatically send memory dumps for OS generated error report : Disabled
    - Disable Windows Error Reporting : Enabled
    - Do not send additional data : Enabled
- chemin : `Computer Configuration/Preferences/Windows settings/Registry`
    - creer une clef de registre "DontReportInfectionInformation"
        - action : Replace
        - Hive : HKEY_LOCAL_MACHINE
        - Key path : SOFTWARE\Policies\Microsoft\MRT
        - Value name : DontReportInfectionInformation
        - Value data : 1
        - Stop processing items on this extension if an error occurs on this item : No
        - Remove this item when is no longer applied : Yes
- chemin : `Computer Configuration/Preferences/Control Panel Settings/Services`
    - creer un service du nom de "Diag Track"
        - Service Name : Diag Track
        - action : Stop service
        - startup type : No change
        - wait timeout if service is locked : 30 seconds
        - Log on service as : No change
        - First failure : Take no action
        - Second failure : Take no action
        - subsequent failures :Take no action
        - Reset fail count after 0 Days
        - Stop processing items on this extension if an error occurs on this item : No
        - Apply once and do not reapply

### GPO_U_Telemetrie pour Uitlisateur
- chemin : `User Configuration/Policies/Administrative Templates/Windows Component/Cloud Content`
    - Do not use diagnostic data for tailored experience : Enabled
