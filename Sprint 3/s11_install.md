# Tuto Installation GLPI sur Debian 12

## Prérequis de GLPI

### Environnement
GLPI nécessite un serveur Web, PHP et une base de données. Pour notre exemple, nous utiliserons Debian 12 avec Apache2, PHP 8.3 et MariaDB.

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

`sudo apt-get update && sudo apt-get upgrade`

### Installer le socle LAMP
Le socle LAMP (Linux, Apache2, MariaDB, PHP) est essentiel pour faire fonctionner GLPI. Sous Debian 12, installez Apache2, PHP et MariaDB, ainsi que les extensions PHP nécessaires mentionnées ci-dessus.

`sudo apt-get install apache2 php mariadb-server`
### Sécuriser MariaDB
Effectuez les configurations de sécurité de base pour MariaDB, telles que le changement du mot de passe root et la désactivation de l'accès root à distance.

`sudo mysql_secure_installation`

### Créer une base de données pour GLPI
Entrez la commande suivante pour avoir accès à la configuration de mysql:
`sudo mysql -u root -p`

Puis entre le commande suivante pour édité la base de donné 

`CREATE DATABASE db23_glpi;`

`GRANT ALL PRIVILEGES ON db23_glpi.* TO glpi_adm@localhost IDENTIFIED BY "MotDePasseRobuste";`

`FLUSH PRIVILEGES;`
`EXIT;`
## Télécharger et installer GLPI

### Télécharger l'archive GLPI
Récupérez la dernière version de GLPI depuis le GitHub officiel 

`cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
`

Décompressez-la dans le répertoire approprié sur votre serveur.

`sudo tar -xzvf glpi-10.0.10.tgz -C /var/www/
`



### Configurer les permissions
Attribuez les permissions adéquates sur les fichiers et répertoires de GLPI pour l'utilisateur correspondant au serveur Web (www-data pour Apache2).

`sudo chown www-data /var/www/glpi/ -R
`

### Configurer les répertoires sécurisés
Créez et configurez les répertoires `/etc/glpi`, `/var/lib/glpi`, et `/var/log/glpi` pour stocker les fichiers de configuration, les fichiers de GLPI, et les journaux respectivement. Déplacez les dossiers "config" et "files" vers ces répertoires.

    sudo mkdir /etc/glpi
    sudo chown www-data /etc/glpi/
    sudo mv /var/www/glpi/config /etc/glpi

    sudo mkdir /var/lib/glpi
    sudo chown www-data /var/lib/glpi/
    sudo mv /var/www/glpi/files /var/lib/glpi

    sudo mkdir /var/log/glpi
    sudo chown www-data /var/log/glpi

### Créer les fichiers de configuration
Créez les fichiers de configuration nécessaires pour que GLPI puisse localiser ses données et ses journaux. Les fichiers de configuration doivent indiquer les nouveaux chemins vers les répertoires configurés précédemment.

`sudo nano /var/www/glpi/inc/downstream.php`"

Ajouter le contenu suivant :

    <?php
    define('GLPI_CONFIG_DIR', '/etc/glpi/');
    if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
        require_once GLPI_CONFIG_DIR . '/local_define.php';
        ?>


`sudo nano /etc/glpi/local_define.php`

Ajouter le contenu suivant :

    <?php
    define('GLPI_VAR_DIR', '/var/lib/glpi/files');
    define('GLPI_LOG_DIR', '/var/log/glpi');
    ?>

### Préparer la configuration Apache2
Créez un fichier de configuration Apache2 pour le VirtualHost dédié à GLPI. Configurez les règles de réécriture nécessaires et activez le site nouvellement créé tout en désactivant le site par défaut.

`sudo nano /etc/apache2/sites-available/pharmgreen.org.conf
`

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
    </VirtualHost>

### Utilisation de PHP-FPM avec Apache2
Si vous souhaitez utiliser PHP-FPM, installez et configurez-le pour Apache2. Activez les modules nécessaires et ajustez les paramètres de configuration PHP comme `session.cookie_httponly` pour renforcer la sécurité.

#### Activer les modules nécessaires dans Apache2

    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php8.2-fpm

#### Recharger la configuration Apache2
    sudo systemctl reload apache2

#### Configurer PHP-FPM pour Apache2
    sudo nano /etc/php/8.2/fpm/php.ini

Rechercher l'option session.cookie_httponly et la configurer ainsi :

    session.cookie_httponly = on


#### Redémarrer PHP-FPM

    sudo systemctl restart php8.2-fpm.service


#### Modifier le VirtualHost pour utiliser PHP-FPM

    sudo nano /etc/apache2/sites-available/pharmgreen.org.conf

Ajouter la configuration suivante dans le fichier VirtualHost :

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
    </FilesMatch>

## Finaliser l'installation

### Redémarrer les services
Après avoir configuré Apache2 et PHP-FPM, redémarrez les services pour appliquer les modifications. Assurez-vous que tout est correctement configuré avant de procéder à l'installation finale de GLPI via l'interface Web.

    sudo systemctl restart apache2

## Connexion au serveur

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




# liste GPO

## GPO default Domain Policy
 - chemin : `computer configuration/policies/Windows Settings/security settings/Account policies/Password policies`
    - Enforce password history : 2 password remembered
    - Maximum password age : 90 days
    - minimum password age : 30 days
    - minimum password length : 12 characters
    - Minimum password length audit : Not defined
    - Password must meet complexity requierements : Enabled
    - Relax minimum password length limits : Not defined
    - Store password using reversible encryption : disabled
- chemin : `computer configuration/policies/Windows Settings/security settings/Account policies/account lockout policies`
    - Account lockout duration : 10 min
    - Account lockout threshold : 5 invalid logon attempts
    - Allow Administrator account lockout : not defined
    - Reset account lockout counter after : 10 min


