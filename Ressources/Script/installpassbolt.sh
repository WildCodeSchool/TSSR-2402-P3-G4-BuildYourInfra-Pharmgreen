#!/bin/bash

# Prérequis
apt update && apt upgrade -y
apt install -y curl

# Demande du nom de domaine
read -p "Entrez votre nom de domaine (par exemple, example.com): " DOMAIN

# Installation des dépendances
curl -LO https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh
curl -LO https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt

sha512sum -c passbolt-ce-SHA512SUM.txt && bash ./passbolt-repo-setup.ce.sh || { echo "Bad checksum. Aborting"; rm -f passbolt-repo-setup.ce.sh; exit 1; }

# Installation de Passbolt
apt install -y passbolt-ce-server

# Configuration de MariaDB
mysql -e "CREATE DATABASE passbolt;"
mysql -e "CREATE USER 'passboltuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON passbolt.* TO 'passboltuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Configuration de Nginx et SSL
apt install -y nginx
apt install -y certbot python3-certbot-nginx
certbot --nginx -d $DOMAIN

echo "Installation de Passbolt terminée. Veuillez compléter la configuration via l'interface web."
