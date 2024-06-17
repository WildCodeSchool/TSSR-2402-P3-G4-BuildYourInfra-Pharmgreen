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
