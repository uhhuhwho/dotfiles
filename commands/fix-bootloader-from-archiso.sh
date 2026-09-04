echo "Executing lsblk: "
lsblk

echo "Executing fdisk -l: "
fdisk -l

echo "### --- ###"

# we assume that our arch partition is at: /dev/nvme0n1p2, make sure to check this out from the result of 'fdisk -l'
#mount /dev/nvme0n1p2 /mnt # this mount the root partition
#mount /dev/nvme0n1p1 /mnt/efi # this mount the esp of our uefi or boot

# then let's arch-chroot to the mounted fs
#arch-chroot /mnt

# now we're into the new moutned fs let's install grub and update it's config
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# and we can check the boot order using this command
efibootmgr

echo "Done :D, don't forget to umout -R /mnt"
# and we're done now let's exit and unmount the fs
exit
#umount -R /mnt
#echo "Done :D"
