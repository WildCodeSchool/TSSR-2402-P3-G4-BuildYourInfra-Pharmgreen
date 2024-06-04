#!/bin/bash

# Vérifier si l'utilisateur est un administrateur
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté par un utilisateur ayant des droits d'administration."
    exit 1
fi

# Installer mdadm
echo "Installation de mdadm en cours..."
apt-get install mdadm -y &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : L'installation de mdadm a échoué."
    exit 1
fi
echo "mdadm a été installé avec succès."

# Vérifier le statut du RAID
echo "Vérification du statut du RAID en cours..."
cat /proc/mdstat &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Impossible de lire le statut du RAID."
    exit 1
fi
echo "Le statut du RAID a été vérifié avec succès."

# Préparer le second disque dur
echo "Préparation du second disque dur en cours..."

# Cloner la table des partitions
echo "Clonage de la table des partitions en cours..."
sfdisk -d /dev/sda | sfdisk /dev/sdb &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Le clonage de la table des partitions a échoué."
    exit 1
fi
echo "La table des partitions a été clonée avec succès."

# Vérifier les partitions
echo "Vérification des partitions en cours..."
fdisk -l &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Impossible de lire les informations sur les partitions."
    exit 1
fi
echo "Les partitions ont été vérifiées avec succès."

# Changer le type des partitions (sdb)
echo "Changement du type des partitions en cours..."

# Partition 1
echo "Changement du type de la partition 1 en cours..."
fdisk /dev/sdb <<< "t\n1\nfd\nw\n" &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Le changement du type de la partition 1 a échoué."
    exit 1
fi
echo "Le type de la partition 1 a été changé avec succès."

# Partition 2
echo "Changement du type de la partition 2 en cours..."
fdisk /dev/sdb <<< "t\n2\nfd\nw\n" &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Le changement du type de la partition 2 a échoué."
    exit 1
fi
echo "Le type de la partition 2 a été changé avec succès."

# Partition 3
echo "Changement du type de la partition 3 en cours..."
fdisk /dev/sdb <<< "t\n3\nfd\nw\n" &> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Erreur : Le changement du type de la partition 3 a échoué."
    exit 1
fi
echo "Le type de la partition 3 a été changé avec succès."

# Vérifier les partitions
echo "Vérification des partitions en cours..."
fdisk -l &> /dev/null
