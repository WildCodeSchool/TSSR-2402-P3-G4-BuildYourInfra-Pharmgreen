# PRA (Plan de Reprise d'Activité)

## A. Évaluation :
### 	1. Identification des élément critiques HS

Suite à un incident électrique, plusieurs de nos équipements sont hors-service, non accessibles ou seulement dysfonctionnels.
Après avoir redémarré les machines une par une, on a pu trouver et identifier les pannes qui sont survenues.
Ci-dessous un résumé des problèmes rencontrés et identifiés :

|     Equipement      |                                                Adresse IP                                                 |   Rôle/fonction    |      État      | Commentaire                                                              |
| :-----------------: | :-------------------------------------------------------------------------------------------------------: | :----------------: | :------------: | ------------------------------------------------------------------------ |
|      G4-Global      |                                                172.16.3.3                                                 | Serveur Principal  |      H.S.      | Ne démarre plus                                                          |
|  G4-AD-DS-CORE-01   |                                                172.16.3.2                                                 | Client Win 10 Pro  |      H.S.      | Pas récupérable                                                          |
|  G4-AD-DS-CORE-02   |                                                172.16.3.16                                                | Client Win 10 Pro  |      H.S.      | Pas récupérable                                                          |
|     G4-Pfsense      | - EM0 WAN : VMBR1 10.0.0.3/24<br>- EM1 LAN : VMBR10 172.16.2.253/24<br>- EM2 DMZ : VMBR11 172.16.1.254/24 |      Firewall      | Inopérationnel | Hors-réseau                                                              |
| Conteneur Wordpress |                                                172.16.3.20                                                |     Conteneur      |      H.S.      | Pas récupérable                                                          |
|     G4-SRV-GLPI     |                                                172.16.3.10                                                | Serveur Ticketing  |  Fonctionnel   | RAID1 semble être dégradé.                                               |
|     G4-SRV-MAIL     |                                                172.16.3.15                                                | Serveur messagerie | Inopérationnel | Serveur plus accessible et une partie de la mémoire RAM semble être H.S. |

### 2. Documentation des dommages subies

- G4-Global : impossible de démarrer le serveur global, les disque dur semblent en bon état. 
  Après étude, il semblerait que la mémoire RAM soit H.S.
  
  -  G4-AD-DS-CORE-01 / G4-AD-DS-CORE-02 : Serveur totalement H.S., on doit les remplacer.

  - Conteneur Wordpress : H.S., il a disparu. 
  
  - G4-Pfsense :  il démarre, mais il est hors réseau. 
Perte de la connexion internet sur tout le réseau. 
Les trois cartes réseaux sont H.S., il va donc falloir les remplacer

  - G4-SRV-GLPI :  il démarre, mais il est hors réseau. 
La carte réseau semble H.S., il va falloir la remplacer.


## B. Identification : 
### 1. Priorisation des services à rétablir en priorité

Au vu des soucis rencontrés, voilà la priorisation des actions que nous avons mis en place.

| Prirorité | Degré d'urgence |                                                        Action                                                         |
| :-------: | :-------------: | :-------------------------------------------------------------------------------------------------------------------: |
|     1     | Urgence Aboslue | Resécuriser notre infrastructure en remettant en marche le FireWall<br>Puis remettre en marche notre serveur principal |
|     2     |    Critique     |               Remonter deux serveurs Core pour la mise en place de la réplication et le partage de FSMO                |
|     3     |     Majeur      |                                          Remise en marche de la Messagerie interne                                          |
|     4     |     Mineur      |                             Remettre en fonction le serveur Web et  réparation RAID GLPI                              |

### 2. Listing des tâches pour chaque priorisation :

#### Priorité 1 :

G4-Pfsense :
- Remplacement des cartes réseaux défectueuses.
- Assignement des cartes réseaux sur les bonnes interfaces.
- Restauration de la dernière sauvegarde à jour des paramètres de PFsense.

G4-Global :
- Remplacement de la mémoire RAM H.S. pour retrouver la mémoire originale qui est de 10Go.

#### Priorité 2 : 

G4-AD-DS-CORE 01 ET G4-AD-DS-CORE 02  :
- Réinstallation et remontage complèt des deux serveurs.
- Réintégration des deux serveurs dans l'AD et en temps que contrôleur de domaines et en réplication.
- Partage des rôles FSMO.
- Se fier aux différents guides d'installation créés les semaines précédentes.

#### Priorité 3 :

G4-SRV-MAIL :
- Serveur Web plus accessible.
- Vérification état carte réseau.
- Remplacement barrettes de RAM défectueuses. (Normalement 4Go , mais seulement 2Go sont affichés)
- Reprise du Snapshot fait post installation.

#### Priorité 4 : 

Conteneur Wordpress : 
- Recréation complète de la page internet Wordpress

G4-SRV-GLPI : 
- Réparation du Raid 1
- Vérification que le service fonctionne toujours

## C. Réparation : 

En suivant les priorités définies et la façon de les réparer, tout a été traité en une journée.
Le 08 juillet au soir, tout était opérationnel et fonctionnel dans notre infrastructure.
Il était possible de créer des Ticket via GLPI, les serveur de messagerie interne était bien fonctionnel et le plus important : notre Active-Directory était bien en fonctionnement et l'accès internet était revenu pour chacun de nos poste.

Néanmoins il faudra surveiller tout cela, pour être sûrs qu'on ait pas raté des éléments.

## D. Documentation : 

Actuellement tout nos documents sont à jour, il faudra néanmoins penser à créer des documents pour expliquer comment sauvegarder et transférer les configurations et éléments important de notre infrastructure (Firewall, Serveur Mail, GLPI, Roteur ,.....).
