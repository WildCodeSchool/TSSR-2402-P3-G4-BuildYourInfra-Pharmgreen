Sommaire :

1. [Installation et configuration de FreePBX](#1-installation-et-configuration-de-freepbx)
2. [Installation de 3CX](#2-installation-de-3cx)
3. [Installation de WordPress](#3-installation-de-wordpress)

# **1. Installation et configuration de FreePBX**

## **1. Installation**

Il faut d'abord vous fournir l'ISO de FreePBX à [l'adresse suivante](https://www.freepbx.org/downloads/) et ensuite monter une VM de la même manière que d'habitude. 

Apres le démarrage vous arriverez ici :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f02b9941-08af-4da1-8dc9-44bcdb3a90bb)

Puis sélectionner `Graphical Installation - Output to VGA` : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ae4a6ba9-9603-4077-a642-c829df6a709a)

Enfin choisir `FreePBX Standard` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/8fea1973-37d2-4e44-9f67-86dc444cd531)

Pendant l'installation, il faut configurer le mot de passe root, cliquez sur `ROOT PASSWORD` et entrez le nouveau mot de passe :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/46cbe08c-229b-40a5-a1d4-2ec84b94b701)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/1f5b0613-e4d7-4a88-99d6-430f399da509)

Cliquez sur `reboot` une fois l'installation terminée : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/6726e1fc-226d-4dc2-a320-7ebc76ebd157)

## **2. Configuration**

La langue du clavier est en anglais par défaut, pour la passer en français effectuez les commandes suivantes :
```bash
localectl set-locale LANG=fr_FR.utf8
localectl set-keymap fr
localectl set-x11-keymap fr
```

Passez maintenant sur le navigateur web et rentrez l'adresse de votre serveur (ici, `172.16.3.19`) pour continuer la configuration.

Cliquez sur `FreePBX Administration` et reconnectez-vous en root :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/db0e785f-77ea-4b3f-9cf2-fa89dead84a6)

Cliquez sur `Skip` pour sauter l'activation du serveur et toutes les offres commerciales qui s'affichent.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f01ab945-c8b4-4bda-ae85-81d7f6b575c3)

Laissez tout par défaut et cliquez sur `Submit`.

A la fenêtre d'activation du firewall, clique sur `Abort` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d730f80e-0a81-4ec6-a509-262fbd9db7cb)

A la fenêtre de l'essais de SIP Station clique sur `Not Now` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/9aac0f89-a512-40bb-a026-9bc32fe82363)

Vous arriverez sur ceci : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/94e52472-e927-47a3-a482-3775caa40a15)

Cliquez sur `Apply Config`.

Allez dans `Menu` puis `System Admin`, un message indique que le système n'est pas activé. Clique sur `Activation` puis `Activate` et de nouveau `Activate` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/eda80416-ddd6-4b2e-80d8-9151e38451bf)

Entrez une adresse email et attend quelques instant.

Dans la fenêtre qui s'affiche, renseignez les différentes informations, et notamment :

- Pour `Which best describes you` mettez `I use your products and services with my Business(s) and do not want to resell it`,
- Pour `Do you agree to receive product and marketing emails from Sangoma ?`, cochez `No`.

Cliquez sur `Create`.

Dans la fenêtre d'activation, cliquez sur `Activate` et attendez que l'activation se fasse :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/4153bcb1-a13d-47ac-8dad-b4b187d3c278)

Dans toutes les fenêtres qui s'affichent, cliquez sur `Skip`.

La fenêtre de mise-à-jour des modules va s'afficher automatiquement, cliquez sur `Update Now` et attendez que les mises à jour se fassent.

Une fois que tout est terminé, cliquez sur `Apply config`.

Sur le serveur en CLI, faites un `yum update` et répondez `y` quand on vous le demandera.

## **3. Lien avec l'Active Directory et création des utilisateurs**

Si vous voulez lier FreePBX à votre AD, suivez les manips suivantes :

Allez dans `Admin` -> `User Management` et enfin `Directories`,

Cliquez sur `Add` et remplissez comme suit (les infos sont celles de notre AD) :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/a5703150-89d5-4dba-97cc-cc0f95051763)

