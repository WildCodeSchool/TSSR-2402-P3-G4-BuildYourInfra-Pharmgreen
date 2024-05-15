# Documentation Administrateur

## ajout du serveur Debian a l' Active Directory

### configuration reseau

modifier le fichier **/etc/network/interfaces** comme suis :


![Capture](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a8ac382b-05cb-475e-8292-adbb51969dcb)


### Paquet necessaire pour ajouter le serveur à l'active directory

executer cette commande : **apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd**

### modification fichier resolv.conf

modifier le fichier /etc/resolv.conf comme cela :
![alt text](image-1.png)

### ajout de la machine au serveur AD

executer la commaande **realm join --user=administrator pharmgreen.org**


# installation et configuration du serveur ssh

## action a effectuer sur le serveur

pour installer le protocole SSH sur le serveur effectuer cette commande **apt install openssh-server**
