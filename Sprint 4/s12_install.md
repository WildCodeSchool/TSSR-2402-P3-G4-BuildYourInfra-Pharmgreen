
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



# Changement de l'infrastructure réseau :
Se référer au sprint 4 du readme pour comprendre les changements effectués.  
Nous avons changé les adresses réseaux de tous les équipements déjà mis en place, pour respecter la nouvelle infrastruture virtuelle utilisée.  
Plan adressage de l'infrastruture virtuel ainsi que les tables de routage utilisé : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Plan_adressage.xlsx

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
