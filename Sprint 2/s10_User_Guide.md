## ajout du serveur Debian a l' Active Directory

### configuration reseau

modifier le fichier **/etc/network/interfaces** comme suis :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/78b1ea49-a209-4c33-bce3-5b6be1eb875f)


### Paquet necessaire pour ajouter le serveur à l'active directory

executer cette commande : **apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd**

### modification fichier resolv.conf

modifier le fichier /etc/resolv.conf comme cela :
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/78eac284-8141-4177-b7e4-34eb29467984)


### ajout de la machine au serveur AD

executer la commaande **realm join --user=administrator pharmgreen.org**


# installation et configuration du serveur ssh

## action a effectuer sur le serveur

pour installer le protocole SSH sur le serveur effectuer cette commande **apt install openssh-server**
