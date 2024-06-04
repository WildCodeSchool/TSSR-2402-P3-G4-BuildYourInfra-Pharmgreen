#!/bin/bash

# Installation de mdadm
apt-get update
apt-get install -y mdadm

# Vérification de l'installation de mdadm
if [ $? -eq 0 ]; then
    echo "mdadm a été installé avec succès"
else
    echo "Erreur lors de l'installation de mdadm"
    exit 1
fi

# Copie du schéma de partitionnement du disque original sur le nouveau disque
sfdisk -d /dev/sda | sfdisk /dev/sdb

# Vérification de la copie du schéma de partitionnement
if [ $? -eq 0 ]; then
    echo "Le schéma de partitionnement a été copié avec succès"
else
    echo "Erreur lors de la copie du schéma de partitionnement"
    exit 1
fi

# Changement du type des partitions sur le nouveau disque pour "fd" (raid auto-detect)
fdisk /dev/sdb << EOF
t
1
fd
t
2
fd
w
EOF

# Vérification du changement du type des partitions
if [ $? -eq 0 ]; alors
    echo "Le type des partitions a été changé avec succès"
else
    echo "Erreur lors du changement du type des partitions"
    exit 1
fi

# Création du volume raid1
mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb1
mdadm --create /dev/md1 --level=1 --raid-devices=2 missing /dev/sdb2

# Vérification de la création du volume raid1
if [ $? -eq 0 ]; alors
    echo "Le volume raid1 a été créé avec succès"
else
    echo "Erreur lors de la création du volume raid1"
    exit 1
fi

# Création des points de montage pour les périphériques raid
mkdir /mnt/md0 /mnt/md1

# Montage des volumes raid
mount /dev/md0 /mnt/md0
mount /dev/md1 /mnt/md1

# Vérification du montage des volumes raid
if [ $? -eq 0 ]; alors
    echo "Les volumes raid ont été montés avec succès"
else
    echo "Erreur lors du montage des volumes raid"
    exit 1
fi

# Copie du système sur le volume raid
rsync -aHAXP / /mnt/md0/
rsync -aHAXP /home/$(user) /mnt/md1/

# Vérification de la copie du système
if [ $? -eq 0 ]; alors
    echo "Le système a été copié avec succès"
else
    echo "Erreur lors de la copie du système"
    exit 1
fi

# Adaptation du système sur le volume raid
# (à compléter en fonction de vos besoins)
