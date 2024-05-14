### Informations du Serveur

- **Nom de l’hôte serveur**: AD-DS
- **Compte**: Administrator
- **Mot de passe**: Azerty1*
- **IPv4**: 192.168.9.3
- **DNS**: 192.168.9.2
- **Version**: Windows Server Core 2022
- Mises à jour de sécurité : appliquées
- Pare-feu : désactivé 

#### 1. Installation de AD DS (Active Directory Domain Services)

- Connectez vous sur le serveur AD-DS avec le compte Administrator.
- Vous allez arriver sur un écran comme celui-ci

- Entrez "15" pour passer en lignes de commandes (PowerShell)
- Exécutez les commandes suivantes : 
	- `Add-WindowsFeature -Name "RSAT-AD-Tools" -IncludeManagementTools -IncludeAllSubFeature
	- `Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature`
	- `Add-WindowsFeature -Name "DNS" -IncludeManagementTools -IncludeAllSubFeature`
Vous verrez une barre de progression comme celle-ci pour les 3 commandes :

- Fermez la fenêtre afin de revenir à l'écran précédent avec toutes les propositions.

#### 2. Définition d'une adresse IP statique

Nous allons d'abord définir l'adresse IP :
- Sur l'écran de sélection, entrez "8" pour aller dans les paramètres réseau
- Sélectionnez la carte réseau (ici il n'y en a qu'une, donc entrez "1")
- Entrez de nouveau "1" pour indiquer la nouvelle configuration réseau
- Entrez "s" pour définir une adresse IP statique
- Indiquez l'adresse souhaitée (ici 192.168.9.3)
- Faites "Entrée" si vous souhaites que le masque soit de base en 255.255.255.0
- Entrez une passerelle par défaut (ici ce sera 192.168.9.254)
- Appuyez sur "Entrée"

Et maintenant le DNS :
- Appuyez sur "8" pour retourner dans les paramètres réseau 
- Sur "1" pour choisir l'interface
- Puis sur "2" pour configurer le DNS
- Entrez l'adresse souhaitée (ici ce sera 192.168.9.2 qui est l'adresse du serveur AD principal)
- Faites "Entrée" si vous ne souhaites pas de DNS secondaire
- De nouveau "Entrée"

Vous aurez à la fin quelque chose qui ressemble à ceci 

#### 3. Ajout du Server Core au Domaine

- Sur l'écran principal, faites "1"
- Entrez ensuite "D"
- Indiquez votre domaine (ici pharmgreen.org)
- Indiquez ensuite l'utilisateur autorisé (ici pharmgreen.org\administrator)
- Ainsi que le mot de passe (Azerty1*)

Vous aurez alors un message de bienvenue dans le domaine sélectionné et quand vous retournez au menu principal :
