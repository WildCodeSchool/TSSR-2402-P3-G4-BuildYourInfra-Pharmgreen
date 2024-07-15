
# Sommaire Interactif

## [Prérequis Général](#prérequis-général)

## [Prérequis GPO](#prérequis-gpo)

## [Tuto Installation GLPI sur Debian 12](#tuto-installation-glpi-sur-debian-12)
### [Prérequis de GLPI](#prérequis-de-glpi)
- [Environnement](#environnement)
- [Versions requises](#versions-requises)
- [Extensions PHP nécessaires](#extensions-php-nécessaires)

### [Préparer le serveur pour installer GLPI](#préparer-le-serveur-pour-installer-glpi)
- [Mise à jour des paquets](#mise-à-jour-des-paquets)
- [Installer le socle LAMP](#installer-le-socle-lamp)
- [Sécuriser MariaDB](#sécuriser-mariadb)
- [Créer une base de données pour GLPI](#créer-une-base-de-données-pour-glpi)

### [Télécharger et installer GLPI](#télécharger-et-installer-glpi)
- [Télécharger l'archive GLPI](#télécharger-larchive-glpi)
- [Configurer les permissions](#configurer-les-permissions)
- [Configurer les répertoires sécurisés](#configurer-les-répertoires-sécurisés)
- [Créer les fichiers de configuration](#créer-les-fichiers-de-configuration)

### [Préparer la configuration Apache2](#préparer-la-configuration-apache2)
- [Activer le site GLPI et les modules Apache nécessaires](#activer-le-site-glpi-et-les-modules-apache-nécessaires)
- [Recharger la configuration Apache2](#recharger-la-configuration-apache2)

### [Installer et configurer PHP-FPM](#installer-et-configurer-php-fpm)
- [Configurer PHP-FPM pour Apache2](#configurer-php-fpm-pour-apache2)
- [Redémarrer PHP-FPM](#redémarrer-php-fpm)

### [Finaliser l'installation](#finaliser-linstallation)
- [Redémarrer les services](#redémarrer-les-services)
- [Connexion au serveur](#connexion-au-serveur)

## [Installation de GLPI Agent](#installation-de-glpi-agent)
### [Pour Debian](#pour-debian)
### [Pour Windows](#pour-windows)
## Prérequis Général 

- **Adresse IP de réseau** : 192.168.9.0/24 
- **Adresse de passerelle** : 192.168.9.254
- **Adresse IP DNS** : 192.168.9.2

## Prérequis GPO

Sur le serveur principal, créer un dossier **Ressources** sous `C:\` , le configurer en tant que dossier partagé (qui sera ensuite accessible via cette adresse : `\\192.168.9.2\Ressources\` )
Recupérer les installations des logiciels et fichier suivants :
- **Firefox** :  Aller sur le lien suivant https://www.mozilla.org/fr/firefox/enterprise/#download et télécharger l'installateur **Firefox ESR installteur MSI**. 
- **7-Zip** :  Télécharger le logiciel grâce au lien suivant https://www.7-zip.org/a/7z2405-x64.msi .
- **Fond D'écran** : Récupérer le logo situé ici https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/logo.png .
- **Navigateur par défaut**: Récupérer le fichier XML mis à dispo ici : https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/blob/main/Ressources/firefox.xml .
Et ensuite placer le tout dans le dossier du serveur préalablement créé `C:\Ressources\`

# Tuto Installation GLPI sur Debian 12

## Prérequis de GLPI

### Environnement

GLPI nécessite un serveur Web, PHP et une base de données. Pour notre exemple, nous utiliserons Debian 12 avec Apache2, PHP 8.2 et MariaDB.

### Versions requises

- **PHP** : Minimum 7.4 (non supporté), Maximum 8.2
- **Base de données** : MySQL 5.1 minimum, MariaDB 10.2 minimum

### Extensions PHP nécessaires

Les extensions suivantes doivent être installées pour le bon fonctionnement de GLPI :

- php-xml
- php-common
- php-json
- php-mysql
- php-mbstring
- php-curl
- php-gd
- php-intl
- php-zip
- php-bz2
- php-imap
- php-apcu

## Préparer le serveur pour installer GLPI

### Mise à jour des paquets

Avant d'installer les paquets nécessaires, assurez-vous que votre système est à jour.

    sudo apt-get update && sudo apt-get upgrade -y

### Installer le socle LAMP

Le socle LAMP (Linux, Apache2, MariaDB, PHP) est essentiel pour faire fonctionner GLPI. Sous Debian 12, installer Apache2, PHP et MariaDB, ainsi que les extensions PHP nécessaires mentionnées ci-dessous.
    
    sudo apt-get install -y apache2 php mariadb-server php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu

### Sécuriser MariaDB

Effectuer les configurations de sécurité de base pour MariaDB, telles que le changement du mot de passe root et la désactivation de l'accès root à distance.

    sudo mysql_secure_installation

### Créer une base de données pour GLPI

Entrer la commande suivante pour avoir accès à la configuration de mysql :

    sudo mysql -u root -p

Puis entrer les commandes suivantes pour créer et configurer la base de données :
    
    CREATE DATABASE db23_glpi;
    GRANT ALL PRIVILEGES ON db23_glpi.* TO 'glpi_adm'@'localhost' IDENTIFIED BY 'MotDePasseRobuste';
    FLUSH PRIVILEGES;
    EXIT;

## Télécharger et installer GLPI

### Télécharger l'archive GLPI

Récupérer la dernière version de GLPI depuis le GitHub officiel

    cd /tmp
    wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz

Décompressez-la dans le répertoire approprié sur votre serveur.

    sudo tar -xzvf glpi-10.0.15.tgz -C /var/www/

### Configurer les permissions

Attribuer les permissions adéquates sur les fichiers et répertoires de GLPI pour l'utilisateur correspondant au serveur Web (www-data pour Apache2).

    sudo chown www-data:www-data /var/www/glpi/ -R

### Configurer les répertoires sécurisés

Créer et configurer les répertoires /etc/glpi, /var/lib/glpi, et /var/log/glpi pour stocker les fichiers de configuration, les fichiers de GLPI, et les journaux respectivement. Ensuite, déplacer les dossiers "config" et "files" vers ces répertoires.
    
    sudo mkdir /etc/glpi
    sudo chown www-data:www-data /etc/glpi/
    sudo mv /var/www/glpi/config /etc/glpi

    sudo mkdir /var/lib/glpi
    sudo chown www-data:www-data /var/lib/glpi/
    sudo mv /var/www/glpi/files /var/lib/glpi

    sudo mkdir /var/log/glpi
    sudo chown www-data:www-data /var/log/glpi

### Créer les fichiers de configuration

Créer les fichiers de configuration nécessaires pour que GLPI puisse localiser ses données et ses journaux. Les fichiers de configuration doivent indiquer les nouveaux chemins vers les répertoires configurés précédemment.

    sudo nano /var/www/glpi/inc/downstream.php

Ajouter le contenu suivant :
    
    <?php
    define('GLPI_CONFIG_DIR', '/etc/glpi/');
    if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
        require_once GLPI_CONFIG_DIR . '/local_define.php';
    }
    ?>

    
    sudo nano /etc/glpi/local_define.php

Ajouter le contenu suivant :

    <?php
    define('GLPI_VAR_DIR', '/var/lib/glpi/files');
    define('GLPI_LOG_DIR', '/var/log/glpi');
    ?>

### Préparer la configuration Apache2

Créer un fichier de configuration Apache2 pour le VirtualHost dédié à GLPI. Configurez les règles de réécriture nécessaires et activez le site nouvellement créé tout en désactivant le site par défaut.

    sudo nano /etc/apache2/sites-available/pharmgreen.org.conf

Ajouter la configuration suivante :

    <VirtualHost *:80>
        ServerName pharmgreen.org

        DocumentRoot /var/www/glpi/public

        <Directory /var/www/glpi/public>
            Require all granted

            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ index.php [QSA,L]
        </Directory>
        <FilesMatch \.php$>
            SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
        </FilesMatch>
    </VirtualHost>

### Activer le site GLPI et les modules Apache nécessaires

    sudo a2ensite pharmgreen.org.conf
    sudo a2dissite 000-default.conf
    sudo a2enmod rewrite

### Recharger la configuration Apache2
    
    sudo systemctl reload apache2

## Installer et configurer PHP-FPM

Si vous souhaitez utiliser PHP-FPM, installez et configurez-le pour Apache2. Activez les modules nécessaires et ajustez les paramètres de configuration PHP comme session.cookie_httponly pour renforcer la sécurité.

    sudo apt-get install -y php8.2-fpm
    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php8.2-fpm
    sudo systemctl reload apache2

### Configurer PHP-FPM pour Apache2

Ouvrir le fichier de configuration PHP-FPM et modifiez l'option session.cookie_httponly :

    sudo nano /etc/php/8.2/fpm/php.ini

Rechercher l'option session.cookie_httponly et la configurer ainsi :

    session.cookie_httponly = on

### Redémarrer PHP-FPM

    sudo systemctl restart php8.2-fpm.service

## Finaliser l'installation

### Redémarrer les services

Après avoir configuré Apache2 et PHP-FPM, il faut redémarrer les services pour appliquer les modifications. Assurez-vous que tout est correctement configuré avant de procéder à l'installation finale de GLPI via l'interface Web.
    
    sudo systemctl restart apache2

### Connexion au serveur

Pour finaliser l'installation, connectez-vous à votre serveur et suivez les consignes indiquées sur la page web du serveur GLPI à l'adresse suivante :

    http://adresse-ip-du-serveur/

Si vous avez des questions ou rencontrez des problèmes, consultez la documentation.

Afin d'inventorier les machines présentes sur le domaine, il faut installer glpi-agent sur chaque machine : 

# Installation de GLPI Agent

## Pour Debian :

`wget https://github.com/glpi-project/glpi-agent/releases/download/1.8/glpi-agent-1.8-linux-installer.pl`

Ensuite celle-ci : 

`perl glpi-agent-1.8-linux-installer.pl` 

## Pour Windows :

Veuillez suivre les étapes suivantes pour l'installation de GLPI Agent sur les machines Windows :

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/cd22e6b0-1211-4639-8f53-6c1a5c48f1c6)

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/f1a35812-2ae6-443e-915d-63ee6bce6fd4)

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/1cc2b7ff-ed27-404b-9d4a-6971860e1b6f)

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/5b014c34-2614-46ce-9323-2f1b00cce751)

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/6908e942-ed36-43ec-adf5-0b286c41ec46)

Renseigner l'adresse de votre serveur GLPI (ici `http://192.168.9.6`), 2 fois `Entrée`.

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/c1d71deb-f703-4b46-bcd9-68fd3a1ffc52)

![](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/159529274/e7362f2e-ca6e-41d9-bd11-09e742e474e5)

Cliquer sur `Next` jusqu'à arriver à `Install`.
