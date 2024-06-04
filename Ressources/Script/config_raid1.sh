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

# Installation de mdadm et vérification
apt-get install -y mdadm
check_success "Installation de MDADM"
pause

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

# Modifier l'étiquette des partitions de /dev/sdb en « RAID Linux »
echo "Entrez le numéro de la première partition pour RAID 1 (par exemple, 1) :"
read part1

echo "Entrez le numéro de la seconde partition pour RAID 1 (par exemple, 5) :"
read part2

fdisk $target_disk <<EOF
t
$part1
fd
t
$part2
fd
w
EOF
check_success "Modification de l'étiquette des partitions"
pause

# Création du RAID 1 en mode dégradé
mdadm --create /dev/md0 --level=1 --raid-disks=2 missing $target_disk$part1
check_success "Création du RAID 1 sur /dev/md0"
mdadm --create /dev/md1 --level=1 --raid-disks=2 missing $target_disk$part2
check_success "Création du RAID 1 sur /dev/md1"
pause

# Formater /dev/md0 en ext4 et /dev/md1 en swap
mkfs.ext4 /dev/md0
check_success "Formatage de /dev/md0"
mkswap /dev/md1
check_success "Formatage de /dev/md1"
pause

# Déclarer les volumes RAID 1 nouvellement créés dans /etc/mdadm/mdadm.conf
cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf.origin
mdadm --misc --detail --brief /dev/md* 2>/dev/null | tee -a /etc/mdadm/mdadm.conf
check_success "Mise à jour de /etc/mdadm/mdadm.conf"
pause

# Noter les UUID des groupes RAID
echo -e "\e[33mLes UUID des groupes RAID sont les suivants :\e[0m"
ls -l /dev/disk/by-uuid/ | grep md
pause

# Ajouter les modules raid1 et md_mod à initramfs
echo -e "raid1\nmd_mod" >> /etc/initramfs-tools/modules
check_success "Ajout des modules raid1 et md_mod à initramfs"
update-initramfs -u -k $(uname -r)
check_success "Mise à jour d'initramfs"
pause

# Mise à jour de GRUB pour inclure les modules RAID
sed -i 's/^#GRUB_PRELOAD_MODULES=""/GRUB_PRELOAD_MODULES="raid mdraid"/' /etc/default/grub
check_success "Ajout des modules RAID à GRUB"

# Assurez-vous que GRUB_DISABLE_LINUX_UUID est commenté
sed -i 's/^GRUB_DISABLE_LINUX_UUID=true/#GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub
check_success "Vérification de GRUB_DISABLE_LINUX_UUID"

update-grub
check_success "Mise à jour de GRUB"

# Demander le disque pour l'installation de GRUB
echo "Entrez le disque pour l'installation de GRUB (par exemple, /dev/sda) :"
read grub_disk

grub-install --recheck $grub_disk
check_success "Installation de GRUB sur $grub_disk"
pause

# Assurez-vous que les modules RAID sont chargés au démarrage
echo -e "md_mod\nraid1" >> /etc/modules
check_success "Ajout des modules RAID à /etc/modules"
pause

# Copie du système sur les volumes RAID
echo "Créez un point de montage temporaire pour /dev/md0 :"
mkdir /mnt/md0
chmod 777 /mnt/md0
check_success "Création du point de montage /mnt/md0"
mount /dev/md0 /mnt/md0
check_success "Montage de /dev/md0"
cp -a / /mnt/md0/
check_success "Copie du système sur /dev/md0"
pause

echo -e "\e[32mExécution du script de préparation et de création du RAID terminée.\e[0m"

# Redémarrer le système
echo -e "\e[33mLe système va redémarrer dans 10 secondes...\e[0m"
sleep 10
reboot
