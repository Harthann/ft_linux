mkdir -pv $LFS
mount -v -t ext4 /dev/vdb2 $LFS

echo '/dev/vdb2  /mnt/lfs ext4   defaults      1     1' >> /etc/fstab

/sbin/swapon -v /dev/vdb1
