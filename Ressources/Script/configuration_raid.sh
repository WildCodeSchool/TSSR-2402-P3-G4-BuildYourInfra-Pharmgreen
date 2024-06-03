#!/bin/bash

# Vérifier que le script est exécuté en tant que super-utilisateur
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que super-utilisateur (root)."
  exit 1
fi

# Installer mdadm
aptitude install mdadm -y

# Cloner la table de partitions de /dev/sda sur /dev/sdb
sfdisk -d /dev/sda | sfdisk --force /dev/sdb

# Changer l'étiquette des partitions de /dev/sdb en « RAID Linux »
(
echo t
echo 1
echo fd
echo t
echo 5
echo fd
echo w
) | fdisk /dev/sdb

# Créer les volumes RAID 1 sans les partitions /dev/sda
mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/sdb1
mdadm --create /dev/md1 --level=1 --raid-disks=2 missing /dev/sdb5

# Formater /dev/md0 en ext4 et /dev/md1 en swap
mkfs.ext4 /dev/md0
mkswap /dev/md1

# Déclarer les volumes RAID 1 nouvellement créés dans le fichier de configuration
mdadm --examine --scan >> /etc/mdadm/mdadm.conf

# Préparer le fichier /etc/fstab
cp /etc/fstab /etc/fstab.bak
echo "/dev/md0    /       ext4    errors=remount-ro   0       1" >> /etc/fstab
echo "/dev/md1    none    swap    sw                  0       0" >> /etc/fstab

# Configurer Grub
cat <<EOF > /etc/grub.d/09_raid1
#!/bin/sh
exec tail -n +3 \$0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
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

chmod +x /etc/grub.d/09_raid1

# Désactiver temporairement l'usage de l'UUID par Grub
sed -i 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub

# Mettre à jour la configuration de Grub
update-grub
update-initramfs -u

# Créer temporairement un point de montage pour /dev/md0
mkdir /mnt/md0

# Monter le volume correspondant
mount /dev/md0 /mnt/md0

# Copier l'intégralité de / sur /dev/md0
cp -apx / /mnt/md0

# Redémarrer le système
echo "Le système va redémarrer. Veuillez exécuter la suite du script après le redémarrage."
reboot

# Instructions à exécuter après le redémarrage
# --------------------------------------------
# Connectez-vous en super-utilisateur et exécutez les commandes suivantes :
# su -
# fdisk /dev/sda
# Commande (m pour l'aide) : t
# Numéro de partition (1,2,5, 5 par défaut) : 1
# Code Hexa (taper L pour afficher tous les codes) : fd
# Commande (m pour l'aide) : t
# Numéro de partition (1,2,5, 5 par défaut) : 5
# Code Hexa (taper L pour afficher tous les codes) : fd
# Commande (m pour l'aide) : w

# Ajouter les partitions de /dev/sda aux volumes RAID
mdadm --add /dev/md0 /dev/sda1
mdadm --add /dev/md1 /dev/sda5

# Surveiller la progression de la synchronisation des volumes RAID
watch cat /proc/mdstat

# Finaliser la configuration du nouvel environnement
rm /etc/grub.d/09_raid1
sed -i 's/GRUB_DISABLE_LINUX_UUID=true/#GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub
update-grub
update-initramfs -u

# Installer Grub sur les deux systèmes de fichiers
grub-install --recheck /dev/sda
grub-install --recheck /dev/sdb

# Supprimer le point de montage /mnt/md0
rmdir /mnt/md0

# Redémarrer le système
reboot
