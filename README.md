# **TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen**

##  **Sommaire**

1) Présentation du Projet et Objectifs de la semaine

2) Mise en contexte

3) Présentation des membres du groupe et rôles par Sprint

4) Choix techniques, contraintes et solutions 

5) Conclusion

## **Présentation du Projet et Objectifs**

Le Projet **_Build Your Infra - Pharmgreen_** consiste à analyser, à partir des différents éléments à disposition, l'état actuel de la société et estimer les besoins. A partir de cela, il fallait faire des propositions d'objectifs, les classer, et estimer sur quel sprint ils devront être mis en place.

## **Mise en contexte**

Nous venons d'être embauchés par la société Pharmgreen, au sein du département Systèmes d'Information, pour pallier au manque de techniciens Systèmes et Réseaux. Notre rôle consiste à mettre en place une infrastructure réseau.

Dans le contexte du projet, le formateur sera le DSI de la société.

## **Présentation des membres du groupe et rôles par Sprint**

Le groupe est composé de :
* **Pierre Girard**
* **Julien Guillot**
* **Maxime Kamara**
* **Bruno Serna**

### **Sprint 1 : semaine du 23 au 30 avril 2024**

Activités et répartitions des tâches

| **NOM** | **Taches éffectuées** |
| :--: | :----------: |
| Pierre (PO) | Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, script powershell intégration utilisateurs à partir d'un fichier CSV |
| Julien (SM) | Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, plan d'adressage, README.md |
| Maxime |  Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, création des VM |
| Bruno | Nomenclature (80%), OU, groupes, plan schématique, liste serveurs et matériels |

### **Sprint 1 : semaine du 13 au 17 mai 2024**

Activités et répartitions des tâches

| **NOM** | **Taches éffectuées** |
| :--: | :----------: |
| Pierre (SM) | |
| Julien  | |
| Maxime |   |
| Bruno (PO) | |

## **Choix techniques, contraintes et solutions**

L'entreprise ne fait pas partie d'un domaine et ne dispose pas d'un Active Directory, il faudra donc mettre en place un serveur AD (+ DHCP et DNS). Une sécurité via mot de passe sera mise en place.

Par ailleurs, la messagerie est hébergée en cloud sur le web, la mise en place d'un serveur de messagerie est donc envisagée également. 

De plus, toutes les données sont stockées en local et il n'sxiste aucune sauvegarde. La mise en place d'un serveur de fichier et d'un serveur de redondance semble tout indiquée.

Enfin, l'accès internet se fait en wifi fourni par un FAI et via des répétiteurs wifi répartis dans toutes l'entreprise. Des routeurs et des switchs seront donc installés afin d'obtenir une meilleure connexion au sein de l'entreprise.

## **Conclusion**

Ce que nous proposons lors de cette première semaine d'études est une ébauche des solutions qui seront apportées tout au long de ce projet.
