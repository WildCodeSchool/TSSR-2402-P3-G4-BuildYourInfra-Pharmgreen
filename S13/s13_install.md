# Création RAID 1 sous Windows Server Core

Pour mettre en place un RAID 1 sous Windows Server Core, il est d'abord nécessaire d'ajouter un second disque de la même taille sous Proxmox.

Ensuite il faut convertir le nouveau disque en GPT et en disque dynamique, pour cela sélectionner le nouveau disque et procéder comme suit : 
- `select disk 0`
- `convert gpt`
- `convert dynamic`

Faire de même avec le disque principal, seulement pour la partie disque dynamique. 
- `select disk 1`
- `convert dynamic`

Après faire `list volume`, ici c'est le 1 donc faire `select volume 1`.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/d2811614-6231-4bde-865b-c702de34b659)

Ensuite faire `add disk=0` (0 étant le nouveau disque).

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/07e9d821-7a4d-4998-ace8-85592f6cdf61)

On a bien notre disque 1 en miror avec le disque 0.

# Création RAID 1 sous Windows Server 2022

Pour mettre en place un RAID 1 sous Windows Server Core, il est d'abord nécessaire d'ajouter un second disque de la même taille sous Proxmox.

Il faut d'abord convertir les disques en disques dynamiques, pour cela clic droit sur `Disk 0` et vous aurez ceci : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/b691418b-b08c-4486-8a27-014b06120b3b)

Allez jusqu'au bout de la manip.

Ensuite cliquer sur `Add Mirror` sur le disque d'origine et choississez `Disk 1` en miroir, suivez les étapes jusqu'au bout et c'est bon.

# LAPS

## Installation du module LAPS

D'abord il vous faut entrer les commandes suivantes : `Import-Module LAPS` et `Update-LapsADSchema`. Vous verrez par la suite dans les propriétés des PC de l'AD les attributs suivants dans "Attribute Editor" ainsi qu'un nouvel onglet "LAPS" : 

![image](https://github.com/JuGuillot/test/assets/161329881/b488494a-99a6-4a55-94a9-258377d278e7)

## Attribuer les droits d'écriture aux machines

Exécuter la commande suivante pour que les droits s'appliquent sur l'ensemble des PC du domaine : 
- `Set-LapsADComputerSelfPermission -Identity "OU=Computer_Pharmgreen,DC=pharmgreen.org"`

![image](https://github.com/JuGuillot/test/assets/161329881/ed27114d-ecfc-4acb-bad0-d5e2ba06703d)
