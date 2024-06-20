# Sommaire

1. Installation de iRedMail

2. Mise en place d'un serveur backup

3. Installation de Redmine
   
4. Installation de passbolt

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

## **3. Installation de RedMine**

- recuperer le container Redmine et pendant l'instalation il vous suffira juste de rentrer le mot de passe administarteur pour vous connecter plus tard

## Configuration Redmine

### lié l'annuaire LDAP a Redmine

- une fois connecter avec le compte admin dont vous avez definit le mot de passe lors de l'instalation allez dans l'onglet Administration -> Authentification LDAP

- cliquer sur `Nouveau mode d'authentification` remplissez comme cela et sauvegarder

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/35143d93-ec6e-4adb-9c23-2fb648cab6f2)


- ensuite cliquer sur tester pour verifier que vous etes bien connecter a votre annuaire LDAP

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9ef2bfe9-1464-4e6f-b8a1-ff587c924ed0)


## importer vos utilisateurs avec un CSV

- allez dans Administration -> Utilisateurs
- a coter du boutons Nouvel utilisateur il y a 3 petits points cliquer dessus et choisisez importer
- selectionner votre fichier csv

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b1dedb3e-4e2f-42c3-b709-5d13f50bc9b1)


- faite suivant et choisir les options par raport a votre fichier CSV

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/4eff5a80-a3db-4a13-a7f3-151207b10df8)


- faite suivant et remplisser les champs dont vous avez besoin

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c839ffc5-34f3-41de-baca-92b623322934)


- ensuite cliquer sur le bouton importer


# 4. Installation de Passbolt sur Debian 12 (Bookworm) CE

## Prérequis

Pour ce tutoriel, vous aurez besoin de :

- Un serveur minimal Debian 12.
- Un domaine ou un nom d'hôte pointant vers votre serveur, ou au moins être capable de joindre votre serveur via une adresse IP statique.
- Un serveur SMTP fonctionnel pour les notifications par email.
- Un service NTP fonctionnel pour éviter les problèmes d'authentification GPG.

Les recommandations pour le serveur sont :

- 2 cœurs
- 2 Go de RAM

Pages FAQ :

