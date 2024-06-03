# Ajout d'un Server Core au Domaine

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

