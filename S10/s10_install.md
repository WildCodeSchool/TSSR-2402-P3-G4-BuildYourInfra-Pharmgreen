# Active directory CORE

### Pré-requis
- **Nom de l’hôte serveur GUI**: SRV-GLOBAL-LYON
- **Adresse IP de réseau** : 192.168.9.0/24
- **Adresse de passerelle** : 192.168.9.254
- **Adresse IP DNS** : 192.168.9.254
- **Compte**: Administrator
- **Mot de passe**: Azerty1*
- **IPv4**: 192.168.9.2
- **DNS**: pharmgreen.org
- **Version**: Windows Server 2022
- Pare-feu : désactivé

Pour l'installation des rôle Active Directory, DNS et DHCP, se référer à la documentation **s09_install.md** et adapter les adresses IP selon les **Pré-requis**.  
De même pour le poste Client.

### Informations du Serveur

- **Nom de l’hôte serveur**: AD-DS
- **Compte**: Administrator
- **Mot de passe**: Azerty1*
- **IPv4**: 192.168.9.3
- **Masque**: 255.255.255.0
- **Passerelle par défaut**: 192.168.9.254
- **DNS**: 192.168.9.2
- **Version**: Windows Server Core 2022
- Mises à jour de sécurité : appliquées
- Pare-feu : désactivé 

#### 1. Installation de AD DS (Active Directory Domain Services)

- Connectez vous sur le serveur AD-DS avec le compte Administrator.
- Vous allez arriver sur un écran comme celui-ci
  
![VirtualBox_core_14_05_2024_14_47_52](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/e80dff79-29d1-4bda-97fb-be2233a692fe)

- Entrez "15" pour passer en lignes de commandes (PowerShell)
- Exécutez les commandes suivantes : 
	- `Add-WindowsFeature -Name "RSAT-AD-Tools" -IncludeManagementTools -IncludeAllSubFeature`
	- `Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature`
	- `Add-WindowsFeature -Name "DNS" -IncludeManagementTools -IncludeAllSubFeature`
 
Vous verrez une barre de progression comme celle-ci pour les 3 commandes :

![VirtualBox_core_14_05_2024_14_49_59](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/9d616d04-7b80-4abe-b3cb-847d6169d6f1)

- Fermez la fenêtre afin de revenir à l'écran précédent avec toutes les propositions.

#### 2. Définition d'une adresse IP statique

Nous allons d'abord définir l'adresse IP :
- Sur l'écran de sélection, entrez "8" pour aller dans les paramètres réseau
- Sélectionnez la carte réseau (ici il n'y en a qu'une, donc entrez "1")
- Entrez de nouveau "1" pour indiquer la nouvelle configuration réseau
- Entrez "s" pour définir une adresse IP statique
- Indiquez l'adresse souhaitée (ici 192.168.9.3)
- Faites "Entrée" si vous souhaitez que le masque soit de base en 255.255.255.0
- Entrez une passerelle par défaut (ici ce sera 192.168.9.254)
- Appuyez sur "Entrée"

Et maintenant le DNS :
- Appuyez sur "8" pour retourner dans les paramètres réseau 
- Sur "1" pour choisir l'interface
- Puis sur "2" pour configurer le DNS
- Entrez l'adresse souhaitée (ici ce sera 192.168.9.2 qui est l'adresse du serveur AD principal)
- Faites "Entrée" si vous ne souhaitez pas de DNS secondaire
- De nouveau "Entrée"

Vous aurez à la fin quelque chose qui ressemble à ceci 

![Pasted image 20240514150528](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/46a278b4-8224-4a6e-8f98-c2f11cb38ad5)


  # configuration Serveur debian et SSH 

## Ajout du serveur Debian à l' Active Directory

### Configuration reseau

Modifiez le fichier **/etc/network/interfaces** comme suit :


![Capture](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a8ac382b-05cb-475e-8292-adbb51969dcb)


### Paquet necessaire pour ajouter le serveur à l'active directory

Executez cette commande : `apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd`

### Modification fichier resolv.conf

Modifiez le fichier /etc/resolv.conf comme cela :

![image-1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9ee74866-6e02-4e7f-9dd1-571e731d1ff6)

### Ajout de la machine au serveur AD

Executez la commande `realm join --user=administrator pharmgreen.org`

# Installation et configuration du serveur ssh

## Action à effectuer sur le serveur

Pour installer le protocole SSH sur le serveur, effectuez cette commande `apt install openssh-server`

Modifiez le fichier /etc/ssh/sshd_config comme cela :

![capture3ssh](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/6df03c53-2575-4d6d-b626-5c9887b05ce4)


![CAPTURE5SSH](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/bde0c267-4836-4366-a189-23321c6849c0)

Après avoir modifier le fichier, pensez à executer la commande `systemctl restart sshd`

Executez ces commandes pour créer le dossier qui va acceuillir la clé publique de notre client:
- `mkdir /home/wilder/.ssh`
- `chmod 700 /home/wilder/.ssh`
- `touch /home/wilder/.ssh/authorized_keys`
- `chmod 600 /home/wilder/.ssh/authorized_keys`

# Configuration client ssh

- Génerez une clé publique en exécutant cette commande en PowerShell `ssh-keygen -t rsa 4096`

- Copiez la clé sur le serveur en exécutant cette commande `cat ~/.ssh/id_rsa.pub | ssh root@192.168.9.4 "cat >> ~/.ssh/authorized_keys"`

# Dernière configuration

De retour sur le serveur, remodifiez le fichier /etc/ssh/sshd_config

![image-7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/5c9d0416-6b82-4c8c-a541-40d970c99395)

Côté client; pour vous connecter, exécutez cette commande `ssh wilder@192.168.9.4 -p 6666`


