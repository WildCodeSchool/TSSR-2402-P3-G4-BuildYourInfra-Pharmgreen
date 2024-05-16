# Documentation Administrateur

## Ajout du serveur Debian a l' Active Directory

### Configuration reseau

Modifier le fichier **/etc/network/interfaces** comme suis :


![Capture](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a8ac382b-05cb-475e-8292-adbb51969dcb)


### Paquet necessaire pour ajouter le serveur à l'active directory

Executer cette commande : **apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd**

### Modification fichier resolv.conf

Modifier le fichier /etc/resolv.conf comme cela :

![image-1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9ee74866-6e02-4e7f-9dd1-571e731d1ff6)

### Ajout de la machine au serveur AD

Executer la commaande **realm join --user=administrator pharmgreen.org**


# Installation et configuration du serveur ssh

## Action a effectuer sur le serveur

Pour installer le protocole SSH sur le serveur effectuer cette commande **apt install openssh-server**

Modifier le fichier /etc/ssh/sshd_config comme cela :

![capture3ssh](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/6df03c53-2575-4d6d-b626-5c9887b05ce4)


![CAPTURE5SSH](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/bde0c267-4836-4366-a189-23321c6849c0)

Après avoir modifier le fichier penser a executer la commande **systemctl restart sshd**

Executer ces commandes pour creer le dossier qui va acceuillir la clef publique de notre client:
- **mkdir /home/wilder/.ssh**
- **chmod 700 /home/wilder/.ssh**
- **touch /home/wilder/.ssh/authorized_keys**
- **chmod 600 /home/wilder/.ssh/authorized_keys**

# Configuration client ssh

- Generer une clef publique  en executant cette commande en powershell **ssh-keygen -t rsa 4096**

- Copier la clef sur le serveur en executant cette commande **cat ~/.ssh/id_rsa.pub | ssh root@192.168.9.4 "cat >> ~/.ssh/authorized_keys"**

# Derniere configuration

De retour sur le serveur remodifier le fichier /etc/ssh/sshd_config

![image-7](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/5c9d0416-6b82-4c8c-a541-40d970c99395)

Coté client pour vous connecter executer cette commande **ssh wilder@192.168.9.4 -p 6666**
