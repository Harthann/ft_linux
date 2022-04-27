# VM IMAGE

Debian 11 for Vbox from [linuxvmimages.com](https://www.linuxvmimages.com/images/debian-11/)

Unzip the file then convert vdi to qcow2

```
qemu-img convert -f vdi -O qcow2 Debian_11.1.0_VBM_LinuxVMImages.COM.vdi lfs.qcow2 
```

Import this disk image inside libvirt to create new VM.
If you don't use qemnu you can directly use the VBox image to import config inside VirtualBox, or for VMware user just use the VMware image directly.

# Network

To get an ip addr on the NAT network we need to make sure the interface is the same inside `/etc/network/interfaces` than the one from `ip addr`

(Show screenshots here)

# User root set up

From debian user connect to root:
```
sudo su -
```
Then change root password:
```
passwd <<< $(echo root; echo root)
```
Now the root user password is root

# Update and requirement

Now run the update and requirements script
```
sh requirements.sh
```

# Second Disk

This disk will be use to build our linux on it. We just need to create a second disk for qemu and add the hardware to our VM. Depending on which interface you choose for this device you may need to change some things in the script.
Make sure the script use the correct device then run it.

```
sh partition.sh
```

# Sources

Download sources to build our kernel and create repository for them, all version used are from the LFS guide. Zlib had to be update from 1.2.11 to 1.2.12 due to link down.
```
sh sources.sh
```

# LFS User build environment

We now need to create the environment where we'll build the final product, and prepare a cross-compiler toolchain. As well as our building user which will be lfs.

```
sh lfs_env.sh
```

# Cross compiling toolchain startup

It's time to compile our toolchain.
```
sh lfs5.sh | tee lfs5.log
```
Once lfs5 is done and everything is okay, we can run the second part of the toolchain to build and place gcc and binutilos inside our future system

```
sh lfs6.sh | tee lfs6.log
```

# Entering chroot


First change ownership from lfs to root as we'll build the next tools for and from root inside our LFS mount.

```
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
```
Then we need to enter the chroot environment using our script:

```
sh chroot.sh
```
Then we need to create the system directory tree using these following commands:
Root level directories:
```
mkdir -pv /{boot,home,mnt,opt,srv}
```

Subdirectories:
```
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
```

