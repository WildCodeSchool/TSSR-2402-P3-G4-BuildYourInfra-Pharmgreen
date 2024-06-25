Sommaire :

1. Transfert des rôles FSMO
2. Installation d'un serveur WSUS 

# 1. **Transfert des rôles FSMO**

## 1. **Installaion d'un nouveau Windows Server Core**

Pour l'installation d'un Windows Server Core, merci de vous référer à ce [lien](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/S10/s10_install.md).

## 2. **Installation du rôle ADDS**

Pour l'ajout du **rôle ADDS** sur le nouveau serveur, merci de vous référer à ce [lien](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/S10/s10_install.m) et pour l'ajout au **domaine**, ce [lien](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/S10/s10_User_Guide.md).

## 3. **Transfert des rôles FSMO**

Sur le serveur principal, suivre la démarche suivante :
- `WIN+R`,
- Taper `ntdsutil.exe`,
- `Entrer`,
- `?` si vous voulez la liste des commandes disponibles :
  
![1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f2b5ec20-34d4-41b4-8f3f-c8e955fcfd53)

- Taper `role` pour rentrer en mode de maintenance FSMO,
- Ensuite `Connections` et `connect to server AD-DS-CORE-01`,

![2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/3657c5e4-4b2d-44d1-8646-4fd9ab3aab62)

- `q` pour revenir au menu précédent
- `transfer RID master` :

![3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/b8b364bb-64c7-455d-a5a1-5ce5524f1a39)

- Cliquer sur `yes` :

![4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d96ccce3-b3fa-4f4e-bbdc-e9277238eee7)

- Retourner dans le mode de connection avec `connections`,
- Puis `connect to server AD-DS-CORE-02` :

![5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/e9cc9328-9623-48e6-b5ab-98c225f9c1b0)

- Même manipulation qu'avant mais avec `transfer schema master` :

![6](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f1fe7af3-9263-450f-b9ee-f3a206c90a79)

Pour vérifier, lancer un `cmd` et la commande suivante ` NETDOM QUERY /Domain:pharmgreen.org FSMO` :

![7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ad922645-d03d-4718-a512-b900ee39e6f6)


# 2. **Installation d'un serveur WSUS**

## 1. **Installation du rôle**

- Il faut installer le rôle `Windows Server Update Services`, nous avons choisi de l'installer sur notre serveur principal.
![1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/f4b17904-1e93-43ed-9f52-7d50c9585eb8)

- Laissez toutes les options par défaut qui sont déjà cochées :  
![2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/4a7acfa1-290d-4d6a-872c-142ac75e9e07)

- Cliquez sur `Next`, jusqu'à arriver à cet écran, ne cocher que les deux premières options.  
![3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/dd202816-c16c-4c53-a41f-4f5f3bdfb26f)

- Définissez ensuite un emplacement de sauvegarde des fichiers de mise à jour :  
![4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/2db65634-1ac0-4ef1-af77-3fb8a4ec978a)

- Cliquez sur `Next`, laissez toutes les options déjà cochées par défaut et cliquez sur `Install`
![5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/895a085f-8107-40ff-b945-50863347ebe6)

- Une fois l'installation terminée, le `Server Manager` vous informe (**Panneau attention** à côté du drapeau) qu'il reste des choses à faire, il faut lancer les tâches de post-installation.
![5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/7646576b-0ab3-44d9-8d8f-e1ca5a9fa424)

- Une fois les tâches de post-installation temrinées, le **panneau Attention** disparait à côté du drapeau dans la fenêtre du `Server Manager`.

L'installation est terminé.

## 2. **Configuration de base de WSUS**

WSUS est maintenant installé sur notre serveur. On va pouvoir lancer la console « Services WSUS » soit depuis le menu démarrer en tapant `Windows Serveur Updates Services` soit via le **Serveur Manager** et menu **Tools**

- Pour lancer la configuration, appuyez sur `Next`:
![6](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/8e835541-9c86-46f9-9f2d-d1e70878f5b5)

- Si vous ne voulez pas participer au programme d'amélioration de Microsoft Update, ne cochez pas l'option et appuyez sur `Next`
- Laissez toutes les option par défaut jusqu'à cet écran et cliquez sur `Start Connecting`, WSUS va se connecter au service de Microsoft pour récupérer la liste des systèmes d’exploitation et logiciels pris en charge, les types de mises à jour, et les langages disponibles. Cela peut prendre un certain temps.
![7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/dff03249-f530-4cb1-a258-1cd09effc52c)

- Sur les écrans suivant vous allez pouvoir choisir ce que vous voulez installer comme mises à jour, nous avons choisi :
-   Language : English et French.
-   Products : Tout ce qui est lié à l'Active Directoy, Windows Server 2022 et Windows 10 (Windows 10, version 1903 and later). Il y a beaucoup de possibilités, libre à vous de choisir ce qui est le plus adéquat pour vous.
-   Classification : Critical Updates / Definition Updates / Security Updates / Updates / Upgrades, cela permet d'avoir des mises à jour mensuelles publiées par Microsoft.
![8](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/0edc9241-0ef8-4432-802d-70b174a06151)
 
![9](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/ec46b72d-b37f-407e-8f26-53820fee0e49)  

![10](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/b96809ca-d784-4bf6-8c9e-ce969f9b9e90)

- Vous pouvez ensuite défninir une heure de synchronisation pour le téléchargement des mises à jours, planifiez-le durant la nuit pour ne pas gêner les utilsiateurs ou la production.
![11](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/7f47c518-f48f-4bc6-815a-d10a2d489aad)

- Vous pouvez lancez la synchronisation sur l'écran suivant.
- Dans la fenêtre de gestion de **WSUS** ,dans la partie Synchronisation vous poourez y vérifier son état :
![12](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/9537e031-f1c4-411b-aa2e-ecfaf8e9943c)







