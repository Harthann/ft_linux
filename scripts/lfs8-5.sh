tar -xf openssl-3.0.1.tar.gz
cd openssl-3.0.1

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.0.1
cp -vfr doc/* /usr/share/doc/openssl-3.0.1

cd /sources
rm -rf openssl-3.0.1

tar -xf kmod-29.tar.xz
cd kmod-29

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make
make install

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
done

ln -sfv kmod /usr/bin/lsmod

cd /sources
rm -rf kmod-29

tar -xf elfutils-0.186.tar.bz2
cd elfutils-0.186

./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make
make check
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

cd /sources
rm -rf elfutils-0.186

tar -xf libffi-3.4.2.tar.gz
cd libffi-3.4.2

./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=native \
            --disable-exec-static-tramp
make
make check
make install

cd /sources
rm -rf libffi-3.4.2

tar -xf Python-3.10.2.tar.xz
cd Python-3.10.2

./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --with-ensurepip=yes \
            --enable-optimizations
make
make install
install -v -dm755 /usr/share/doc/python-3.10.2/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.10.2/html \
    -xvf ../python-3.10.2-docs-html.tar.bz2

cd /sources
rm -rf Python-3.10.2

tar -xf ninja-1.10.2.tar.gz
cd ninja-1.10.2

export NINJAJOBS=4
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

cd /sources
rm -rf ninja-1.10.2

tar -xf meson-0.61.1.tar.gz
cd meson-0.61.1

python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

cd /sources
rm -rf meson-0.61.1

tar -xf coreutils-9.0.tar.xz
cd coreutils-9.0

patch -Np1 -i ../coreutils-9.0-i18n-1.patch
patch -Np1 -i ../coreutils-9.0-chmod_fix-1.patch
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make
make NON_ROOT_USERNAME=tester check-root
echo "dummy:x:102:tester" >> /etc/group
chown -Rv tester .
su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group
make install
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

cd /sources
rm -rf coreutils-9.0

tar -xf check-0.15.2.tar.gz
cd check-0.15.2

./configure --prefix=/usr --disable-static
make
make check
make docdir=/usr/share/doc/check-0.15.2 install

cd /sources
rm -rf check-0.15.2

tar -xf diffutils-3.8.tar.xz
cd diffutils-3.8

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf diffutils-3.8

tar -xf gawk-5.1.1.tar.xz
cd gawk-5.1.1

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make check
make install
mkdir -pv                                   /usr/share/doc/gawk-5.1.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1

cd /sources
rm -rf gawk-5.1.1

tar -xf findutils-4.9.0.tar.xz
cd findutils-4.9.0

case $(uname -m) in
    i?86)   TIME_T_32_BIT_OK=yes ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
    x86_64) ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
esac
make
chown -Rv tester .
su tester -c "PATH=$PATH make check"
make install

cd /sources
rm -rf findutils-4.9.0

tar -xf groff-1.22.4.tar.gz
cd groff-1.22.4

PAGE=<paper_size> ./configure --prefix=/usr
make -j1
make install

cd /sources
rm -rf groff-1.22.4

tar -xf grub-2.06.tar.xz
cd grub-2.06

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

cd /sources
rm -rf grub-2.06

tar -xf gzip-1.11.tar.xz
cd gzip-1.11

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf gzip-1.11

tar -xf iproute2-5.16.0.tar.xz
cd iproute2-5.16.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make
make SBINDIR=/usr/sbin install
mkdir -pv             /usr/share/doc/iproute2-5.16.0
cp -v COPYING README* /usr/share/doc/iproute2-5.16.0

cd /sources
rm -rf iproute2-5.16.0

tar -xf kbd-2.4.0.tar.xz
cd kbd-2.4.0

patch -Np1 -i ../kbd-2.4.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make check
make install
mkdir -pv           /usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0

cd /sources
rm -rf kbd-2.4.0

tar -xf libpipeline-1.5.5.tar.gz
cd libpipeline-1.5.5

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf libpipeline-1.5.5

tar -xf make-4.3.tar.gz
cd make-4.3

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf make-4.3

tar -xf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf patch-2.7.6

tar -xf tar-1.34.tar.xz
cd tar-1.34

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.34

cd /sources
rm -rf tar-1.34

tar -xf texinfo-6.8.tar.xz
cd texinfo-6.8

./configure --prefix=/usr
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c
make
make check
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd

cd /sources
rm -rf texinfo-6.8
