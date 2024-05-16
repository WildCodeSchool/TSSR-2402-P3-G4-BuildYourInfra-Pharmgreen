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
- Faites "Entrée" si vous ne souhaites pas de DNS secondaire
- De nouveau "Entrée"

Vous aurez à la fin quelque chose qui ressemble à ceci 

![Pasted image 20240514150528](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/46a278b4-8224-4a6e-8f98-c2f11cb38ad5)

#### 3. Ajout du Server Core au Domaine

- Sur l'écran principal, faites "1"
- Entrez ensuite "D"
- Indiquez votre domaine (ici pharmgreen.org)
- Indiquez ensuite l'utilisateur autorisé (ici pharmgreen.org\administrator)
- Ainsi que le mot de passe (Azerty1*)

Vous aurez alors un message de bienvenue dans le domaine sélectionné et quand vous retournez au menu principal :

![Pasted image 20240514151103](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2ffd38f0-506c-45e3-8b27-62fdcb541684)

Sur le Windows Server (en GUI), ouvrez le Serveur Manager et selectionner "Manage" puis "Add Servers" :

![AD-DS1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/fd69ae44-3826-45d9-aea5-8b45ea717e74)  

Ensuite, appuyez sur "Find Now" et double cliquez sur "AD-DS" (le nom du Serveur Core), il devrait apparaitre dans le fenêtre de droite et validez en cliquant sur le bouton "OK".  

![AD-DS1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/992776d8-5ccf-42c9-9c51-18f1a64f4346)

Sur le Windows Server (en GUI), vous aurez une notification en haut comme ceci :

![1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f5720148-2f75-457c-a95e-1bcc64d2c5bf)

Cliquez dessus et entrez les informations suivantes :
- Laissez coché "Add a domain controller to an existing domain" (ici pharmgreen.org)
- Rentrez les informations de connexion du domaine (Administrator et Azerty1*)

![2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/0da59abf-96a5-457a-8637-ca9407114ca7)

- Faites "Next" jusqu'à arriver ici et rentrez le mot de passe
  
![3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2e39ce4e-a5d1-4f91-a8ed-01cafab1e843)

- Refaites "Next" jusqu'à arriver à cet écran et sélectionnez bien le serveur principal pour la réplication

 ![4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2b005c4c-c1bc-4f2d-b3df-b2394efd159c)

- Faites "Next" jusqu'à la fin et cliquez sur "Install".

  # Documentation Administrateur

## Ajout du serveur Debian a l' Active Directory

### Configuration reseau

Modifier le fichier **/etc/network/interfaces** comme suis :


![Capture](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a8ac382b-05cb-475e-8292-adbb51969dcb)


### Paquet necessaire pour ajouter le serveur à l'active directory

Executer cette commande : **apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd**

### Modification fichier resolv.conf

Modifier le fichier /etc/resolv.conf comme cela :

![image-1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9ee74866-6e02-4e7f-9dd1-571e731d1ff6)

### Ajout de la machine au serveur AD

Executer la commaande **realm join --user=administrator pharmgreen.org**


# Installation et configuration du serveur ssh

## Action a effectuer sur le serveur

Pour installer le protocole SSH sur le serveur effectuer cette commande **apt install openssh-server**

Modifier le fichier /etc/ssh/sshd_config comme cela :

![capture3ssh](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/6df03c53-2575-4d6d-b626-5c9887b05ce4)


![CAPTURE5SSH](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/bde0c267-4836-4366-a189-23321c6849c0)

Après avoir modifier le fichier penser a executer la commande **systemctl restart sshd**

Executer ces commandes pour creer le dossier qui va acceuillir la clef publique de notre client:
- **mkdir /home/wilder/.ssh**
- **chmod 700 /home/wilder/.ssh**
- **touch /home/wilder/.ssh/authorized_keys**
- **chmod 600 /home/wilder/.ssh/authorized_keys**

# Configuration client ssh

- Generer une clef publique  en executant cette commande en powershell **ssh-keygen -t rsa 4096**

- Copier la clef sur le serveur en executant cette commande **cat ~/.ssh/id_rsa.pub | ssh root@192.168.9.4 "cat >> ~/.ssh/authorized_keys"**

# Derniere configuration

De retour sur le serveur remodifier le fichier /etc/ssh/sshd_config

![image-7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/5c9d0416-6b82-4c8c-a541-40d970c99395)

Coté client pour vous connecter executer cette commande **ssh wilder@192.168.9.4 -p 6666**


