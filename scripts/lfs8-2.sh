
tar -xvf zlib-1.2.12.tar.xz
cd zlib-1.2.12

./configure --prefix=/usr
make

make check

make install

rm -fv /usr/lib/libz.a

cd ..
rm -rvf zlib-1.2.12.tar.xz

## bzip

tar -xvf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

-f Makefile-libbz2_so

make

make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

rm -fv /usr/lib/libbz2.a

cd ..
rm -rvf bzip2-1.0.8


## xz

tar -xvf xz-5.2.5.tar.xz
cd xz-5.2.5

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5
make
make check
make install_docs

cd ..
rm -rvf xz-5.2.5


## zstd

tar -xvf zstd-1.5.2.tar.gz
cd zstd-1.5.2

make
make check

make prefix=/usr install

rm -v /usr/lib/libzstd.a

cd ..
rm -rvf zstd-1.5.2

## file

tar -xvf file-5.41.tar.gz
cd file-5.41

./configure --prefix=/usr
make
make check
make install

cd ..
rm -rvf file-5.41


## readline

tar -xvf readline-8.1.2.tar.gz
cd readline-8.1.2

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1.2
make SHLIB_LIBS="-lncursesw"
SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2

cd ..
rm -rvf readline-8.1.2
