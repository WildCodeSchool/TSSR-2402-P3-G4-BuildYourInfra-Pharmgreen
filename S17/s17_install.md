Sommaire :

1. Installation et configuration de FreePBX

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

## **3. Lien avec l'Active Directory**

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
