Sommaire :

1. [Installation client OpenVPN](#1-installation-Client-openvpn)
2. [Installation RADIUS via pfSense](#2-installation-radius-via-pfsense)
3. [Installation de BloodHound](#3-installation-de-bloodhound)

 
 
 # 1. Installation Client OpenVPN

## Pré-requis

- Avoir le certificat d’autorité (CA) du serveur
- Avoir le certificat et la clé du serveur
- Avoir la clé TLS du serveur

## Configuration du Client SSL/TLS

### Importer le CA et le Certificat

Sur le client, importer le certificat CA ainsi que le certificat et la clé du client pour ce site. Il s'agit du même certificat CA et du certificat client créés précédemment.

### Importer le CA

1. Aller à **System > Certificates**, onglet **Authorities**
2. Cliquer sur **Add** pour créer une nouvelle autorité de certification
3. Entrer les paramètres suivants :
   - Nom descriptif : `openvpnekogreen`
   - Méthode : `Import an existing Certificate Authority`
   - Données du certificat : Ouvrir le fichier du certificat CA dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
4. Cliquer sur **Save**

### Importer le certificat du client

1. Aller à **System > Certificates**, onglet **Certificates**
2. Cliquer sur **Add** pour créer un nouveau certificat
3. Entrer les paramètres suivants :
   - Méthode : `Import an existing Certificate`
   - Nom descriptif : `clientB VPN Certificate`
   - Type de certificat : `X.509 (PEM)`
   - Données du certificat : Ouvrir le fichier du certificat client dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
   - Données de la clé privée : Ouvrir la clé privée du certificat client dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
4. Cliquer sur **Save**

Répétez ces étapes sur chaque pare-feu client.

## Configurer l'Instance Client OpenVPN

Après avoir importé les certificats, créer le client OpenVPN :

1. Aller à **VPN > OpenVPN**, onglet **Clients**
2. Cliquer sur **Add** pour créer un nouveau client
3. Remplir les champs comme suit, en laissant tout le reste par défaut :
   - Description : Texte pour décrire la connexion (par ex. `OPENVPNekogrenn`)
   - Mode Serveur : `Peer to Peer (SSL/TLS)
   - Mode Appareil : `tun`
   - Protocole : `UDP on IPv4 only`
   - Interface : `WAN`
   - Hôte ou adresse du serveur : L'adresse IP publique ou le nom d'hôte du serveur OpenVPN (par ex. `198.168.0.254`)
   - Port du serveur : `1194`
   - Utiliser une clé TLS : Coché
   - Générer automatiquement une clé TLS : Non coché
   - Clé TLS : Coller la clé TLS copiée depuis l'instance serveur
   - Autorité de certification du pair : Le CA importé au début de ce processus
   - Certificat client : Le certificat client importé au début de ce processus
4. Cliquer sur **Save**

**Note :** Avec les configurations SSL/TLS serveur/client comme cet exemple, les routes et autres options de configuration sont automatiquement poussées depuis le serveur et ne sont donc pas présentes dans la configuration du client.

## Règles de Pare-feu

Une règle de type "Autoriser tout".

### Exemple de règle pour autoriser tout le trafic :

1. Aller à **Firewall > Rules**, onglet **OpenVPN**
2. Cliquer sur **Add** pour créer une nouvelle règle en haut de la liste
3. Configurer les options comme suit :
   - Protocole : `any`
   - Source : `any`
   - Description : `Allow all on OpenVPN`
4. Cliquer sur **Save**
5. Cliquer sur **Apply Changes**

# 2. Installation de RADIUS via pfSense

Ce guide vous guidera à travers l'installation et la configuration de RADIUS sur pfSense pour l'utiliser avec un portail captif.

## Prérequis

- Une installation fonctionnelle de pfSense
- Accès administrateur à l'interface web de pfSense

## Étape 1: Installation du Serveur RADIUS sur pfSense

1. Connectez-vous à l'interface web de pfSense.
2. Allez dans `System` > `Package Manager`.
3. Dans l'onglet `Available Packages`, cherchez `freeradius3`.
4. Cliquez sur `Install` à côté du package `freeradius3` et confirmez l'installation.

## Étape 2: Configuration du Serveur RADIUS

1. Après l'installation, allez dans `Services` > `FreeRADIUS`.
2. Sous l'onglet `Interfaces`, cliquez sur `Add` pour ajouter une interface.
   - `Interface`: Sélectionnez `LAN`.
   - `Port`: Laissez par défaut (1812 pour RADIUS Authentication et 1813 pour Accounting).
   - Cliquez sur `Save`.

3. Sous l'onglet `Clients`, cliquez sur `Add` pour ajouter un client.
   - `IP Address`: Entrez l'adresse IP du client (par exemple, l'IP du routeur ou du point d'accès).
   - `Shared Secret`: Entrez un secret partagé sécurisé.
   - Cliquez sur `Save`.

4. Sous l'onglet `Users`, cliquez sur `Add` pour ajouter un utilisateur.
   - `Username`: Entrez un nom d'utilisateur.
   - `Password`: Entrez un mot de passe.
   - Cliquez sur `Save`.

5. Sous l'onglet `NAS/Clients`, cliquez sur `Add` pour ajouter un NAS client.
   - `Shortname`: Entrez un nom abrégé pour le NAS.
   - `Type`: Sélectionnez `other`.
   - `IP Address`: Entrez l'adresse IP du NAS.
   - `Shared Secret`: Entrez le même secret partagé que précédemment.
   - Cliquez sur `Save`.

6. Sous l'onglet `Settings`, assurez-vous que les services `FreeRADIUS` sont activés.
   - Cliquez sur `Save`.

## Étape 3: Configuration du Portail Captif

1. Allez dans `Services` > `Captive Portal`.
2. Cliquez sur `Add` pour créer une nouvelle zone de portail captif.
   - `Interface`: Sélectionnez l'interface sur laquelle vous voulez activer le portail captif (par exemple, LAN).
   - `Maximum concurrent connections`: Définissez le nombre maximum de connexions simultanées.
   - Activez l'option `Enable Captive Portal`.
   - Cliquez sur `Save and Continue`.

3. Sous l'onglet `Authentication`, sélectionnez `Use RADIUS Authentication`.
   - `Primary RADIUS Server`: Entrez l'adresse IP du serveur RADIUS (généralement l'IP de pfSense).
   - `Primary RADIUS Server Port`: Laissez par défaut (1812).
   - `Primary RADIUS Server Shared Secret`: Entrez le secret partagé que vous avez défini précédemment.
   - Cliquez sur `Save`.

## Étape 4: Vérification de la Configuration

1. Connectez un appareil au réseau associé à l'interface où le portail captif est activé.
2. Ouvrez un navigateur web et essayez d'accéder à un site web. Vous devriez être redirigé vers la page de connexion du portail captif.
3. Entrez les informations d'identification de l'utilisateur RADIUS que vous avez configuré.
4. Si l'authentification réussit, vous serez redirigé vers le site web demandé.

# Instalation de bloodhound

- l'instalation ce ferra sur une machine kali Linux
- Pour installer BloodHound faite cette commande :

``sudo apt update && sudo apt install -y bloodhound``

- en installant bloodhound la dependance neo4j sera aussi installé
- executer la commande ``sudo neo4j console``
- rendez vous a l'adresse ``http://localhost:7474`` et connecter avec l'identifiants et mot de passe par defaut

- Username : neo4j
- password : neo4j

![image](https://github.com/user-attachments/assets/8775ac54-9e78-4052-b490-801115a3cdfb)


- apres vous etes connecté changer votre mot de passe
- vous pouvez ensuite vous connecter a bloodhound

![image](https://github.com/user-attachments/assets/00e49e3f-5695-4c81-9d4d-69a342e5e308)

## importer donnée de l'AD dans bloodhound

- sur le serveur Active directory installer ShareHound via ce lien ``https://github.com/BloodHoundAD/SharpHound/releases``
- lancer Sharehound via l'invité de commande
- un dossier Zip contenant des fichiers JSON sera creer
- transferer ce fichier sur la machine Kali Linux
- faire un glisser deposer des fichiers JSON sur BloodHound
