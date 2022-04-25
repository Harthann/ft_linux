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

# Second Disk

This disk will be use to build our linux on it. We just need to create a second disk for qemu and add the hardware to our VM. Depending on which interface you choose for this device you may need to change some things in future command.


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
