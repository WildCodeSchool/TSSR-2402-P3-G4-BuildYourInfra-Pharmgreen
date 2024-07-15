
# Guide d'Installation de pfSense et VyOS sur VirtualBox

## Table des Matières

1. [Prérequis](#prérequis)
2. [Installation de pfSense](#installation-de-pfsense)
   - [Étapes d'Installation](#étapes-dinstallation)
     - [Télécharger pfSense](#télécharger-pfsense)
     - [Créer une Machine Virtuelle sur VirtualBox](#créer-une-machine-virtuelle-sur-virtualbox)
     - [Installer pfSense](#installer-pfsense)
     - [Accéder à l'Interface Web](#accéder-à-linterface-web)
3. [Installation de VyOS](#installation-de-vyos)
   - [Étapes d'Installation](#étapes-dinstallation-1)
     - [Télécharger VyOS](#télécharger-vyos)
     - [Créer une Machine Virtuelle sur VirtualBox](#créer-une-machine-virtuelle-sur-virtualbox-1)
     - [Installer VyOS](#installer-vyos)
     - [Accéder à l'Interface CLI](#accéder-à-linterface-cli)

## Prérequis

- Un ordinateur avec VirtualBox installé.
- Les images ISO de pfSense et VyOS :
    - [pfSense](https://www.pfsense.org/download/)
    - [VyOS](https://vyos.io/download)

## Installation de pfSense

### Étapes d'Installation

#### Télécharger pfSense

1. Allez sur [pfSense.org](https://www.pfsense.org/).
2. Téléchargez l'image ISO (architecture AMD64).

#### Créer une Machine Virtuelle sur VirtualBox

1. **Ouvrir VirtualBox :**
    - Lancez VirtualBox et cliquez sur **New** pour créer une nouvelle machine virtuelle.

2. **Configurer la Machine Virtuelle :**
    - Nom : pfSense
    - Type : BSD
    - Version : FreeBSD (64-bit)
    - Mémoire : 1 Go de RAM
    - Disque dur : Créez un nouveau disque dur virtuel (VDI) de 10 Go, avec allocation dynamique.

3. **Ajouter l'ISO de pfSense :**
    - Accédez aux paramètres de la VM.
    - Cliquez sur **Storage**, sélectionnez **Empty** sous **Controller: IDE**.
    - Cliquez sur l'icône de disque et sélectionnez **Choose a disk file**, puis choisissez l'image ISO de pfSense.

4. **Démarrer la VM :**
    - Cliquez sur **Start** pour lancer la VM avec l'ISO de pfSense.

#### Installer pfSense

1. **Démarrer l'Installation :**
    - Lorsque le menu de démarrage de pfSense apparaît, sélectionnez l'option par défaut pour commencer l'installation.

2. **Suivre les Instructions :**
    - Choisissez les options par défaut pour les paramètres.
    - Sélectionnez **Install** pour lancer l'installation.
    - Choisissez **Auto (UFS)** pour le schéma de partitionnement.

3. **Finaliser l'Installation :**
    - Une fois l'installation terminée, retirez l'ISO de pfSense.
    - Redémarrez la machine virtuelle.

#### Accéder à l'Interface Web

1. **Connexion à l'Interface Web :**
    - Ouvrez un navigateur web et allez à l'adresse IP LAN par défaut de pfSense : [http://192.168.1.1](http://192.168.1.1).
    - Utilisez les informations d'identification par défaut : utilisateur **admin**, mot de passe **pfsense**.

## Installation de VyOS

### Étapes d'Installation

#### Télécharger VyOS

1. Allez sur [vyos.io/download](https://vyos.io/download).
2. Téléchargez l'image ISO (architecture AMD64).

#### Créer une Machine Virtuelle sur VirtualBox

1. **Ouvrir VirtualBox :**
    - Lancez VirtualBox et cliquez sur **New** pour créer une nouvelle machine virtuelle.

2. **Configurer la Machine Virtuelle :**
    - Nom : VyOS
    - Type : Linux
    - Version : Debian (64-bit)
    - Mémoire : 1 Go de RAM
    - Disque dur : Créez un nouveau disque dur virtuel (VDI) de 10 Go, avec allocation dynamique.

3. **Ajouter l'ISO de VyOS :**
    - Accédez aux paramètres de la VM.
    - Cliquez sur **Storage**, sélectionnez **Empty** sous **Controller: IDE**.
    - Cliquez sur l'icône de disque et sélectionnez **Choose a disk file**, puis choisissez l'image ISO de VyOS.

4. **Démarrer la VM :**
    - Cliquez sur **Start** pour lancer la VM avec l'ISO de VyOS.

#### Installer VyOS

1. **Démarrer l'Installation :**
    - Lorsque le menu de démarrage de VyOS apparaît, sélectionnez l'option par défaut pour commencer l'installation.

2. **Suivre les Instructions :**
    - À l'invite de commande, tapez `install image` et appuyez sur **Entrée**.
    - Suivez les instructions à l'écran :
        - Choisissez le disque d'installation (généralement sda).
        - Acceptez la taille par défaut de la partition.
        - Créez et confirmez un mot de passe pour l'utilisateur **vyos**.
        - Indiquez un nom pour l'image d'installation (par exemple, 1.3-rolling).

3. **Finaliser l'Installation :**
    - Une fois l'installation terminée, tapez `poweroff` pour éteindre la VM.
    - Retirez l'ISO de VyOS des paramètres de la VM.
    - Démarrez la VM.

#### Accéder à l'Interface CLI

1. **Connexion à l'Interface CLI :**
    - Connectez-vous avec l'utilisateur **vyos** et le mot de passe que vous avez créé.

2. **Configuration de Base :**
    - Entrez le mode de configuration en tapant `configure`.
    - Vous pouvez maintenant configurer VyOS selon vos besoins.