## GPO_Secu_Acces_Base_Registre
- chemin : `User configuration/Policies/administrative Templates/System/`
    - Prevent access to registry editing tools : enabled
        - Disable regedit from running silently : yes

## GPO_secu_Date_Time
- chemin : `Computer Configuration/Policies/Administrative Templates/system/windows Time Service/time providers`
    - Configure Windows NTP Client : enabled
        - NTPServer : pool.ntp.br,0x1 time1.google.com,0x1
        - Type : NTP
        - CrossSiteSyncFlags : 2
        - ResolvePeerBackoffMinutes : 15
        - ResolvePeerBackoffMaxTimes : 7
        - SpecialPollInterval : 3600
        - EventLogFlags : 0


## GPO secu_Ecran_veille_avec_password
- chemin : `User configuration/Policies/administrative template/control panel/Personlization`
    - Enable screen saver : Enabled
    - Force specific screen saver : Enabled
        - Screen saver executable name : %windir%\system32/rundl32.exe user32.dll,lockWorkStation
    - Password protect the screen saver : Enabled
    - Screen saver timeout : Enabled
        - Number of second to wait to enable the screen saver : 900

## GPO_panneaux_configuration
- chemin : `User Configuration/Administrative Template/Control Panel/Add or Remove Programs`
    - Hide Add New Programs page : Enabled
    - Hide the "Add a Program from CD-ROM or floppy disk" option : Enabled
    - Remove Add or Remove Program : Enabled
- chemin : `User Configuration/Administrative Template/Control Panel/Regional and Language Options`
    - Hide Regional and Language Options administrative options : Enabled

## GPO_Secu_peripheriques_amovibles
- chemin : `Computer Configuration/Policies/Administrative Templates/system/Removable Storage Access`
    - All Removable Storage classes : Deny all access : Enabled

## GPO_secu_Regle_par-feu
- chemin : `Computer Configuration/Policies/Administrative Templates/Windows Components/Windows Security/Firewall and network protection`
    - Hide the Firewall and network protection area : Enabled

## GPO_Secu_Restriction_Software
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies\Enforcement`
    - cocher la case All Users Except local administrators
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies\Designated Fyle type Properties`
    - ajouter les extension PAF et VBS
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies/Security Levels/ Basic User`
    - appliquer set as default
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restriction Policies/Additional Rules`
    - creer une nouvelles regles : %HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ProgramFilesDir%
        - security level : Unrestricted

## GPO_Secu_Verouillage_de_compte
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Account Policies/Account Lockout Policy`
    - Account lockout duration : 10 minutess
    - Account lockout threshold : 5 invalid logon attempts
    - Allow administrator account lockout : Enabled
    - Reset account lockout counter after : 10 minutes

## GPO_Std_Alimentation
- chemin : `Computer Configuration/Policies/Administrative Templates/System/Power Management/Sleep Settings`
    - Specify the system hibernate timeout (on battery) : Enabled
        - System Hibernate Timeout (seconds) : 3000
    - Specify the system sleep timeout (on battery) : Enabled
        - System Sleep Timeout (seconds) : 120
    - Specify the system sleep timeout (plugged in) : Enabled
        - System Sleep Timeout (seconds) : 2700
- chemin : `Computer Configuration/Policies/Administrative Templates/System/Power Management/Video and Display Settings`
    - Turn Off the Display (on battery) : Enabled
        - Turn Off the Dispplay (seconds) : 600
    - Turn off display (plugged in) : Enabled
        - Turn Off the Display (seconds) : 600

## GPO_Std_Dpl_7Zip
- chemin : `Computer Configuration/Policies/Software Settings`
    - faire new package ajouter l'instaleur de 7ZIP qui ce trouve dans \\\192.168.9.2\ressources

## GPO_Std_Dpl_Firefox
- chemin : `Computer Configuration/Policies/Software Settings`
    - faire new package ajouter l'instaleur de firefox qui ce trouve dans \\\192.168.9.2\ressources

## GPO_Std_Firefox_defaut
- chemin : `Computer Configuration/Policies/Administrative Templates/Windows Components/File Explorer`
    - Set a default associations configuration file : Enabled
        - Default Associations Configuration File : \\\192.168.9.2\Ressources\firefox.xml

## GPO_Std_Imprimantes
- chemin : `Computer Configuration/Policies/AAdministrative Templates/Printers`
    - Package Point and print - Approved Servers : Enabled
    - Point and print Restrictions : Enabled
- chemin : `Computer Configuration/Policies/AAdministrative Templates/System/Driver Installation`
    - Allow non-administrators to install drivers for these device setup classes : Enabled

## GPO_Std_Parametres_Firefox
- chemin : `Computer Configuration/Policies/Administrative Templates/Mozilla/Firefox/Addons`
    - Allow add-on installs from websites : Disabled
- chemin : `Computer Configuration/Policies/Administrative Templates/Mozilla/Firefox/Home`
    - Show Home button on toolbar : Enabled
    - Start Page : Enabled
    - URL for Home page : Enabled
        - URL : http://www.google.fr/
        - Don't allow the homepage to be changed : Enabled

## GPO_Std_Restriction_Edge
- chemin : `Computer Configuration/Policies/Windows Settings/Security Settings/Software Restrictions Policies/Security levels/Additional Rules`
    - ajouter une regle de securité : C:\Prograam FIles(x86)\Microsoft\Edge
        - security level : Disalowed

## GPO_Std_Wallpaper
- chemin : `User Configuration/Policies/Administrative Templates/Desktop/Desktop`
    - Desktop Wallpaper : Enabled
        - Wallpaper Name : \\\192.168.9.2\Ressources\logo.png
        - Wallpaper Style : center

