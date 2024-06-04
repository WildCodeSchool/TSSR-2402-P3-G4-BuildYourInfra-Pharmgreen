#!/bin/bash

# Fonction pour faire une pause et attendre l'entrée de l'utilisateur
pause() {
    echo -e "\e[33mAppuyez sur Entrée pour continuer...\e[0m"
    read
}

# Fonction pour vérifier le succès des commandes
check_success() {
    if [ $? -eq 0 ]; then
        echo -e "\e[32m$1 : Succès\e[0m"
    else
        echo -e "\e[31m$1 : Échec\e[0m"
        exit 1
    fi
}

# Définir les disques
echo "Entrez le disque source (par exemple, /dev/sda) :"
read source_disk

echo "Entrez le disque cible (par exemple, /dev/sdb) :"
read target_disk

# Cloner la table de partition
sudo sfdisk -d $source_disk | sudo sfdisk $target_disk
check_success "Clonage de la table de partition"
pause

# Afficher les partitions disponibles
echo "Voici les partitions disponibles :"
lsblk
pause

# Demande des informations sur les partitions
echo "Entrez le numéro de la partition source pour RAID 1 (par exemple, 2) :"
read source_part1

echo "Entrez le numéro de la partition cible pour RAID 1 (par exemple, 2) :"
read target_part1

echo "Entrez le numéro de la partition source pour RAID 1 (par exemple, 3) :"
read source_part2

echo "Entrez le numéro de la partition cible pour RAID 1 (par exemple, 3) :"
read target_part2

# Installation de MDADM
sudo apt-get install mdadm
check_success "Installation de MDADM"
sudo cat /proc/mdstat
pause

# Modifier le type de partition
sudo fdisk $target_disk <<EOF
t
$target_part1
42
t
$target_part2
42
w
EOF
check_success "Modification du type de partition"
pause

# Création du RAID 1 en mode dégradé
sudo mdadm --create /dev/md0 --level=1 --raid-disks=2 --metadata=1.0 missing $target_disk$target_part1
check_success "Création du RAID 1 sur /dev/md0"
sudo mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 missing $target_disk$target_part2
check_success "Création du RAID 1 sur /dev/md1"
pause

# Reconfiguration de MDADM
sudo dpkg-reconfigure mdadm
check_success "Reconfiguration de MDADM"
sudo cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf-dist
sudo mdadm --examine --scan | sudo tee -a /etc/mdadm/mdadm.conf
check_success "Mise à jour de mdadm.conf"
sudo nano /etc/mdadm/mdadm.conf
echo "Ajoutez DEVICE $target_disk$target_part1 $target_disk$target_part2 à mdadm.conf, puis appuyez sur Entrée pour continuer..."
read

# Formatage des partitions sur le disque N°2
sudo mkfs.vfat /dev/md0
check_success "Formatage de /dev/md0"
sudo mkfs.ext4 /dev/md1
check_success "Formatage de /dev/md1"
pause

# Montage des partitions du disque N°2
sudo mkdir /mnt/md0 && sudo mkdir /mnt/md1
check_success "Création des points de montage"
sudo mount /dev/md0 /mnt/md0 && sudo mount /dev/md1 /mnt/md1
check_success "Montage des partitions"
pause

# Modification du FSTAB
sudo cp /etc/fstab /etc/fstab.bak
check_success "Sauvegarde de /etc/fstab"
sudo nano /etc/fstab
sudo systemctl daemon-reload
check_success "Rechargement du démon systemd"
echo "Modifiez /etc/fstab si nécessaire, puis appuyez sur Entrée pour continuer..."
read

# Mise à jour de GRUB
sudo nano /etc/default/grub
sudo update-grub
check_success "Mise à jour de GRUB"
sudo dpkg-reconfigure grub-pc
check_success "Reconfiguration de GRUB"
echo "Modifiez /etc/default/grub si nécessaire, puis appuyez sur Entrée pour continuer..."
read

# Copie des données sur le disque N°2
sudo rsync -auHxv --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* /* /mnt/md1/
check_success "Copie des données vers /mnt/md1"
sudo rsync -auHxv /boot/efi /mnt/md0
check_success "Copie des données de /boot/efi vers /mnt/md0"
pause

# Mise à jour de GRUB et Initramfs sur le disque N°2
sudo cp /etc/mdadm/mdadm.conf /mnt/md1/etc/mdadm/mdadm.conf
check_success "Copie de mdadm.conf vers /mnt/md1"
sudo mount --bind /dev /mnt/md1/dev
sudo mount --bind /proc /mnt/md1/proc
sudo mount --bind /sys /mnt/md1/sys
sudo chroot /mnt/md1
check_success "Chroot vers /mnt/md1"
update-initramfs -u
check_success "Mise à jour d'initramfs"
update-grub
check_success "Mise à jour de GRUB dans le chroot"
exit
pause

# Mise à jour de GRUB sur le disque N°1
sudo cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak
check_success "Sauvegarde de /boot/grub/grub.cfg"
sudo cp /mnt/md1/boot/grub/grub.cfg /boot/grub/grub.cfg
check_success "Copie de grub.cfg vers /boot/grub/grub.cfg"
pause

# Modification de la partition sur le disque N°1
sudo fdisk $source_disk <<EOF
t
$source_part1
42
t
$source_part2
42
w
EOF
check_success "Modification du type de partition sur le disque N°1"
pause

# Ajout du disque N°1 dans la grappe RAID
sudo mdadm --manage /dev/md1 --add $source_disk$source_part2
check_success "Ajout de $source_disk$source_part2 à /dev/md1"
sudo mdadm --manage /dev/md0 --add $source_disk$source_part1
check_success "Ajout de $source_disk$source_part1 à /dev/md0"
pause

# Mise à jour de la configuration de MDADM
sudo nano /etc/mdadm/mdadm.conf
echo "Ajoutez DEVICE $source_disk$source_part1 $source_disk$source_part2 $target_disk$target_part1 $target_disk$target_part2 à mdadm.conf, puis appuyez sur Entrée pour continuer..."
read

# Mise à jour de GRUB et Initramfs sur le disque N°1
sudo update-initramfs -u
check_success "Mise à jour d'initramfs sur le disque N°1"
sudo update-grub
check_success "Mise à jour de GRUB sur le disque N°1"
pause

echo -e "\e[32mExécution du script terminée.\e[0m"
