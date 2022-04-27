##################################
##      SOURCES DOWNLOAD        ##
##################################

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

wget --continue https://raw.githubusercontent.com/Harthann/ft_linux/master/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

cd $LFS/sources
pushd $LFS/sources
    wget --continue https://raw.githubusercontent.com/Harthann/ft_linux/master/md5sums
    md5sum -c md5sums
popd
