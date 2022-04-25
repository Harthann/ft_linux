# VM IMAGE

Debian 11 for Vbox from [linuxvmimages.com](https://www.linuxvmimages.com/images/debian-11/)

Unzip the file then convert vdi to qcow2

```
qemu-img convert -f vdi -O qcow2 Debian_11.1.0_VBM_LinuxVMImages.COM.vdi lfs.qcow2 
```
