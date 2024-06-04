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
sfdisk -d $source_disk | sfdisk --force $target_disk
check_success "Clonage de la table de partition"
pause

# Afficher les partitions disponibles
echo "Voici les partitions disponibles :"
lsblk
pause

# Demande des informations sur les partitions pour RAID 1
echo "Entrez le numéro de la première partition pour RAID 1 (par exemple, 1) :"
read source_part1

echo "Entrez le numéro de la seconde partition pour RAID 1 (par exemple, 5) :"
read source_part2

# Modifier l'étiquette des partitions de /dev/sdb en « RAID Linux »
fdisk $target_disk <<EOF
t
$source_part1
fd
t
$source_part2
fd
w
EOF
check_success "Modification de l'étiquette des partitions"
pause

# Création du RAID 1 en mode dégradé
mdadm --create /dev/md0 --level=1 --raid-disks=2 missing $target_disk"$source_part1"
check_success "Création du RAID 1 sur /dev/md0"
mdadm --create /dev/md1 --level=1 --raid-disks=2 missing $target_disk"$source_part2"
check_success "Création du RAID 1 sur /dev/md1"
pause

# Formater /dev/md0 en ext4 et /dev/md1 en swap
mkfs.ext4 /dev/md0
check_success "Formatage de /dev/md0"
mkswap /dev/md1
check_success "Formatage de /dev/md1"
pause

# Déclarer les volumes RAID 1 nouvellement créés dans /etc/mdadm/mdadm.conf
mdadm --examine --scan >> /etc/mdadm/mdadm.conf
check_success "Mise à jour de /etc/mdadm/mdadm.conf"
pause

# Modification du FSTAB
cp /etc/fstab /etc/fstab.bak
check_success "Sauvegarde de /etc/fstab"
echo "Modifiez /etc/fstab pour inclure les nouvelles partitions RAID, puis appuyez sur Entrée pour continuer..."
nano /etc/fstab
check_success "Modification de /etc/fstab"
pause

echo -e "\e[32mExécution du script de préparation et de création du RAID terminée.\e[0m"

# Redémarrer le système
echo -e "\e[33mLe système va redémarrer dans 10 secondes...\e[0m"
sleep 10
reboot
