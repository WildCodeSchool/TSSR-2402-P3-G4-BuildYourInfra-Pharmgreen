#!/bin/bash

# Vérifier si l'utilisateur a les droits d'administration
if [ "$(id -u)" -ne 0 ]; then
    echo "Erreur : veuillez exécuter ce script en tant qu'utilisateur root ou avec sudo."
    exit 1
fi

# Fonction pour installer GNOME
function install_gnome() {
    echo "Installation de l'environnement de bureau GNOME..."
    apt-get update
    apt-get install -y gnome-shell gdm3
    systemctl enable gdm3
    echo "GNOME a été installé avec succès !"
}

# Fonction pour désactiver GNOME
function disable_gnome() {
    echo "Désactivation de l'environnement de bureau GNOME..."
    systemctl disable gdm3
    echo "GNOME a été désactivé avec succès !"
}

# Vérifier si GNOME est déjà installé
if dpkg -s gnome-shell gdm3 > /dev/null 2>&1; then
    echo "GNOME est déjà installé sur votre système."
    read -p "Voulez-vous le désactiver ? (o/n) " answer
    if [ "$answer" = "o" ] || [ "$answer" = "O" ]; then
        disable_gnome
    fi
else
    read -p "Voulez-vous installer l'environnement de bureau GNOME ? (o/n) " answer
    if [ "$answer" = "o" ] || [ "$answer" = "O" ]; then
        install_gnome
    fi
fi
