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
