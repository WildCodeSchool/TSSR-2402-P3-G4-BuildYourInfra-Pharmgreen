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

# Configurer temporairement GRUB pour permettre le démarrage sur le RAID
echo -e "\e[33mConfiguration temporaire de GRUB...\e[0m"
cat <<EOF > /etc/grub.d/09_raid1
#!/bin/sh
exec tail -n +3 \$0
# This file provides an easy way to add custom menu entries. Simply type the
# menu entries you want to add after this comment. Be careful not to change
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
    linux /boot/vmlinuz-3.16.0-4-amd64 root=/dev/md0 ro quiet
    echo 'Loading initial ramdisk ...'
    initrd /boot/initrd.img-3.16.0-4-amd64
}
EOF
check_success "Création de la configuration GRUB temporaire"
chmod +x /etc/grub.d/09_raid1
check_success "Rendre le script GRUB exécutable"

# Désactiver temporairement l'usage de l'UUID par Grub
echo -e "\e[33mDésactivation temporaire de l'usage de l'UUID par Grub...\e[0m"
sed -i 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/' /etc/default/grub
check_success "Désactivation de l'UUID par Grub"

# Mettre à jour la configuration de Grub
update-grub
check_success "Mise à jour de Grub"
update-initramfs -u
check_success "Mise à jour d'initramfs"

# Copier le contenu du premier disque sur le RAID
mkdir /mnt/md0
check_success "Création du point de montage /mnt/md0"
mount /dev/md0 /mnt/md0
check_success "Montage de /dev/md0"
cp -apx / /mnt/md0
check_success "Copie du contenu du premier disque sur /dev/md0"

# Redémarrer le système, qui devrait se lancer sur le RAID
echo -e "\e[33mLe système va redémarrer dans 10 secondes...\e[0m"
sleep 10
reboot
