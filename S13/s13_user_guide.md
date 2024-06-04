## creation dossier partager utilisateur

- Dans le lecteur E: creer un dossier utilisateur
- faire un clique droit dessus -> Properties -> sharing -> Advanced Sharing
- cocher la case Share this folder
- en Share name : utilisateurs$ (le $ sert a cacher le chemin reseau)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0cfbad3c-bb73-4b04-a780-100b77ae9d64)

- cliquer sur permission et faire comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0fc32638-52f3-4a0a-a586-0a33588805ec)


- valider, de retour sur la fenetre Properties allez a l'onglet Security

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7c5e044c-bcad-40ad-827b-05cfab72e61e)


- cliquer sur Advanced
- cliquer sur le bouton Disable inheritence

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b84b4ce7-a1b9-4fa4-97ba-e6cb8af1ff55)


- cliquez sur add et ajouter les permissions comme sur l'image au dessus et mettre Full control sur toutes les Permissions

## creation de la GPO

- User Configuration/Preferences/windows Settings/Drive maps
- creer un nouveau mappage comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/139cba92-a24d-4bdb-9d93-e8d16b87c868)



- et dans l'onglet common : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/994ca9e9-3600-4444-a1e7-5408333f1bda)


- User Configuration/Preferences/windows Settings/Folders
- creer un nouveau dossier comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a7499789-35dd-456b-b328-1ef4dd9c5948)


- et dans l'onglet common : 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/9aa01851-0ea8-4e98-9d9b-1f3caa800be8)


- User Configuration/Preferences/windows Settings/Shortcuts
- creer un nouveau racourci comme cela :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c9e6b6a7-08c8-4f94-88f3-334a10561fd4)


- et dans l'onglet common 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c4dbaecc-aca8-4c80-b8b1-f00ef35bc898)


- appliquer la GPO a l'OU User_Pharmgreen
- connecter vous avec un compte client et vous devriez voir apparaitre le dossier perso de l'utilisateur avec son pseudo de connexion 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/49065a07-0996-40de-b027-acaa2b20185d)


