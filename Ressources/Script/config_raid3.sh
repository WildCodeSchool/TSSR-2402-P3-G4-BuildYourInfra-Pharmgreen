#!/bin/bash

# Fonction pour faire une pause et attendre l'entrée de l'utilisateur
pause() {
    echo -e "\e[33mAppuyez sur Entrée pour continuer...\e[0m"
    read
}

# Fonction pour vérifier le succès des commandes
check_success() {
    if [ $? -eq 0 ]; alors
        echo -e "\e[32m$1 : Succès\e[0m"
    else
        echo -e "\e[31m$1 : Échec\e[0m"
        exit 1
    fi
}

# Définir le disque source
echo "Entrez le disque source (par exemple, /dev/sda) :"
read source_disk

# Demande des informations sur les partitions pour RAID 1
echo "Entrez le numéro de la première partition pour RAID 1 (par exemple, 1) :"
read source_part1

echo "Entrez le numéro de la seconde partition pour RAID 1 (par exemple, 5) :"
read source_part2

# Changer l'étiquette des partitions de /dev/sda en « RAID Linux »
fdisk $source_disk <<EOF
t
$source_part1
fd
t
$source_part2
fd
w
EOF
check_success "Modification de l'étiquette des partitions"

# Ajouter les partitions de /dev/sda aux volumes RAID
mdadm --add /dev/md0 $source_disk$source_part1
check_success "Ajout de $source_disk$source_part1 à /dev/md0"
mdadm --add /dev/md1 $source_disk$source_part2
check_success "Ajout de $source_disk$source_part2 à /dev/md1"
pause

# Surveiller la progression de la synchronisation des volumes RAID
echo -e "\e[33mSurveillance de la synchronisation des volumes RAID...\e[0m"
watch cat /proc/mdstat
pause

# Finaliser la configuration du nouvel environnement
rm /etc/grub.d/09_raid1
check_success "Suppression de la configuration manuelle de Grub"

# Réactiver l'usage de l'UUID par Grub
sed -i 's/GRUB_DISABLE_LINUX_UUID=true/#GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub
check_success "Réactivation de l'UUID par Grub"

# Mettre à jour la configuration de Grub
update-grub
check_success "Mise à jour de Grub"
update-initramfs -u
check_success "Mise à jour d'initramfs"

# Installer Grub sur les deux systèmes de fichiers
grub-install --recheck /dev/sda
check_success "Installation de Grub sur /dev/sda"
grub-install --recheck /dev/sdb
check_success "Installation de Grub sur /dev/sdb"

# Supprimer le point de montage /mnt/md0
rmdir /mnt/md0
check_success "Suppression du point de montage /mnt/md0"

# Redémarrer le système
echo -e "\e[33mLe système va redémarrer dans 10 secondes...\e[0m"
sleep 10
reboot
