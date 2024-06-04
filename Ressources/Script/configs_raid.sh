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
sfdisk -d $source_disk | sfdisk $target_disk
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

# Installation de MDADM et dosfstools
apt-get install -y mdadm dosfstools
check_success "Installation de MDADM et dosfstools"
cat /proc/mdstat
pause

# Modifier le type de partition
fdisk $target_disk <<EOF
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
mdadm --create /dev/md0 --level=1 --raid-disks=2 --metadata=1.0 missing $target_disk$target_part1
check_success "Création du RAID 1 sur /dev/md0"
mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 missing $target_disk$target_part2
check_success "Création du RAID 1 sur /dev/md1"
pause

# Reconfiguration de MDADM
dpkg-reconfigure mdadm
check_success "Reconfiguration de MDADM"
cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf-dist
mdadm --examine --scan | tee -a /etc/mdadm/mdadm.conf
check_success "Mise à jour de mdadm.conf"
echo "Ajoutez DEVICE $target_disk$target_part1 $target_disk$target_part2 dans le fichier mdadm.conf"
pause
nano /etc/mdadm/mdadm.conf
pause

# Formatage des partitions sur le disque N°2
mkfs.vfat /dev/md0
check_success "Formatage de /dev/md0"
mkfs.ext4 /dev/md1
check_success "Formatage de /dev/md1"
pause

# Montage des partitions du disque N°2
mkdir /mnt/md0 && mkdir /mnt/md1
check_success "Création des points de montage"
mount /dev/md0 /mnt/md0 && mount /dev/md1 /mnt/md1
check_success "Montage des partitions"
pause

# Modification du FSTAB
cp /etc/fstab /etc/fstab.bak
check_success "Sauvegarde de /etc/fstab"
nano /etc/fstab
systemctl daemon-reload
check_success "Rechargement du démon systemd"
echo "Modifiez /etc/fstab si nécessaire, puis appuyez sur Entrée pour continuer..."
read

# Copie des données sur le disque N°2
rsync -auHxv --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* /* /mnt/md1/
check_success "Copie des données vers /mnt/md1"
rsync -auHxv /boot/efi /mnt/md0
check_success "Copie des données de /boot/efi vers /mnt/md0"
pause

echo -e "\e[32mExécution du script de configuration RAID terminée.\e[0m"

# Redémarrer le système
echo -e "\e[33mLe système va redémarrer dans 10 secondes...\e[0m"
sleep 10
reboot
