#!/bin/bash

# Fonction pour vérifier si une commande a réussi
function check_command() {
  if [ $? -ne 0 ]; then
    echo "Erreur lors de l'exécution de la commande : $1"
    echo "Veuillez vérifier les informations affichées en rouge et corriger les erreurs."
    exit 1
  fi
}

# Installation de MDADM
echo "Installation de MDADM en cours..."
apt-get install mdadm -y
check_command "apt-get install mdadm -y"

# Vérification du statut du RAID
echo "Vérification du statut du RAID en cours..."
cat /proc/mdstat
check_command "cat /proc/mdstat"

# Clonage de la table de partitions
echo "Clonage de la table de partitions en cours..."
sfdisk -d /dev/sda | sfdisk /dev/sdb
check_command "sfdisk -d /dev/sda | sfdisk /dev/sdb"

# Modification du type de partition
echo "Modification du type de partition en cours..."
fdisk /dev/sdb << EOF
t
3
42
w
EOF
check_command "fdisk /dev/sdb << EOF"

# Création du RAID 1 en mode dégradé
echo "Création du RAID 1 en mode dégradé en cours..."
mdadm --create /dev/md0 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb2
check_command "mdadm --create /dev/md0 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb2"

mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb3
check_command "mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb3"

# Reconfiguration de MDADM
echo "Reconfiguration de MDADM en cours..."
dpkg-reconfigure mdadm
check_command "dpkg-reconfigure mdadm"

cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf-dist
check_command "cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf-dist"

mdadm --examine --scan | tee -a /etc/mdadm/mdadm.conf
check_command "mdadm --examine --scan | tee -a /etc/mdadm/mdadm.conf"

echo "DEVICE /dev/sdb2 /dev/sdb3" | tee -a /etc/mdadm/mdadm.conf
check_command "echo "DEVICE /dev/sdb2 /dev/sdb3" | tee -a /etc/mdadm/mdadm.conf"

# Formatage des partitions sur le disque N°2
echo "Formatage des partitions sur le disque N°2 en cours..."
mkfs.vfat /dev/md0
check_command "mkfs.vfat /dev/md0"

mkfs.ext4 /dev/md1
check_command "mkfs.ext4 /dev/md1"

# Montage des partitions du disque N°2
echo "Montage des partitions du disque N°2 en cours..."
mkdir /mnt/md0 && mkdir /mnt/md1
check_command "mkdir /mnt/md0 && mkdir /mnt/md1"

mount /dev/md0 /mnt/md0 && mount /dev/md1 /mnt/md1
check_command "mount /dev/md0 /mnt/md0 && mount /dev/md1 /mnt/md1"

# Modification du FSTAB
echo "Modification du FSTAB en cours..."
cp /etc/fstab /etc/fstab.bak
check_command "cp /etc/fstab /etc/fstab.bak"

# Ajoutez ici les lignes à ajouter dans le fichier /etc/fstab
echo "<nouvelles_lignes_fstab>" | tee -a /etc/fstab
check_command "echo "<nouvelles_lignes_fstab>" | tee -a /etc/fstab"

systemctl daemon-reload
check_command "systemctl
