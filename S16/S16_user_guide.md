# Sommaire

1. Utilisation Windows Server Update Services

# 1. Utilisation Windows Server Update Services

## 1.  Prise en main de la console  

Il y a plusieurs options et sous menu accessible dans la console de management de WSUS.  
On peut y accéder de différents façon soit depuis le menu démarrer en tapant `Windows Serveur Updates Services` soit via le **Serveur Manager** et menu **Tools**.  
Une fois ouverte la console ressemble à cela :  
![1](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/419b03ef-d6a5-4721-a7fb-aaad4a07c650)

### Updates  

La section **Updates** offre la possibilité de visualiser l’ensemble des mises à jour synchronisées, avec pour chacune d’elle, diverses informations ).  
C’est sans doute la section la plus complète de la console. C’est également ici que l’on approuve et refuse des mises à jour.  
![2](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/e02745c5-142e-4c42-bd12-bd1eb17aa1b5)  
De base on à ces quatre vues déjà créées  :

    All Updates : l’intégralité des mises à jour synchronisées, sans filtre
    Critical Updates : les mises à jour critiques uniquement
    Security Updates : les mises à jour de sécurité uniquement
    WSUS Updates : les mises à jour de WSUS en lui-même

Mais on peut par exemple créér, une vue spécifique pour les mises à jour de Windows 10 et cela de façon très simple.
- En faisant un clique droit sur **Updates** et en choisissant `New update view`, on arrive sur la fenêtre suivante : 
![3](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/75b6c0d3-5be6-4ea0-892c-f282c17e61a8)  
- On peut faire la configuration suivante :  
![4](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/4aeda643-32d8-441b-9d99-530b1abada30)  
- On laisse la première ligne en `any classificaiton` ce qui permet de récupérer tout type de mise à jour et dans la seconde ligne on choisit juste ce qui est en rapport avec **Windows 10**
- Une nouvelle vue d'alarmes à bien été créée :  
![5](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/a9f38ab2-d467-4850-87fd-807a71351244)  
- Si on clique dessus on peut alors voir les mises à jour qui ont été filtrés grâce à cette nouvelle vue :  
![6](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/4e25baeb-c6a2-4b27-9c59-a576e69a9640)

Sur chaque vue, il est possible d'affiner le filtrage :
- Approval : permets d’afficher toutes les mises à jour non approuvées, approuvées ou refusées
- Status : Permets d’afficher toutes les mises à jour en échec, installées, non applicables, ou encore nécessaires
Chaque fois que vous modifier un de ces deux filtes, il faut ensuite faire un `Refresh` de la vue.
- De plus il est possible d'ajouter des colonnes dans le but d'affiner la classification et d'améliorer la visibilité il est conseillé d'ajouter les colonnes suivantes :
    ```
    Installation Status : la mise à jour est-elle installée ou non sur les machines
    File Status : le fichier est-il téléchargé en local ou non ? La mise à jour peut être synchronisée sur le serveur, mais les sources d’installation pas encore téléchargées en local. De la même façon, si une mise à jour est      en cours de téléchargement, ce sera précisé ici.
    Supersedence : permet de savoir si cette mise à jour est remplacée par une autre mise à jour plus récente, ou si cette mise à jour remplace une autre mise à jour, ou ni l’un ni l’autre
    Arrival date : date à laquelle le serveur a synchronisé cette mise à jour
    ```
- Pour ajouter ou retirer des colonnes, il suffit d’effectuer un clic droit sur l’en-tête des colonnes puis de faire son choix.

### Computers  

La section **Computers** permet de visualiser les ordinateurs rattachés au serveur WSUS, et pour chaque machine nous pouvons visualiser son état, ainsi que les mises à jour dont il a besoin.  
Que ce soit les postes de travail ou les serveurs, ils seront visibles dans la section « Ordinateurs » de la console WSUS.
Par défaut, une machine qui se connecte au serveur WSUS pour la première fois va être intégrée au groupe « Ordinateurs non attribués ».

### Downstream Servers

La section **Downstream Servers** est relative à la hiérarchie de serveurs WSUS puisqu’il est possible d’avoir plusieurs serveurs WSUS qui se synchronisent, ou d’instaurer des relations hiérarchiques.  
Nous pouvons imaginer une infrastructure avec un serveur WSUS central puis des serveurs WSUS « secondaires » qui sont présents sur les différents sites de l’entreprise, dans notre cas cela n'est pas prévu donc on ne détaillera pas cette section.

### Synchronizations 

La section **Synchronizations** permet de visualiser l’historique des synchronisations avec plusieurs informations associées à chaque tâche :

    La date et l’heure de démarrage de la tâche
    Le type de tâche (planifiée ou manuelle)
    Le résultat de la tâche (succès, en cours, échec)
    Le nombre de nouvelles mises à jour synchronisées
    Le nombre de mises à jour révisées
    Le nombre de mises à jour expirées

Bien sûr, il n’y aura pas de nouvelles mises à jour tous les jours puisqu’en temps normal, Microsoft publie des mises à jour une fois par mois, à l’occasion du Patch Tuesday. Ces nouvelles mises à jour sont publiées le deuxième mardi de chaque mois.

### Reports 

La section **Reports** va permettre, sans surprise, de générer des rapports sur l’état global de votre serveur WSUS.  
Plus précisément, vous pouvez générer des rapports pour obtenir l’état des mises à jour, mais aussi l’état des ordinateurs, avec plus ou moins de détails.  
En fait, il y a le choix entre des rapports de synthèse et des rapports détaillés.

### Options 

La section **Option** est très complet puisqu’il va permettre de paramétrer le serveur WSUS en lui-même, et notamment réviser les paramètres définis lors de la configuration initiale.  
Autrement dit, cette section va permettre de gérer les produits à synchroniser, mais aussi les langues et les types de mises à jour, ainsi que les règles d’approbations automatiques (par exemple : « approuver automatiquement toutes les mises à jour de sécurité pour Windows 10 »).
Lorsque l’on cherche à faire du nettoyage dans la base WSUS, c’est également ici qu’il faut se rendre grâce au **Server Cleanup Wizard**.
Comme dit précédemment on peut affiner les règles d'approbations, pour cela il suffit de cliquer sur **Automatic Approvals**.
Par défaut, il y a une règle qui est configurée pour approuver automatiquement toutes les mises à jour critiques et toutes les mises à jour de sécurité, pour le groupe **All Computers**.   
Pour activer cette règle, il faut cocher la case et cliquer sur le bouton `Run Rule`.
Vous pouvez créer vos propres règles pour approuver les mises à jour correspondant à certains produits spécifiques ou uniquement certains groupes.
C’est une fonctionnalité très intéressante, car elle facilite le processus d’approbation des mises à jour grâce à l’approbation automatique selon certains critères.
