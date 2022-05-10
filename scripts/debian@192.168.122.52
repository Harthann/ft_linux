## PKG

tar -xvf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
make check
make install

cd ..
rm -rf pkg-config-0.29.2


##	NCURSES

tar -xvf ncurses-6.3.tar.gz
cd ncurses-6.3

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib
rm -v  dest/usr/lib/{libncursesw.so.6.3,libncurses++w.a}
cp -av dest/* /
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so
mkdir -pv      /usr/share/doc/ncurses-6.3
cp -v -R doc/* /usr/share/doc/ncurses-6.3

cd ..
rm -rf ncurses-6.3

## SED

tar -xvf sed-4.8.tar.xz
cd sed-4.8

./configure --prefix=/usr
make
make html
chown -Rv tester .
su tester -c "PATH=$PATH make check"
make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

cd ..
rm -rf sed-4.8

## Psmisc

tar -xvf psmisc-23.4.tar.xz
cd psmisc-23.4

./configure --prefix=/usr
make
make install

cd ..
rm -rf psmisc-23.4

##	gettext

tar -xvf gettext-0.21.tar.xz
cd gettext-0.21

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21
make
make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd ..
rm -rf gettext-0.21


##	Bison

tar -xvf bison-3.8.2.tar.xz
cd bison-3.8.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
make check
make install

cd ..
rm -rf bison-3.8.2

##	Grep

tar -xvf grep-3.7.tar.xz
cd grep-3.7

./configure --prefix=/usr
make
make check
make install

cd ..
rm -rf grep-3.7

##	Bash

tar -xvf bash-5.1.16.tar.gz
cd bash-5.1.16

./configure --prefix=/usr                      \
            --docdir=/usr/share/doc/bash-5.1.16 \
            --without-bash-malloc              \
            --with-installed-readline
make
chown -Rv tester .
su -s /usr/bin/expect tester << EOF
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
make install
#exec /usr/bin/bash --login

cd ..
rm -rf bash-5.1.16

##	Libtool

tar -xvf libtool-2.4.6.tar.xz
cd libtool-2.4.6

./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libltdl.a

cd ..
rm -rf libtool-2.4.6


##	GDBM

tar -xvf gdbm-1.23.tar.gz
cd gdbm-1.23

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install

cd ..
rm -rf gdbm-1.23


##	Gperf

tar -xvf gperf-3.1.tar.gz
cd gperf-3.1

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make -j1 check
make install

cd ..
rm -rf gperf-3.1


##	Expat

tar -xvf expat-2.4.6.tar.xz
cd expat-2.4.6

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.6
make
make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.6

cd ..
rm -rf expat-2.4.6


##	Inetutils

tar -xvf inetutils-2.2.tar.xz
cd inetutils-2.2

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make check
make install
mv -v /usr/{,s}bin/ifconfig

cd ..
rm -rf inetutils-2.2

##	Less

tar -xvf less-590.tar.gz
cd less-590

./configure --prefix=/usr --sysconfdir=/etc
make
make install

cd ..
rm -rf less-590


##	Perl

tar -xvf perl-5.34.0.tar.xz
cd perl-5.34.0

patch -Np1 -i ../perl-5.34.0-upstream_fixes-1.patch
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl      \
             -Darchlib=/usr/lib/perl5/5.34/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads
make
make test
make install
unset BUILD_ZLIB BUILD_BZIP2

cd ..
rm -rf perl-5.34.0


##	XML

tar -xvf XML-Parser-2.46.tar.gz
cd XML-Parser-2.46

perl Makefile.PL
make
make test
make install

cd ..
rm -rf XML-Parser-2.46


##	Init

tar -xvf intltool-0.51.0.tar.gz
cd intltool-0.51.0

sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

cd ..
rm -rf intltool-0.51.0


##	Autoconf

tar -xvf autoconf-2.71.tar.xz
cd autoconf-2.71

./configure --prefix=/usr
make
make check
make install


cd ..
rm -rf autoconf-2.71


##	Automake

tar -xvf automake-1.16.5.tar.xz
cd automake-1.16.5

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5
make
make -j4 check
make install

cd ..
rm -rf automake-1.16.5
