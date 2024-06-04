#!/bin/bash

# Couleurs pour les messages
VERT="\033[1;32m"
ROUGE="\033[1;31m"
NORMAL="\033[0m"

function afficher_message {
  if [ $? -eq 0 ]; then
    echo -e "${VERT}$1${NORMAL}"
  else
    echo -e "${ROUGE}$2${NORMAL}"
    exit 1
  fi
}

# Vérifier si le script est exécuté avec des privilèges root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${ROUGE}Veuillez exécuter ce script en tant que root.${NORMAL}"
  exit 1
fi

# Installation de MDADM
echo "=== Installation de MDADM ==="
apt-get install -y mdadm
afficher_message "MDADM installé avec succès." "Échec de l'installation de MDADM."

# Vérification de l'état actuel de MDADM
cat /proc/mdstat
afficher_message "Vérification de l'état de MDADM terminée." "Échec de la vérification de l'état de MDADM."

# Cloner la table de partition
echo "=== Clonage de la table de partition ==="
sfdisk -d /dev/sda | sfdisk /dev/sdb
afficher_message "Table de partition clonée avec succès." "Échec du clonage de la table de partition."

# Modifier le type de partition
echo "=== Modification du type de partition ==="
echo -e "t\n3\n42\nw\n" | fdisk /dev/sdb
afficher_message "Type de partition modifié avec succès." "Échec de la modification du type de partition."

# Création du RAID 1 en mode dégradé
echo "=== Création du RAID 1 en mode dégradé ==="
mdadm --create /dev/md0 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb2
afficher_message "RAID 1 (md0) créé en mode dégradé avec succès." "Échec de la création du RAID 1 (md0) en mode dégradé."
mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 missing /dev/sdb3
afficher_message "RAID 1 (md1) créé en mode dégradé avec succès." "Échec de la création du RAID 1 (md1) en mode dégradé."

# Reconfiguration de MDADM
echo "=== Reconfiguration de MDADM ==="
dpkg-reconfigure mdadm
afficher_message "Reconfiguration de MDADM réussie." "Échec de la reconfiguration de MDADM."
cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf-dist
mdadm --examine --scan | tee -a /etc/mdadm/mdadm.conf
echo "DEVICE /dev/sdb2 /dev/sdb3" >> /etc/mdadm/mdadm.conf
afficher_message "Configuration de MDADM mise à jour avec succès." "Échec de la mise à jour de la configuration de MDADM."

# Formatage des partitions sur le disque N°2
echo "=== Formatage des partitions sur le disque N°2 ==="
mkfs.vfat /dev/md0
afficher_message "Partition /dev/md0 formatée en vfat avec succès." "Échec du formatage de la partition /dev/md0 en vfat."
mkfs.ext4 /dev/md1
afficher_message "Partition /dev/md1 formatée en ext4 avec succès." "Échec du formatage de la partition /dev/md1 en ext4."

# Montage des partitions du disque N°2
echo "=== Montage des partitions du disque N°2 ==="
mkdir -p /mnt/md0 && mkdir -p /mnt/md1
mount /dev/md0 /mnt/md0
afficher_message "Partition /dev/md0 montée avec succès." "Échec du montage de la partition /dev/md0."
mount /dev/md1 /mnt/md1
afficher_message "Partition /dev/md1 montée avec succès." "Échec du montage de la partition /dev/md1."

# Modification du FSTAB
echo "=== Modification du FSTAB ==="
cp /etc/fstab /etc/fstab.bak
echo "/dev/md0 /mnt/md0 vfat defaults 0 0" >> /etc/fstab
echo "/dev/md1 /mnt/md1 ext4 defaults 0 0" >> /etc/fstab
systemctl daemon-reload
afficher_message "FSTAB modifié avec succès." "Échec de la modification du FSTAB."

# Mise à jour de GRUB
echo "=== Mise à jour de GRUB ==="
update-grub
afficher_message "GRUB mis à jour avec succès." "Échec de la mise à jour de GRUB."

# Copie des données sur le disque N°2
echo "=== Copie des données sur le disque N°2 ==="
rsync -auHxv --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* /* /mnt/md1/
afficher_message "Données copiées sur /mnt/md1 avec succès." "Échec de la copie des données sur /mnt/md1."
rsync -auHxv /boot/efi /mnt/md0
afficher_message "Données de /boot/efi copiées sur /mnt/md0 avec succès." "Échec de la copie des données de /boot/efi sur /mnt/md0."

# Mise à jour de GRUB et Initramfs sur le disque N°2
echo "=== Mise à jour de GRUB et Initramfs sur le disque N°2 ==="
cp /etc/mdadm/mdadm.conf /mnt/md1/etc/mdadm/mdadm.conf
mount --bind /dev /mnt/md1/dev
mount --bind /proc /mnt/md1/proc
mount --bind /sys /mnt/md1/sys
chroot /mnt/md1 /bin/bash -c "update-initramfs -u && update-grub"
afficher_message "GRUB et Initramfs mis à jour sur le disque N°2 avec succès." "Échec de la mise à jour de GRUB et Initramfs sur les disque N°2."

# Mise à jour de GRUB sur le disque N°1
echo "=== Mise à jour de GRUB sur le disque N°1 ==="
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
cp /mnt/md1/boot/grub/grub.cfg /boot/grub/grub.cfg
afficher_message "GRUB mis à jour sur le disque N°1 avec succès." "Échec de la mise à jour de GRUB sur le disque N°1."

# Modification du type de partition sur le disque N°1
echo "=== Modification du type de partition sur le disque N°1 ==="
echo -e "t\n3\n42\nw\n" | fdisk /dev/sda
afficher_message "Type de partition modifié sur le disque N°1 avec succès." "Échec de la modification du type de partition sur le disque N°1."

# Ajout du disque N°1 dans la grappe RAID
echo "=== Ajout du disque N°1 dans la grappe RAID ==="
mdadm --manage /dev/md1 --add /dev/sda3
afficher_message "Disque N°1 ajouté dans /dev/md1 avec succès." "Échec de l'ajout du disque N°1 dans /dev/md1."
mdadm --manage /dev/md0 --add /dev/sda2
afficher_message "Disque N°1 ajouté dans /dev/md0 avec succès." "Échec de l'ajout du disque N°1 dans /dev/md0."

# Mise à jour de la configuration de MDADM
echo "=== Mise à jour de la configuration de MDADM ==="
echo "DEVICE /dev/sda2 /dev/sda3 /dev/sdb2 /dev/sdb3" >> /etc/mdadm/mdadm.conf
afficher_message "Configuration de MDADM mise à jour avec succès." "Échec de la mise à jour de la configuration de MDADM."

# Mise à jour de GRUB et Initramfs sur le disque N°1
echo "=== Mise à jour de GRUB et Initramfs sur le disque N°1 ==="
update-initramfs -u
update-grub
afficher_message "GRUB et Initramfs mis à jour sur le disque N°1 avec succès." "Échec de la mise à jour de GRUB et Initramfs sur le disque N°1."

echo -e "${VERT}Script terminé avec succès !${NORMAL}"
