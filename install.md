## Fichier install.md
### Informations du Serveur

- **Nom de l’hôte serveur**: SRV-GLOBAL-LYON
- **Compte**: Administrator
- **Mot de passe**: Azerty1*
- **IPv4**: 172.14.3.4
- **DNS**: pharmgreen.org
- **Version**: Windows Server 2022



### Étapes d'Installation
#### 1. Préparation de l'Environnement

- Vérifiez que les deux machines (serveur et client) sont mises à jour avec les derniers patches de sécurité.
- Assurez-vous que les deux machines peuvent se connecter entre elles via le réseau.

#### 2. Installation de AD DS (Active Directory Domain Services)

- Connectez-vous sur le serveur SRV-GLOBAL-LYON avec le compte Administrator.
- Ouvrez le 'Server Manager', puis cliquez sur 'Add roles and features' (Ajouter des rôles et fonctionnalités).
- Sur le type d’installation, sélectionnez 'Role-based or feature-based installation' (Installation basée sur un rôle ou une fonctionnalité).
- Choisissez le serveur SRV-GLOBAL-LYON de la liste des serveurs.
- Sélectionnez 'Active Directory Domain Services' dans la liste des rôles de serveur, puis cliquez sur 'Next' (Suivant).
- Suivez les instructions pour ajouter les fonctionnalités nécessaires qui sont suggérées automatiquement.
- Confirmez l’installation des services AD DS en cliquant sur 'Install' (Installer).
- Une fois l’installation terminée, cliquez sur 'Promote this server to a domain controller' (Promouvoir ce serveur en contrôleur de domaine) pour configurer AD DS.

#### 3. Installation et Configuration de DNS

- Lors de la promotion du serveur en contrôleur de domaine, vous aurez l’option d’installer et configurer le serveur DNS.
- Choisissez de créer une nouvelle zone de recherche directe pour pharmgreen.org.
- Suivez les étapes pour configurer la zone DNS, y compris la mise en place de l'enregistrement SOA (Start of Authority) et les enregistrements.ns nécessaires.

#### 4. Installation et Configuration de DHCP

- Retournez au 'Server Manager', puis sélectionnez 'Add roles and features' (Ajouter des rôles et fonctionnalités).
- Sélectionnez 'DHCP Server' dans la liste des rôles et suivez les étapes pour l'installer.
- Après l'installation, utilisez 'Complete DHCP configuration' (Compléter la configuration DHCP) pour configurer le serveur DHCP.
- Définissez l'étendue de DHCP pour distribuer les adresses IP automatiquement dans le réseau, incluant les adresses pour SRV-GLOBAL-LYON et PC-PI-0001.

### Informations du Client

- **Nom de l’hôte client**: PC-PI-0001
- **Compte**: wilder
- **Mot de passe**: Azerty1*
- **IPv4**: 172.14.3.5
- **DNS**: pharmgreen.org
- **Version**: Windows Server 2022

Prérequis
- Mises à jour de sécurité : Appliquées sur les deux machines.
- Connectivité réseau : Vérifiée entre serveur et client.
- Pare-feu : Désactivé sur les deux machines.
- Plage d'adresse IP : Identique pour serveur et client.

#### Étape 1 : Connectez le PC client au réseau

- Configuration réseau : Assurez-vous que le PC client (PC-PI-0001) est configuré avec une adresse IP fixe ou qu'il reçoit une adresse via DHCP dans la même sous-réseau que le serveur (SRV-GLOBAL-LYON).

#### Étape 2 : Vérification de la connectivité

- Test Ping : Depuis le PC client, ouvrez l'invite de commande et exécutez ping 172.14.3.4 pour vérifier la connectivité avec le serveur.

#### Étape 3 : Joindre le domaine

- Ouvrir les Paramètres Windows : Sur le PC client, allez dans Paramètres > Système > À propos et cliquez sur Paramètres avancés du système.

- Modifier les Paramètres Système : Cliquez sur l'onglet Nom de l’ordinateur, puis sur le bouton Modifier....

- Joindre le domaine : Sélectionnez l'option Domaine, et entrez le nom de domaine pharmgreen.org.

- Crédentials Administrateur : Entrez le nom d'utilisateur et le mot de passe de l'administrateur du domaine lorsque vous y êtes invité.

- Redémarrage requis : Après avoir cliqué sur OK, un message vous invitera à redémarrer l'ordinateur pour appliquer les changements. Redémarrez le PC client.

#### Étape 4 : Vérification de l'appartenance au domaine

- Connexion au Domaine : Après le redémarrage, assurez-vous de vous connecter avec un compte utilisateur qui est autorisé sur le domaine.
- Vérifier l'appartenance au domaine : Vous pouvez vérifier que le PC est bien ajouté au domaine en ouvrant de nouveau Paramètres > Système > À propos et en consultant le nom du groupe de travail/domaine.
