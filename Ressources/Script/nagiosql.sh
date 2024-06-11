#!/bin/bash

# Mettre à jour les paquets et installer les dépendances nécessaires
apt-get update
apt-get install -y wget apache2 php php-mysql libapache2-mod-php php-pear php-cgi php-cli php-xml php-gettext unzip

# Télécharger et installer NagiosQL
wget https://sourceforge.net/projects/nagiosql/files/nagiosql/NagiosQL%203.4.1/nagiosql-3.4.1.tar.gz/download -O nagiosql.tar.gz
tar -xzf nagiosql.tar.gz
mv nagiosql-3.4.1 /usr/local/nagiosql
rm nagiosql.tar.gz

# Configurer Apache pour NagiosQL
cp /usr/local/nagiosql/install/config/nagiosql.conf /etc/apache2/sites-available/
a2ensite nagiosql.conf
a2enmod rewrite
service apache2 restart

# Définir les permissions
chown -R www-data:www-data /usr/local/nagiosql

echo "NagiosQL a été installé avec succès. Accédez à NagiosQL via http://localhost/nagiosql"
