# **Sommaire**

1) Création et ajout automatique de données à l'Active Directory via Script

2) Ajout d'un Server Core au Domaine

3) Ajout du serveur Debian a l' Active Directory

4) Configuration du serveur ssh


## **1.  Création et ajout automatique de données à l'Active Directory via Script**

Dans un premier temps récupérer les fichiers suivant et les placer par exemple dans un dossier sous `C:\Script` sur le Serveur Principal

Fichier des Ressources Humaines contenant toute les informations des employés de la société :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/s09_Pharmgreen.xlsx

Fichier listant les groupes Utilisateur (créé manuellement à partir de la nomenclature et du fichier fournit par les Ressources Humaines) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/Groupe_User.csv

Fichier listant les groupes Ordinateurs (créé manuellement à partir de la nomenclature et du fichier fournit par les Ressources Humaines) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/Groupe_Computer.csv

Fichier pour ajout utilisateur au groupe (créé manuellement à partir de la nomenclature et du fichier fournit par les Ressources Humaines) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/liste_utilisateur_group.csv

Script permettant de mettre en forme le fichier des employés pour exploitation par les Script (Suppression des caractère spéciaux dans les noms, remplacement des noms Département et Service selon la nommenclature définit) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/mise_en_forme_CSV.ps1

Script de création automatique des deux OU Principale et des sous OU associées :   
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Ou_Auto.ps1

Script de création automatique des utilisateurs et placement dans les OU correspondantes :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Utilisateur_auto.ps1

Script de modifications automatique des utilisateurs soumis à évolution (actuellement il ajoute juste les managers) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Modif_Utilisateur_auto.ps1

Script de création automatique des groupes utilisateurs :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Groupe_auto_Users.ps1

Script de création automatique des groupes ordinateurs :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Groupe_auto_Computer.ps1

Script ajout automatique des utilisateurs dans leur groupe :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Groupe_Ajout_Utilisateurs_Groupe.ps1

Script création automatique des odirnateurs et placement dans les OU correspondantes :
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/Ajout_auto_Computer.ps1

Pour la bonne utilisation des Scripts, placer tout les fichiers au même endroits.  
Tout est basé sur la nomenclature disponible ici :
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Nomenclature.xlsx

En préambulle, lancez le script **mise_en_forme_CSV.ps1**, sinon les script ne fonctionneront pas et cela vous assure d'avoir des données à jour.  
Selon votre besoin, lancé le script associé à votre demande.  
Si l'élément que vous souhaité créer ou ajouter existe déjà vous aurez un message vous le signalant, en cas d'échec un message apparait aussi.  
En cas de souci, vérifiez que tout les documents soit placé au même endroit, contactez la personne qui vous a fournit les scripts pour voir avec elle ce qu'il ne va pas.


## **2. Ajout d'un Server Core au Domaine**

Assurez vous d'avoir un Serveur Core déjà installé et sur la même plage d'adresse IP que Serveur AD Principal :

- Sur l'écran principal, faites "1"
- Entrez ensuite "D"
- Indiquez votre domaine (ici pharmgreen.org)
- Indiquez ensuite l'utilisateur autorisé (ici pharmgreen.org\administrator)
- Ainsi que le mot de passe (Azerty1*)

Vous aurez alors un message de bienvenue dans le domaine sélectionné et quand vous retournez au menu principal :

![Pasted image 20240514151103](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2ffd38f0-506c-45e3-8b27-62fdcb541684)

Sur le Windows Server (en GUI), ouvrez le Serveur Manager et selectionner "Manage" puis "Add Servers" :

![AD-DS1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/fd69ae44-3826-45d9-aea5-8b45ea717e74)  

Ensuite, appuyez sur "Find Now" et double cliquez sur "AD-DS" (le nom du Serveur Core), il devrait apparaitre dans le fenêtre de droite et validez en cliquant sur le bouton "OK".  

![AD-DS1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/992776d8-5ccf-42c9-9c51-18f1a64f4346)

Sur le Windows Server (en GUI), vous aurez une notification en haut comme ceci :

![1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/f5720148-2f75-457c-a95e-1bcc64d2c5bf)

Cliquez dessus et entrez les informations suivantes :
- Laissez coché "Add a domain controller to an existing domain" (ici pharmgreen.org)
- Rentrez les informations de connexion du domaine (Administrator et Azerty1*)

![2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/0da59abf-96a5-457a-8637-ca9407114ca7)

- Faites "Next" jusqu'à arriver ici et rentrez le mot de passe
  
![3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2e39ce4e-a5d1-4f91-a8ed-01cafab1e843)

- Refaites "Next" jusqu'à arriver à cet écran et sélectionnez bien le serveur principal pour la réplication

 ![4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/2b005c4c-c1bc-4f2d-b3df-b2394efd159c)

- Faites "Next" jusqu'à la fin et cliquez sur "Install". Le serveur Core va redémarré à la fin et vous devriez arrivez sur cet écran la.
![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/cf95cd2b-80eb-4ca7-8c58-37adb9189431)

En cas de souci, se réferrez à votre administrateur principal pour vérifiez avec lui la configuration du serveur CORE et serveur principal.


## **3. Ajout du serveur Debian a l' Active Directory**

### configuration reseau

Modifier le fichier **/etc/network/interfaces** comme suis :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/78b1ea49-a209-4c33-bce3-5b6be1eb875f)


### Paquet necessaire pour ajouter le serveur à l'active directory

Executer cette commande : **apt install packagekit samba-common-bin sssd-tools sssd libnss-sss libpam-sss policykit-1 sssd ntpdate ntp realmd**

### modification fichier resolv.conf

Modifier le fichier /etc/resolv.conf comme cela :
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/78eac284-8141-4177-b7e4-34eb29467984)


### Ajout de la machine au serveur AD

Executer la commaande **realm join --user=administrator pharmgreen.org**


## **4. Configuration du serveur ssh**

### Action a effectuer sur le serveur

Modifiez le fichier /etc/ssh/sshd_config comme cela :

![330871160-6df03c53-2575-4d6d-b626-5c9887b05ce4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/8dda6de4-7d39-4f56-8ca0-3fe505ba92fa)

![330871297-bde0c267-4836-4366-a189-23321c6849c0](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7f4cc67e-f1d8-4894-b7ca-f2f5655398fc)

Après avoir modifier le fichier, pensez à executer la commande systemctl restart sshd

Executez ces commandes pour créer le dossier qui va acceuillir la clé publique de notre client:

- `mkdir /home/wilder/.ssh`
- `chmod 700 /home/wilder/.ssh`
- `touch /home/wilder/.ssh/authorized_keys`
- `chmod 600 /home/wilder/.ssh/authorized_keys`

### Dernière configuration

De retour sur le serveur, remodifiez le fichier /etc/ssh/sshd_config

![330871507-5c9d0416-6b82-4c8c-a541-40d970c99395](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/8d77a6d1-914d-4f1e-a7a4-ed30adc09214)

Côté client; pour vous connecter, exécutez cette commande `ssh wilder@192.168.9.4 -p 6666`
