# Changement de l'infrastructure réseau :
Se référer au sprint 4 du readme pour comprendre les changements effectués.
Changer les adresses réseaux de tout les équipements déjà mit en place, pour respecter la nouvelle infrastruture virtuelle utilisée.
Plan adressage de l'infrastruture virtuel ainsi que les tables de routage utilisé : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Plan_adressage.xlsx

# Configuration du routeur Vyos :

En préambule, nous avons rajouté sur la VM qui nous sert de routeur les cartes réseau suivantes : 

- vmbr13 avec l'adresse `172.16.3.1/24` pour les machines "serveurs"
- vmbr14 avec l'adresse `192.168.9.1/24` pour les machines "client"

et modifié la vmbr10 en `172.16.2.1/24`.

La VM a donc 3 cartes réseau configurées de la sorte :

- `eth0 172.16.3.254/24`
- `eth1 192.168.9.254/24`
- `eth2 172.16.2.254/24`

Afin de les mettre en place il faut faire ceci, une fois connecté (id : vyos/mdp : vyos) :
- `config` pour rentrer en mode de configuration
- `set interfaces ehternet eth0 address 172.16.3.254/24`
- De même avec les autres interfaces (en précisant `eth1` et `eth2` ainsi que les bonnes adresses)
- `commmit`
- `exit`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/1507ba4c-ac58-49a7-a91d-316f0c287773)


Pour que nos différents réseaux communiquent entre eux, il faut établir les règles de routage :
- `config`
- `set protocols static route 172.16.1.0/24 next-hop 172.16.2.253`
- De même pour les autres routes que vous voudriez rajouter
- `commmit`
- `exit`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/b0cb8f8a-aada-46f7-bb29-311d1e074e70)
