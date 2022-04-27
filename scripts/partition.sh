##################################
##      PARTITION OF DISK       ##
##################################

##  Change /dev/vdb by the device location corresponding to your device bus
##  Example: Sata disk are write as /dev/sd*
##  Replace the '*' by the corresponding letter of your device.
##  Your first disk will be a then b on so on
##
##  In my case i use VirtIO from KVM which makes my device on /dev/vd*
##  My first disk which contains debian:    /dev/vda
##  My second disk which will contain lfs:  /dev/vdb

su -


##  I'm not an expert to partition i just followed a guide and scripting it
##  There's probably a cleaner way to script it
##  First we create a 1Go partition and make it our swap (type 82)
##  Then use the remaining space to create annother partition for the whole system

fdisk /dev/vdb <<< $(
    echo 'n';
    echo 'p';
    echo '1';
    echo '';
    echo '+1G';
    echo 't';
    echo '82';
    echo 'n';
    echo 'p';
    echo '2';
    echo '';
    echo '';
    echo 'w';
)

# fdisk /dev/vdb
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

##  Add file format to our new partitions
mkfs -v -t ext4 /dev/vdb1
mkswap /dev/vdb1
mkfs -v -t ext4 /dev/vdb2

##########################
##  MOUNTING PARTITION  ##
##########################

mkdir -pv $LFS
mount -v -t ext4 /dev/vdb2 $LFS

echo '/dev/vdb2  /mnt/lfs ext4   defaults      1     1' >> /etc/fstab

/sbin/swapon -v /dev/vdb1
