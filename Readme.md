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
