#!/bin/bash

set -e

function error_exit {
    echo -e "\e[31m$1\e[0m"
    exit 1
}

# Clonage de la table des partitions de /dev/sda vers /dev/sdb
echo "Clonage de la table des partitions de /dev/sda vers /dev/sdb..."
sfdisk -d /dev/sda | sfdisk --force /dev/sdb || error_exit "Échec du clonage de la table des partitions."

# Changement des étiquettes des partitions de /dev/sdb en « RAID Linux »
echo "Changement des étiquettes des partitions de /dev/sdb en 'Linux RAID'..."
chmod 777 /dev/sdb
(
    echo t; echo 1; echo fd;
    echo t; echo 5; echo fd;
    echo w;
) | fdisk /dev/sdb || error_exit "Échec du changement des étiquettes de partitions sur /dev/sdb."

# Création des volumes RAID 1
echo "Création des volumes RAID 1..."
mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/sdb1 || error_exit "Échec de la création du volume RAID 1 sur /dev/md0."
mdadm --create /dev/md1 --level=1 --raid-disks=2 missing /dev/sdb5 || error_exit "Échec de la création du volume RAID 1 sur /dev/md1."

# Formatage de /dev/md0 en ext4 et de /dev/md1 en swap
echo "Formatage de /dev/md0 en ext4 et de /dev/md1 en swap..."
chmod 777 /dev/md0 /dev/md1
mkfs.ext4 /dev/md0 || error_exit "Échec du formatage de /dev/md0."
mkswap /dev/md1 || error_exit "Échec du formatage de /dev/md1."

# Mise à jour de la configuration mdadm
echo "Mise à jour de la configuration mdadm..."
chmod 777 /etc/mdadm/mdadm.conf
mdadm --examine --scan >> /etc/mdadm/mdadm.conf || error_exit "Échec de la mise à jour de la configuration mdadm."

# Édition de /etc/fstab
echo "Édition de /etc/fstab..."
chmod 777 /etc/fstab
cp /etc/fstab /etc/fstab.bak
chmod 777 /etc/fstab.bak
echo '/dev/md0    /       ext4    errors=remount-ro   0       1' >> /etc/fstab
echo '/dev/md1    none    swap    sw                  0       0' >> /etc/fstab

# Configuration temporaire de GRUB pour démarrer sur le RAID
echo "Configuration temporaire de GRUB pour démarrer sur le RAID..."
cat <<EOF > /etc/grub.d/09_raid1
#!/bin/sh
exec tail -n +3 \$0
menuentry 'Debian GNU/Linux, avec Linux 3.16.0-4-amd64 en RAID 1' --class debian --class gnu-linux --class gnu --class os {
    load_video
    insmod gzio
    insmod raid
    insmod mdraid1x
    insmod part_msdos
    insmod ext2
    set root='(md/0)'
    echo 'Loading Linux 3.16.0-4-amd64 ...'
    linux /boot/vmlinuz-3.16.0-4-amd64  root=/dev/md0   ro  quiet
    echo 'Loading initial ramdisk ...'
    initrd /boot/initrd.img-3.16.0-4-amd64
}
EOF

chmod 777 /etc/grub.d/09_raid1
chmod +x /etc/grub.d/09_raid1 || error_exit "Échec de rendre /etc/grub.d/09_raid1 exécutable."

# Désactivation de l'utilisation des UUID dans GRUB
echo "Désactivation de l'utilisation des UUID dans GRUB..."
chmod 777 /etc/default/grub
sed -i 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub || error_exit "Échec de la désactivation de l'utilisation des UUID dans GRUB."

# Mise à jour de la configuration de GRUB
echo "Mise à jour de la configuration de GRUB..."
update-grub || error_exit "Échec de la mise à jour de la configuration de GRUB."
update-initramfs -u || error_exit "Échec de la mise à jour d'initramfs."

# Copie du système de fichiers racine sur le RAID
echo "Copie du système de fichiers racine sur le RAID..."
mkdir /mnt/md0 || error_exit "Échec de la création du point de montage /mnt/md0."
chmod 777 /mnt/md0
mount /dev/md0 /mnt/md0 || error_exit "Échec du montage de /dev/md0."
cp -apx / /mnt/md0 || error_exit "Échec de la copie du système de fichiers racine vers /dev/md0."

# Redémarrage du système
echo "Redémarrage du système..."
reboot

# Les étapes suivantes doivent être exécutées après le redémarrage

echo "Après le redémarrage, veuillez vous connecter en tant que root et exécuter les étapes suivantes :"

# Changement des étiquettes des partitions de /dev/sda en « RAID Linux »
echo "Changement des étiquettes des partitions de /dev/sda en 'Linux RAID'..."
chmod 777 /dev/sda
(
    echo t; echo 1; echo fd;
    echo t; echo 5; echo fd;
    echo w;
) | fdisk /dev/sda || error_exit "Échec du changement des étiquettes de partitions sur /dev/sda."

# Ajout des partitions de /dev/sda au RAID
echo "Ajout des partitions de /dev/sda au RAID..."
mdadm --add /dev/md0 /dev/sda1 || error_exit "Échec de l'ajout de /dev/sda1 à /dev/md0."
mdadm --add /dev/md1 /dev/sda5 || error_exit "Échec de l'ajout de /dev/sda5 à /dev/md1."

# Surveillance de la synchronisation du RAID
echo "Surveillance de la synchronisation du RAID..."
watch cat /proc/mdstat

echo "Après la synchronisation, exécutez les étapes suivantes :"

# Suppression de la configuration temporaire de GRUB
echo "Suppression de la configuration temporaire de GRUB..."
chmod 777 /etc/grub.d/09_raid1
rm /etc/grub.d/09_raid1 || error_exit "Échec de la suppression de /etc/grub.d/09_raid1."

# Réactivation de l'utilisation des UUID dans GRUB
echo "Réactivation de l'utilisation des UUID dans GRUB..."
chmod 777 /etc/default/grub
sed -i 's/GRUB_DISABLE_LINUX_UUID=true/#GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub || error_exit "Échec de la réactivation de l'utilisation des UUID dans GRUB."

# Mise à jour de GRUB et d'initramfs
echo "Mise à jour de GRUB et d'initramfs..."
update-grub || error_exit "Échec de la mise à jour de GRUB."
update-initramfs -u || error_exit "Échec de la mise à jour d'initramfs."

# Installation de GRUB sur les deux disques
echo "Installation de GRUB sur les deux disques..."
grub-install --recheck /dev/sda || error_exit "Échec de l'installation de GRUB sur /dev/sda."
grub-install --recheck /dev/sdb || error_exit "Échec de l'installation de GRUB sur /dev/sdb."

# Nettoyage
echo "Nettoyage..."
chmod 777 /mnt/md0
rmdir /mnt/md0 || error_exit "Échec de la suppression de /mnt/md0."

# Redémarrage du système
echo "Redémarrage du système..."
reboot
