##############################
##      DEBIAN PACKAGE      ##
##############################

su -

apt update
apt upgrade

#DEBS="
#apt-file
#automake
#bison
#build-essential
#gawk
#git
#liblocale-msgfmt-perl
#locales-all
#texinfo
#parted
#vim
#"

DEBS="
build-essential
bison
gawk
m4
make
patch
texinfo
parted
vim
"

apt install $DEBS -y

rm -rf /bin/sh
ln -s /bin/bash /bin/sh

################
##  ROOT ENV  ##
################

echo 'export LFS=/mnt/lfs' >> .bashrc

# apt-file update

##################################
##      SOURCES DOWNLOAD        ##
##################################

#mkdir -v $LFS/sources
#chmod -v a+wt $LFS/sources

#wget --continue https://raw.githubusercontent.com/y3ll0w42/ft_linux/main/wget-list
#wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

#cd $LFS/sources
#pushd $LFS/sources
#    wget --continue https://raw.githubusercontent.com/y3ll0w42/ft_linux/main/md5sums
#    md5sum -c md5sums
#popd
