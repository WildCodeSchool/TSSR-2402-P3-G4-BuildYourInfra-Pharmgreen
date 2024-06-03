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


configuration du serveur ssh

## action a effectuer sur le serveur

Modifiez le fichier /etc/ssh/sshd_config comme cela :

![330871160-6df03c53-2575-4d6d-b626-5c9887b05ce4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/8dda6de4-7d39-4f56-8ca0-3fe505ba92fa)

![330871297-bde0c267-4836-4366-a189-23321c6849c0](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7f4cc67e-f1d8-4894-b7ca-f2f5655398fc)

Après avoir modifier le fichier, pensez à executer la commande systemctl restart sshd

Executez ces commandes pour créer le dossier qui va acceuillir la clé publique de notre client:

- `mkdir /home/wilder/.ssh`
- `chmod 700 /home/wilder/.ssh`
- `touch /home/wilder/.ssh/authorized_keys`
- `chmod 600 /home/wilder/.ssh/authorized_keys`

# Dernière configuration

De retour sur le serveur, remodifiez le fichier /etc/ssh/sshd_config

![330871507-5c9d0416-6b82-4c8c-a541-40d970c99395](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/8d77a6d1-914d-4f1e-a7a4-ed30adc09214)

Côté client; pour vous connecter, exécutez cette commande `ssh wilder@192.168.9.4 -p 6666`
