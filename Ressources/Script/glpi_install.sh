#!/bin/bash

#Fichier de configuration
fichier_config="config.txt"

#Sourcer le fichier de configuration
source "$fichier_config"

#Utilisation des variables importées
echo "Nom d'utilisateur: $db_user"
echo "Mot de passe: $db_pass"
echo "Nom de BDD: $db_name"

# Installation des paquets nécessaires
apt update && apt upgrade -y
apt install php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu -y
apt install apache2 php mariadb-server -y
apt install php-ldap -y

# Sécurisation de l'installation MariaDB
#mysql_secure_installation

# Création de la base de données MySQL
mysql -e "CREATE DATABASE $db_name"
mysql -e "GRANT ALL PRIVILEGES ON $db_name.* TO $db_user@localhost IDENTIFIED BY $db_pass"
mysql -e "FLUSH PRIVILEGES"

# Télécharger et extraire GLPI
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz
tar -xzvf glpi-10.0.15.tgz -C /var/www/

# Attribuer les permissions
chown www-data /var/www/glpi/ -R

# Création des dossiers nécessaires
mkdir /etc/glpi
chown www-data /etc/glpi/
mv /var/www/glpi/config /etc/glpi

mkdir /var/lib/glpi
chown www-data /var/lib/glpi/
mv /var/www/glpi/files /var/lib/glpi

mkdir /var/log/glpi
chown www-data /var/log/glpi

# Création des fichiers de configuration PHP
touch /var/www/glpi/inc/downstream.php
cat > /var/www/glpi/inc/downstream.php <<EOF
<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
    require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOF

touch /etc/glpi/local_define.php
cat > /etc/glpi/local_define.php <<EOF
<?php
define('GLPI_VAR_DIR', '/var/lib/glpi/files');
define('GLPI_LOG_DIR', '/var/log/glpi');
EOF

# Configuration Apache2 pour GLPI
touch /etc/apache2/sites-available/support.pharmgreen.org.conf
cat > /etc/apache2/sites-available/support.pharmgreen.org.conf <<EOF
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
EOF

# Activer le site GLPI et modules Apache
a2ensite support.pharmgreen.org
a2dissite 000-default.conf
a2enmod rewrite

# Redémarrer Apache
systemctl restart apache2

# Installation et configuration de PHP-FPM
apt-get install php8.2-fpm -y
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm
sudo systemctl reload apache2
sed -i 's/^\(session\.cookie_httponly\s*=\s*\).*/\1on/' /etc/php/8.2/fpm/php.ini

# Redémarrer PHP-FPM et Apache
systemctl restart php8.2-fpm.service
sudo systemctl restart apache2
