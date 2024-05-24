# **TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen**

## **Sommaire**

1. Présentation du Projet et Objectifs de la semaine
2. Mise en contexte
3. Présentation des membres du groupe et rôles par Sprint
4. Choix techniques, contraintes et solutions
5. Conclusion

## **Présentation du Projet et Objectifs**

Le Projet **_Build Your Infra - Pharmgreen_** consiste à analyser, à partir des différents éléments à disposition, l'état actuel de la société et estimer les besoins. À partir de cela, il fallait faire des propositions d'objectifs, les classer, et estimer sur quel sprint ils devront être mis en place.

## **Mise en contexte**

Nous venons d'être embauchés par la société Pharmgreen, au sein du département Systèmes d'Information, pour pallier le manque de techniciens Systèmes et Réseaux. Notre rôle consiste à mettre en place une infrastructure réseau.

Dans le contexte du projet, le formateur sera le DSI de la société.

## **Présentation des membres du groupe et rôles par Sprint**

Le groupe est composé de :
* **Pierre Girard**
* **Julien Guillot**
* **Maxime Kamara**
* **Bruno Serna**

### **Sprint 1 : semaine du 23 au 30 avril 2024**

Activités et répartition des tâches

| **NOM** | **Tâches effectuées** |
| :--: | :----------: |
| Pierre (PO) | Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, script PowerShell intégration utilisateurs à partir d'un fichier CSV |
| Julien (SM) | Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, plan d'adressage, README.md |
| Maxime |  Nomenclature, OU, groupes, plan schématique, liste serveurs et matériels, création des VM |
| Bruno | Nomenclature (80%), OU, groupes, plan schématique, liste serveurs et matériels |

### **Sprint 2 : semaine du 13 au 17 mai 2024**

Activités et répartition des tâches

| **NOM** | **Tâches effectuées** |
| :--: | :----------: |
| Pierre (SM) | Création et configuration VM Debian SSH et Client Windows, mise en place SSH |
| Julien  | Création d’un domaine AD (VM Windows Server + Windows Server Core) |
| Maxime | Gestion AD - AUTO Groupe et Users (Script) |
| Bruno (PO) | Gestion de l'arborescence AD (création OU) et aide sur Scipt pour création auto |

### **Sprint 3 : semaine du 21 au 24 mai 2024**

Activités et répartition des tâches

| **NOM** | **Tâches effectuées** |
| :--: | :----------: |
| Pierre | Création GPO, Test GPO, Documentation |
| Julien  | Création GPO, Création serveur GLPI, import utilisateurs et groupes et machines dans GLPI, Script pour Serveur GLPI, Documentation |
| Maxime (PO) | Création GPO, Création serveur GLPI, Script pour Serveur CORE, Script pour Serveur GLPI, Documentation |
| Bruno (SM) | Création GPO, Test GPO, Script pour Serveur CORE, Documentation |

### **Configuration Réseau**


| **NOM POSTE PROXMOX** | **ADRESSE IP** |
| :--: | :----------: |
| G4-AD-DS| 192.168.9.3 |
| G4-GLOBAL | 192.168.9.2 |
| G4-SSH | 192.168.9.4 |
| G4-PC-PI0001 | 192.168.9.5 |
| G4-SRV-GLPI | 192.168.9.6 |
| G4-PC-PI0002  | 192.168.9.7 |
| G4-AD-Core-Test | 192.168.9.10 |

## **Choix techniques, contraintes et solutions**

L'entreprise ne fait pas partie d'un domaine et ne dispose pas d'un Active Directory, il faudra donc mettre en place un serveur AD (plus DHCP et DNS). Une sécurité via mot de passe sera mise en place.

Par ailleurs, la messagerie est hébergée en cloud sur le web, la mise en place d'un serveur de messagerie est donc envisagée également.

De plus, toutes les données sont stockées en local et il n'existe aucune sauvegarde. La mise en place d'un serveur de fichiers et d'un serveur de redondance semble tout indiquée.

Enfin, l'accès à Internet se fait en Wi-Fi fourni par un FAI et via des répétiteurs Wi-Fi répartis dans toute l'entreprise. Des routeurs et des switchs seront donc installés afin d'obtenir une meilleure connexion au sein de l'entreprise.

## **Conclusion**

Cette troisième semaine, nous avons accompli des avancées significatives avec la création de GPO Sécurité et GPO standard, ainsi que la mise en place d'un serveur GLPI. De plus, nous avons développé des scripts d'automatisation pour le serveur Core et AD-DS, ainsi que pour l'installation de GLPI.
