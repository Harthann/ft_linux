##########
##  M4  ##
##########

tar -xvf m4-1.4.19.tar.xz
cd m4-1.4.19

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf m4-1.4.19

##############
##  NCURSES ##
##############

tar -xvf ncurses-6.3.tar.gz
cd ncurses-6.3

sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --disable-stripping          \
            --enable-widec
           
make
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so


cd $LFS/sources
rm -rvf ncurses-6.3


############
##  BASH  ##
############


tar -xvf bash-5.1.16.tar.gz
cd bash-5.1.16

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc
            
make
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh

cd $LFS/sources
rm -rvf bash-5.1.16

################
##  Coreutils ##
################

tar -xvf coreutils-9.0.tar.xz
cd coreutils-9.0

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
            
make
make DESTDIR=$LFS install
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

cd $LFS/sources
rm -rvf coreutils-9.0

##################
##    DIFFUTILS ##
##################

tar -xvf diffutils-3.8.tar.xz
cd diffutils-3.8

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install


cd $LFS/sources
rm -rvf diffutils-3.8

##############
##    FILE  ##
##############

tar -xvf file-5.41.tar.gz
cd file-5.41

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd



./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf file-5.41

################
##  FINDUTILS ##
################

tar -xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
            
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf findutils-4.9.0

############
##  GAWK  ##
############

tar -xvf gawk-5.1.1.tar.xz
cd gawk-5.1.1

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
            
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf gawk-5.1.1

############
##  GREP  ##
############

tar -xvf grep-3.7.tar.xz
cd grep-3.7

./configure --prefix=/usr   \
            --host=$LFS_TGT
make
make DESTDIR=$LFS install


cd $LFS/sources
rm -rvf grep-3.7

##############
##    GZIP  ##
##############

tar -xvf gzip-1.11.tar.xz
cd gzip-1.11

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf gzip-1.11


############
##  MAKE  ##
############

tar -xvf make-4.3.tar.gz
cd make-4.3



./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf make-4.3

############
##  PATCH ##
############


tar -xvf patch-2.7.6.tar.xz
cd patch-2.7.6


./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf patch-2.7.6

##########
##  SED ##
##########


tar -xvf sed-4.8.tar.xz
cd sed-4.8

./configure --prefix=/usr   \
            --host=$LFS_TGT
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf sed-4.8

##########
##  TAR ##
##########

tar -xvf tar-1.34.tar.xz
cd tar-1.34

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf tar-1.34

############
##    XZ  ##
############
 
tar -xvf xz-5.2.5.tar.xz
cd xz-5.2.5

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5
            
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf xz-5.2.5

################
##  BINUTILS  ##
################

tar -xvf binutils-2.38.tar.xz
cd binutils-2.38

sed '6009s/$add_dir//' -i ltmain.sh
mkdir -v build
cd       build
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd
make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rvf binutils-2.38

############
##    GCC ##
############

tar -xvf gcc-11.2.0.tar.xz
cd gcc-11.2.0

tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build
cd       build
mkdir -pv $LFS_TGT/libgcc
ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h

../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --prefix=/usr                                  \
    CC_FOR_TARGET=$LFS_TGT-gcc                     \
    --with-build-sysroot=$LFS                      \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
make
make DESTDIR=$LFS install
ln -sv gcc $LFS/usr/bin/cc

cd $LFS/sources
rm -rvf gcc-11.2.0
