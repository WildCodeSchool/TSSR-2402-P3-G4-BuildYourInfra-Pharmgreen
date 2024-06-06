#!/bin/bash

# Fichier de configuration
fichier_config="config.txt"

# Sourcer le fichier de configuration
source "$fichier_config"

# Utilisation des variables importées
echo "Nom d'utilisateur: $db_user"
echo "Mot de passe: $db_pass"
echo "Nom de BDD: $db_name"

# Arrêter les services
systemctl stop apache2
systemctl stop php8.2-fpm
systemctl stop mariadb

# Supprimer la base de données MySQL
mysql -e "DROP DATABASE $db_name"
mysql -e "DROP USER $db_user@localhost"
mysql -e "FLUSH PRIVILEGES"

# Supprimer les fichiers de GLPI
rm -rf /var/www/glpi/
rm -rf /etc/glpi/
rm -rf /var/lib/glpi/
rm -rf /var/log/glpi/

# Supprimer les fichiers de configuration Apache pour GLPI
rm /etc/apache2/sites-available/support.pharmgreen.org.conf
a2dissite support.pharmgreen.org

# Redémarrer Apache
systemctl restart apache2

# Désinstaller les paquets installés
apt remove --purge php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu php-ldap php8.2-fpm apache2 php mariadb-server -y
apt autoremove -y
apt clean

# Message de confirmation
echo "GLPI et ses composants ont été désinstallés avec succès."
