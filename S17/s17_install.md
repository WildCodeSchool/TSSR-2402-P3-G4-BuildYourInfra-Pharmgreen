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

