##############################
##      DEBIAN PACKAGE      ##
##############################

apt-get update
DEBS="
apt-file
automake
bison
build-essential
gawk
git
liblocale-msgfmt-perl
locales-all
texinfo
parted
vim
"

apt-get install $DEBS -y
apt-file update


echo "Base toolsto build our kernel"
apt install build-essential bison gawk texinfo

rm -rf /bin/sh
ln -s /bin/bash /bin/sh

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


##################################
##      SOURCES DOWNLOAD        ##
##################################

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

wget --continue https://raw.githubusercontent.com/y3ll0w42/ft_linux/main/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

cd $LFS/sources
pushd $LFS/sources
    wget --continue https://raw.githubusercontent.com/y3ll0w42/ft_linux/main/md5sums
    md5sum -c md5sums
popd

######################
##      CHECK       ##
######################

cd /tmp
cat > version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1  # texinfo version
xz --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF

bash version-check.sh
cd

##########################
##                      ##
##########################

echo $LFS
mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
passwd lfs


chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
chown -v lfs $LFS/sources
su - lfs


cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
MAKEFLAGS='-j8'
export LFS LC_ALL LFS_TGT PATH MAKEFLAGS
EOF
source ~/.bash_profile
