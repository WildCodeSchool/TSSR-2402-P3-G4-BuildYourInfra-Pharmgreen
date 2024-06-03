# Installation de pfSense sur VirtualBox

Ce guide vous aidera à installer pfSense sur une machine virtuelle VirtualBox.

## Prérequis

- Un ordinateur avec VirtualBox installé.
- Une image ISO de pfSense [téléchargeable ici](https://www.pfsense.org/download/).

## Étapes d'Installation

### Télécharger pfSense

1. Allez sur [pfSense.org](https://www.pfsense.org/download/).
2. Téléchargez l'image ISO (architecture AMD64).

### Créer une Machine Virtuelle sur VirtualBox

1. **Ouvrir VirtualBox** :
   - Lancez VirtualBox et cliquez sur "New" pour créer une nouvelle machine virtuelle.

2. **Configurer la Machine Virtuelle** :
   - Nom : `pfSense`.
   - Type : `BSD`.
   - Version : `FreeBSD (64-bit)`.
   - Mémoire : Allouez 1 Go de RAM.
   - Disque dur : Créez un nouveau disque dur virtuel (VDI) de 10 Go, avec allocation dynamique.

3. **Ajouter l'ISO de pfSense** :
   - Accédez aux paramètres de la VM.
   - Cliquez sur "Storage", sélectionnez "Empty" sous "Controller: IDE".
   - Cliquez sur l'icône de disque et sélectionnez "Choose a disk file", puis choisissez l'image ISO de pfSense.

4. **Démarrer la VM** :
   - Cliquez sur "Start" pour lancer la VM avec l'ISO de pfSense.

### Installer pfSense

1. **Démarrer l'Installation** :
   - Lorsque le menu de démarrage de pfSense apparaît, sélectionnez l'option par défaut pour commencer l'installation.

2. **Suivre les Instructions** :
   - Choisissez les options par défaut pour les paramètres.
   - Sélectionnez "Install" pour lancer l'installation.
   - Choisissez "Auto (UFS)" pour le schéma de partitionnement.

3. **Finaliser l'Installation** :
   - Une fois l'installation terminée, retirez l'ISO de pfSense.
   - Redémarrez la machine virtuelle.

### Accéder à l'Interface Web

1. **Connexion à l'Interface Web** :
   - Ouvrez un navigateur web et allez à l'adresse IP LAN par défaut de pfSense : `http://192.168.1.1`.
   - Utilisez les informations d'identification par défaut : utilisateur `admin`, mot de passe `pfsense`.

## Conclusion

pfSense est maintenant installé sur VirtualBox. Vous pouvez commencer la configuration initiale via l'interface web.
