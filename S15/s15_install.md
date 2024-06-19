# Sommaire

1. Installation de iRedMail

2. Mise en place d'un serveur backup

## **1. Installation de iRedMail**

### Installation

Tout d'abord :

- `wget https://github.com/iredmail/iRedMail/archive/refs/tags/*.tar.gz`
- `tar -xzf *.tar.gz`
- Se place dans le dossier avec `cd 1.6.8`
- `bash iRedMail.sh`

Ensuite: 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/5fc45dea-e470-4ed3-8ec9-d515d7b3be14)

Laisser le chemin par défaut :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/fc2700f8-bd10-4cc7-8547-df5ff48da4ae)

Laisser le choix par défaut également :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/a335f1d3-a276-4f9e-b136-1d086e2c3dd4)

Sélectionner OpenLDAP : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/5bcab175-2fb6-4c80-ac78-ba85708a14bb)

Renseigner votre domaine :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/af39378c-c2ec-4915-b2c8-4af1c5ed7ef0)

Un mot de passe pour la base de donnée MySQL :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/9a4fe8c3-b005-4d27-b338-50772a4e6398)

Choisir un nom de domaine pour le mail :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/23f140d0-6e6e-4ca0-97a6-380cd033f48b)

Un mot de passe pour l'admin du domaine :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ae853cb8-1349-4deb-bd4a-1cdf8dd2e75f)

Laisser les choix par défaut :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/02ec40bf-a2a6-443b-a65a-62cbdc7279ba)

Sélectionner `y` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/6d567e8f-6fcf-4556-9872-4657c2e17477)

A la fin vous aurez un message qui ressemblera à ceci, répondez `y` aux 2 questions :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/21c2b48e-5277-4e13-b487-222f0575edb8)

Redémarrez.

### Création d'utilisateur

Connectez-vous via le web avec le compte admin créé précédemment :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/e6b3f5b4-fe56-4412-bc5c-b0265658d6e8)

Allez sur l'adresse `172.16.3.15/iredadmin` : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/e526f800-3e65-4e5b-9ea5-5bfa39b6f674)

Puis `Add` et `User` et renseignez les champs nécessaires :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/e296c11e-d34c-4123-bc98-7e275f221e9d)

Vous verrez bien les utilisateurs créés si vous retournez sur la messagerie :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f6074c8f-656f-4c1c-a6ee-8b29607a641e)

## **2. Mise en place d'un serveur backup**

#### Création du dossier partagé

Pour mettre en place une backup de notre serveur principal sur un autre serveur, nous avons suivi la méthode suivante :

- Sur le serveur backup, installer Samba : `apt install samba` et ensuite faire un `nano /etc/samba/smb.conf` et y mettre les infos suivantes à la fin du fichier :
```bash
[backups]
path = /mnt/backups
available = yes
valid users = Administrator
read only = no
browsable = yes
public = yes
writable = yes
```

- Ensuite, créer le répertoire de sauvegarde et définir les permissions :
```bash
sudo mkdir -p /mnt/backups
sudo chown nobody:nogroup /mnt/backups
sudo chmod 777 /mnt/backups
```

- Ensuite `useradd Administrator` puis `smbpasswd -a Administrator` et enfin `sudo systemctl restart smbd`.

Nous allons maintenant passer sur le serveur Windows :

#### Monter le partage en tant que lecteur réseau :

- Ouvrez l'Explorateur de fichiers sur Windows Server
- Cliquez avec le bouton droit sur Ce PC et sélectionnez `Map network drive`
- Choisissez une lettre de lecteur (par exemple, Z:)
- Entrez le chemin du réseau sous la forme `\\172.16.3.13\backups`
- Cochez la case `Reconnect at sign-in`
- Cliquez sur `Finish` et entrez les informations d'identification Samba lorsque demandé (l'utilisateur créé précédemment).

#### Création de la sauvegarde

- Aller dans Windows Server Backup
- Cliquer sur `Backup Schedule`
- Sélectionner `Full server`
- `Remote shared folder`
- Entrer `\\172.16.3.13\backups`
- Cliquer sur `Backup`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ab99327c-105d-4b4a-9481-2afe8c00341d)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/06a0ec24-3117-483b-9a63-b4a39ebc0669)

Le serveur est backup tous les jours à 21h, la sauvegarde précédente est écrasée à chaque fois.
