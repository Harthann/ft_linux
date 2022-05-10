make mrproper


make defconfig

make
make modules_install
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.16.9-lfs-r11.1-112-systemd
cp -iv System.map /boot/System.map-5.16.9
cp -iv .config /boot/config-5.16.9



cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 5.16.9-lfs-r11.1-112-systemd" {
        linux   /boot/vmlinuz-5.16.9-lfs-r11.1-112-systemd root=/dev/vdb2 ro
}
EOF
