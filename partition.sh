##################################
##      PARTITION OF DISK       ##
##################################

# fdisk /dev/sdb
#   n
#       p
#       1 (default sector)
#       +1G
#   t (Select partition 1)
#   l (List partition option)
#       82 (Select opcode of linux swap partition)

#   n
#       p
#       2 (default sector)
#       Choose defaults options now

#   w

mkfs -v -t ext4 /dev/sdb1
mkswap /dev/sdb1
mkfs -v -t ext4 /dev/sdb2


export LFS=/mnt/lfs

mkdir pv $LFS

mount -v -t ext4 /dev/sdb2 $LFS
/sbin/swapon -v /dev/sdb1

