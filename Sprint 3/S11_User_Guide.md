# Ajout d'une serveur Windows Core à l'Active Directory via un script

Se placer sur le serveur principal dans le dossier `C:\Ressources` et récupérer les deux deux fichiers aux adresses suivantes :
- Script : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Script/script_AD-DS.ps1
- Fichier de configuration : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/liste/configAD-DS.csv

Ensuite, il faut lancer un serveur Windows Core, le mettre sur le sur le même réseau que le serveur (172.16.3.0/24) Principal et récupérer le script et le fichier de configuration grâce aux commande suivantes :
- Création d'un répertoire : `New-Item -ItemType Directory C:\Script`.
- Copie du script : `Copy \\Winserv\Ressources\script_AD-DS.ps1 C:\Script`.
- Copie du fichier de configuration : `Copy \\Winserv\Ressources\ConfigAD-DS.csv C:\Script`.

Vous pouvez modifier le fichier **ConfigAD-DS.CSV**, grâce à la commande suivante :
- Se placer dans le bon répertoire où est enregistré le fichier, puis lancer `notepad.exe ConfigAD-DS.csv`.
- Attention, dans la modification des champs cela peut entrainer des erreurs.
- Les deux premiers champs correspondent au nouveau nom donné au serveur et le second à sa nouvelle adresse IP.  

Exécuter le script et, après un redémarrage automatique, le serveur a bien été renommé et intégré au domaine.
![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/c0ec11a2-cbf7-47c5-af48-197a4a433e94)

Vous pouvez maintenant ajouter le serveur core sur le serveur principal via l'outil **Serveur Manager** (S10_UserGuide.md) et vous pouvez voir que le serveur est bien ajouté et à son rôle AD-DS.

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/b2da02b5-eded-4720-beef-c4b980f9e359)