- [Configuration de NTP](https://www.ntp.org/)
- [Règles du pare-feu](https://www.debian.org/doc/manuals/securing-debian-howto/ch-sec-services.fr.html)

**Remarque :**
Il est important d'utiliser un serveur vierge sans autres services ou outils déjà installés dessus. Les scripts d'installation pourraient potentiellement endommager les données existantes sur votre serveur.

**Astuce :**
Si vous envisagez de provisionner manuellement des certificats SSL, il est conseillé de le faire avant de commencer !

## Configuration du dépôt de paquets

Pour faciliter les tâches d'installation et de mise à jour, Passbolt fournit un dépôt de paquets que vous devez configurer avant de télécharger et d'installer Passbolt CE.

### Étape 1. Téléchargez notre script d'installation des dépendances :

```bash
curl -LO https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh
```

### Étape 2. Téléchargez notre SHA512SUM pour le script d'installation :

```bash
curl -LO https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt
```

### Étape 3. Vérifiez que le script est valide et exécutez-le :

```bash
sha512sum -c passbolt-ce-SHA512SUM.txt && sudo bash ./passbolt-repo-setup.ce.sh || echo "Mauvais checksum. Abandon" && rm -f passbolt-repo-setup.ce.sh
```

## Installation du paquet officiel passbolt

```bash
sudo apt install passbolt-ce-server
```

## Configuration de MariaDB

Si aucune instruction contraire n'est donnée, le paquet Debian de passbolt installera MariaDB-server localement. Cette étape vous aidera à créer une base de données MariaDB vide pour que passbolt puisse l'utiliser.

### Dialogue de configuration de la base de données

Le processus de configuration vous demandera les identifiants de l'utilisateur administrateur de MariaDB pour créer une nouvelle base de données. Par défaut, dans la plupart des installations, le nom d'utilisateur administrateur serait `root` et le mot de passe serait vide.

### Créez un utilisateur MariaDB avec des permissions réduites

Ces valeurs seront également demandées plus tard dans l'outil de configuration web de passbolt, donc veuillez les garder à l'esprit.

![cmbd1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/b13be6dd-8fbd-4665-a7b3-83184bd90a1b)

![cmbd4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/96b9f882-56b4-4a9e-8eca-9f5456a9eb5d)

### Créez une base de données pour passbolt

Donnez un nom à la base de données.

![cmbd5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/8cff5d31-5c1c-4079-a852-0184392f577b)

## Configuration de Nginx pour servir HTTPS

En fonction de vos besoins, il existe deux options pour configurer Nginx et SSL en utilisant le paquet Debian :

- Automatique (Utilisation de Let's Encrypt)
- Manuel (Utilisation de certificats SSL fournis par l'utilisateur)

## Configuration de passbolt

Avant de pouvoir utiliser l'application, vous devez la configurer. Pointez votre navigateur vers le nom d'hôte ou l'IP où passbolt peut être atteint. Vous atteindrez une page de démarrage.

### 2.1. Vérification de l'état

La première page de l'assistant vous indiquera si votre environnement est prêt pour passbolt. Résolvez les problèmes s'il y en a et cliquez sur "Démarrer la configuration" lorsque vous êtes prêt.

<img width="640" alt="web-installer-ce-healthcheck" src="https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/62b2f933-f301-4d80-8671-e30eefb8a655">

### 2.2. Base de données

Cette étape consiste à indiquer à passbolt quelle base de données utiliser. Entrez le nom d'hôte, le numéro de port, le nom de la base de données, le nom d'utilisateur et le mot de passe.

![web-installer-ce-database](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/ecda1297-dcef-45ec-90bd-1830f1d92adc)

### 2.3. Clé GPG

Dans cette section, vous pouvez soit générer, soit importer une paire de clés GPG. Cette paire de clés sera utilisée par l'API passbolt pour s'authentifier lors du processus de connexion. Générez une clé si vous n'en avez pas.

```bash
gpg --batch --no-tty --gen-key <<EOF
    Key-Type: default
    Key-Length: 2048
    Subkey-Type: default
    Subkey-Length: 2048
    Name-Real: John Doe
    Name-Email: email@domain.tld
    Expire-Date: 0
    %no-protection
    %commit
EOF
```

Remplacez `Name-Real` et `Name-Email` par vos propres informations.

Pour afficher votre nouvelle clé :

```bash
gpg --armor --export-secret-keys email@domain.tld
```

![web-installer-ce-server-key-import](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/7cc97bf0-0e9a-4732-b05d-b86750ab3a4b)

### 2.4. Serveur Mail (SMTP)

À ce stade, l'assistant vous demandera de saisir les détails de votre serveur SMTP.

Vous pouvez également tester que votre configuration est correcte en utilisant la fonctionnalité d'email de test sur la droite de votre écran. Entrez l'adresse email à laquelle vous souhaitez que l'assistant envoie un email de test et cliquez sur "Envoyer l'email de test".

![web-installer-ce-email](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/77c8bff8-aba5-4272-a512-dfea0e8fe9b8)

### 2.5. Préférences

L'assistant vous demandera ensuite quelles préférences vous préférez pour votre instance de passbolt. Les valeurs par défaut recommandées sont déjà pré-remplies mais vous pouvez également les changer si vous savez ce que vous faites.

### 2.6. Création du premier utilisateur

Vous devez créer le premier compte administrateur. Cet utilisateur administrateur sera probablement vous, alors entrez vos informations et cliquez sur suivant.

![web-installer-ce-first-user](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/162970946/8d116d25-0da8-4032-b78b-4d29c8811d43)

### 2.7. Installation

C'est tout. L'assistant a maintenant suffisamment d'informations pour procéder à la configuration de passbolt. Asseyez-vous et détendez-vous pendant quelques secondes pendant que le processus de configuration est en cours.

Votre compte utilisateur est maintenant créé. Vous verrez une page de redirection pendant quelques secondes puis vous serez redirigé vers le processus de configuration utilisateur pour que vous puissiez configurer votre compte utilisateur.

### 2.8. Processus de configuration HTTPS

Passbolt Pro VM utilise le paquet Debian passbolt. En fonction de vos besoins, il existe deux options pour configurer Nginx et SSL en utilisant le paquet Debian :

- Automatique (Utilisation de Let's Encrypt)
- Manuel (Utilisation de certificats SSL fournis par l'utilisateur)

## Configuration de votre compte administrateur

### 3.1. Téléchargez le plugin

Avant de continuer, passbolt vous demandera de télécharger son plugin. Si vous l'avez déjà installé, vous pouvez passer à l'étape suivante.

### 3.2. Créez une nouvelle clé

Passbolt vous demandera de créer ou d'importer une clé qui sera utilisée ultérieurement pour vous identifier et chiffrer vos mots de passe. Votre clé doit être protégée par un mot de passe. Choisissez-le judicieusement, il sera le gardien de tous vos autres mots de passe.

### 3.3. Téléchargez votre kit de récupération

Cette étape est essentielle. Votre clé est le seul moyen d'accéder à votre compte et à vos mots de passe. Si vous perdez cette clé (en cassant ou en perdant votre ordinateur et en n'ayant pas de sauvegarde, par exemple), vos données chiffrées seront perdues même si vous vous souvenez de votre mot de passe.

### 3.4. Définissez votre jeton de sécurité

Choisir une couleur et un jeton de trois caractères est un mécanisme de sécurité secondaire qui vous aide à atténuer les attaques de phishing. Chaque fois que vous effectuez une opération sensible sur passbolt, vous devriez voir ce jeton.

### 3.5. C'est fini !

Votre compte administrateur est configuré. 





