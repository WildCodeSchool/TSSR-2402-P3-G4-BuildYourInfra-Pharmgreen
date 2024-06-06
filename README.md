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
| Maxime (PO) | Création GPO, Création serveur GLPI, Script pour Serveur CORE, Script pour Serveur GLPI, Script pour ajout utilsiateur dans groupe, Documentation |
| Bruno (SM) | Création GPO, Test GPO, Script pour Serveur CORE, Documentation |

### **Sprint 4 : semaine du 27 au 31 mai 2024**

Activités et répartition des tâches

| **NOM** | **Tâches effectuées** |
| :--: | :----------: |
| Pierre | GPO télémétrie, Mise en place règles sur Pfsense |
| Julien (PO) | Routage Vyos, Mise en place règles sur Pfsense |
| Maxime (SM) | Mise en place règles sur Pfsense, Doc Pfsense |
| Bruno | Routage Vyos, Mise en place table de routage |

Une nouvelle infrastucture réseau a été mise en place , elle respecte le plan réseau mis en place lors du premier sprint.  
Elle se compose actuellement de quatre VLAN :
- VLAN Infra : Adresse réseau `172.6.3.0/24`, où sont situés tous les serveurs servant à notre infrastruture d'entreprise.
- VLAN SI : Adresse réseau `192.168.9.0/24`, où sont situés tous les postes client, elle nous permet de simuler les poste client qui seront ensuite dupliqués dans les futurs VLAN des départements lors de la mise en place de l'infrastructure complète de la société.
- VLAN DMZ : Adresse réseau `172.16.1.0/24`, où seront situés les futurs serveur WEB et autres équipements nécéssitant d'être mis dans la DMZ.
- VLAN Firewall : Adresse réseau `172.16.2.0/24`, où est situé le Firewall géré par PfSense et un poste client pour nous donner un accès direct à son interface Web lors de sa configuration.
- Routeur principal de notre infrastucture RO_INFRA_01 : nous permet de mettre en place nos règles de routage entre les différents VLAN et le Firewall de notre Infrastucture.

Dans le dossier ressources de ce dépot Github, vous trouverez plusieurs document :  
- Plan réseau de l'infrastructure globale qui va évoluer selon notre avancé dans le projet :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/plan_reseau.png  
- Plan réseau de l'infrastructure virtuel qui a été mit en place :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Infra_Simplifie.png  
- Plan adressage de l'infrastruture virtuel ainsi que les tables de routage utilisé (soumis à évolution) :  
https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/Plan_adressage.xlsx  

Notre nouvelle infrastucture réseau fonctionne parfaitement, les règles de routages ont été mises en place, ainsi que des règles de bonnes pratiques sur le pare-feu et des GPO pour gérer la télémétrie.

### **Sprint 5 : semaine du 3 au 7 juin 2024**

Activités et répartition des tâches

| **NOM** | **Tâches effectuées** |
| :--: | :----------: |
| Pierre (PO) | CloneZilla, dossiers partagés |
| Julien (SM) | Dossiers partagés, LAPS, RAID1 (Windows) |
| Maxime  | RAID1 (Debian + Windows), dossiers partagés |
| Bruno | Dossiers partagés, script : automatisation PC dans OU + définition horaires de travail + optimisation des scripts |

### **Configuration Réseau**

| **NOM POSTE PROXMOX** | **ADRESSE IP** | **ROLE** |
| :--: | :----------: | :----------: |
| G4-AD-DS-CORE-01| 172.16.3.2 | AD Domaine Repliquer |
| G4-GLOBAL | 172.16.3.3 | AD Domaine, DNS, DHCP, Serveur de Fichier |
| G4-PC-PI0001 | 192.168.9.5 | PC Client |
| G4-SRV-GLPI-RAID | 172.16.3.10 | Serveur GLPI |
| G4-PC-PI0002  | 172.16.2.10 / 192.168.9.7 | PC Client / accès direct Firewall |
| G4-pfsense  | LAN : 172.16.2.253, DMZ : 172.16.2.254, WAN : 10.0.0.3 | Firewall |
| G4-RO-INFRA-01  | -- | Routage |

## **Choix techniques, contraintes et solutions**

L'entreprise ne fait pas partie d'un domaine et ne dispose pas d'un Active Directory, il faudra donc mettre en place un serveur AD (plus DHCP et DNS). Une sécurité via mot de passe sera mise en place.

Par ailleurs, la messagerie est hébergée en cloud sur le web, la mise en place d'un serveur de messagerie est donc envisagée également.

De plus, toutes les données sont stockées en local et il n'existe aucune sauvegarde. La mise en place d'un serveur de fichiers et d'un serveur de redondance semble tout indiquée.

Enfin, l'accès à Internet se fait en Wi-Fi fourni par un FAI et via des répétiteurs Wi-Fi répartis dans toute l'entreprise. Des routeurs et des switchs seront donc installés afin d'obtenir une meilleure connexion au sein de l'entreprise.

## **Conclusion**

Cette cinquième semaine, nous avons accompli des avancées significatives.  
Nous avons installé du RAID 1 sur tout nos poste serveur de l'infrastructure, cela nous a permit de mettre en place des dossiers réseaux pour les utilisateurs :
- Dossier personnels accessible uniquement par eux-même.
- Dossier de Département accessible uniquement aux membres du même département.
- Dossier de Service accessible uniquement aux membres du même service.
Le tout est sauvegardé un fois par semaine, le dimanche après-midi.
Un scrit est utilisé lancé une fois par jour, pour vérifié le placement des ordinateurs dans les bonnes OU et une restriciton d'horaire de connexion de 7h à 20h , du Luni au Samedi a été mis en place pour les utilisateurs non-administrateur du domaine et des équipements.
De plus LAPS a été installé et configurer, permettant d'avoir un mot de passe chiffré, aléatoire et renouvelé tous les 30 jours pour les administrateur locaux des machines.

