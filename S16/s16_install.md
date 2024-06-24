Sommaire :

1. Transfert des rôles FSMO

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

Pour vérifier, lancer un `cmd` et la commande suivante `QUERY /Domain:pharmgreen.org FSMO` :

![7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ad922645-d03d-4718-a512-b900ee39e6f6)