Si vous retournez dans `Users`, vous verrez la liste de vos utilisateurs :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/933b670a-428c-4f5f-8dc9-2a161c483b55)

Ensuite allez dans `Applications` puis `Extensions` et enfin `SIP [chan_pjsip] Extensions` et `Add New SIP`, vous pouvez choisir de lier cet utilisateur SIP à l'AD :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/06ea3d98-042b-426c-af7d-5947d248bedc)

Vous aurez quelque chose qui ressemble à ceci :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/c0fe11c4-cd1a-4d04-a6fd-248474fdb889)

C'est tout pour la partie FreePBX.

# **2. Installation de 3CX**

Nous avons créé une GPO afin de déployer le logiciel `3CX` sur tous les ordinateurs de `Pharmgreen`.

Sur chaque poste, il faut rentrer les utilisateurs créés sur `FreePBX` dans `3CX` comme suit :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d5b56a3f-ae28-4507-8f8e-40e8469c6917)

Vous pouvez également créer un répertoire avec ces utilisateurs :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/268c6b83-18b2-430e-bc6f-6a55b2f18d00)

Et enfin, passer un appel. Ici de `Valentina Ferrari` vers `Pauline Blanc` :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/1269edb4-01da-452f-ba8b-f459f9547963)
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/688109ea-9546-4884-bfe1-f9d812053df9)



# 3 Installation de WordPress


## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :
- Un serveur avec Proxmox installé et fonctionnel
- Une connexion internet active

## Étape 1 : Télécharger le Modèle TurnKey WordPress

1. Connectez-vous à l'interface web de Proxmox.
2. Naviguez vers `Datacenter` > `local (pve)` > `CT Templates`.
3. Cliquez sur `Templates` en haut de la page.
4. Dans la liste déroulante, recherchez `turnkey-wordpress`.
5. Cliquez sur `Télécharger` pour télécharger le modèle.

## Étape 2 : Créer un Nouveau Conteneur

1. Une fois le modèle téléchargé, cliquez sur `Create CT` dans le coin supérieur droit de l'interface web.
2. Remplissez les informations requises :
   - `Node` : Sélectionnez le nœud où vous souhaitez créer le conteneur.
   - `CT ID` : Attribuez un identifiant unique au conteneur.
   - `Hostname` : Attribuez un nom d'hôte au conteneur.
   - `Password` : Définissez un mot de passe pour l'utilisateur root.
3. Cliquez sur `Next` pour continuer.

## Étape 3 : Configurer le Modèle

1. Dans la section `Template`, sélectionnez `turnkey-wordpress` que vous avez téléchargé précédemment.
2. Cliquez sur `Next`.

## Étape 4 : Configurer les Ressources

1. Configurez les ressources pour le conteneur :
   - `CPU` : Définissez le nombre de cœurs CPU.
   - `Memory` : Définissez la quantité de RAM.
2. Cliquez sur `Next`.

## Étape 5 : Configurer le Réseau

1. Configurez les paramètres réseau pour le conteneur :
   - `Bridge` : Sélectionnez le pont réseau (ex. `vmbr0`).
   - `IPv4` : Attribuez une adresse IP (ex. `192.168.1.100/24`).
   - `Gateway` : Définissez la passerelle réseau (ex. `192.168.1.1`).
2. Cliquez sur `Next`.

## Étape 6 : Vérifier et Créer

1. Vérifiez les paramètres du conteneur dans la section `Confirm`.
2. Cliquez sur `Finish` pour créer le conteneur.

## Étape 7 : Démarrer le Conteneur

1. Après avoir créé le conteneur, allez dans `Datacenter` > `node` > `CT ID`.
2. Sélectionnez le conteneur et cliquez sur `Start` pour le démarrer.

## Étape 8 : Accéder à WordPress

1. Ouvrez un navigateur web et accédez à l'adresse IP configurée pour le conteneur (ex. `http://192.168.1.100`).
2. Suivez les instructions de configuration de WordPress pour terminer l'installation.

Vous avez maintenant un conteneur TurnKey WordPress fonctionnel sur Proxmox.


