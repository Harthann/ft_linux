##  MAN PAGES ##

tar -xvf man-pages-5.13.tar.xz
cd man-pages-5.13

make prefix=/usr install

cd ..
rm -rvf man-pages-5.13

##	Iana-Etc-20220207	##

tar -xvf iana-etc-20220207.tar.gz
cd iana-etc-20220207

cp services protocols /etc

cd ..
rm -rvf iana-etc-20220207

##	Glibc-2.35	##

tar -xvf glibc-2.35.tar.xz
cd glibc-2.35

patch -Np1 -i ../glibc-2.35-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib
make
make check
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd


install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /usr/lib/systemd/system/nfsdcld.service

mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
make localedata/install-locales
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata2021e.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

cd ../..
rm -rvf glibc-2.35

##	Zlib-1.2.11	##
##	Bzip2-1.0.8	##
##	Xz-5.2.5	##
##	Zstd-1.5.2	##
##	File-5.41	##
##	Readline-8.1.2	##
##	M4-1.4.19	##
##	Bc-5.2.2	##
##	Flex-2.6.4	##
##	Tcl-8.6.12	##
##	Expect-5.45.4	##
##	DejaGNU-1.6.3	##
##	Binutils-2.38	##
##	GMP-6.2.1	##
##	MPFR-4.1.0	##
##	MPC-1.2.1	##
##	Attr-2.5.1	##
##	Acl-2.3.1	##
##	Libcap-2.63	##
##	Shadow-4.11.1	##
##	GCC-11.2.0	##
##	Pkg-config-0.29.2	##
##	Ncurses-6.3	##
##	Sed-4.8	##
##	Psmisc-23.4	##
##	Gettext-0.21	##
##	Bison-3.8.2	##
##	Grep-3.7	##
##	Bash-5.1.16	##
##	Libtool-2.4.6	##
##	GDBM-1.23	##
##	Gperf-3.1	##
##	Expat-2.4.6	##
##	Inetutils-2.2	##
##	Less-590	##
##	Perl-5.34.0	##
##	XML::Parser-2.46	##
##	Intltool-0.51.0	##
##	Autoconf-2.71	##
##	Automake-1.16.5	##
##	OpenSSL-3.0.1	##
##	Kmod-29	##
##	Libelf from Elfutils-0.186	##
##	Libffi-3.4.2	##
##	Python-3.10.2	##
##	Ninja-1.10.2	##
##	Meson-0.61.1	##
##	Coreutils-9.0	##
##	Check-0.15.2	##
##	Diffutils-3.8	##
##	Gawk-5.1.1	##
##	Findutils-4.9.0	##
##	Groff-1.22.4	##
##	GRUB-2.06	##
##	Gzip-1.11	##
##	IPRoute2-5.16.0	##
##	Kbd-2.4.0	##
##	Libpipeline-1.5.5	##
##	Make-4.3	##
##	Patch-2.7.6	##
##	Tar-1.34	##
##	Texinfo-6.8	##
##	Vim-8.2.4383	##
##	MarkupSafe-2.0.1	##
##	Jinja2-3.0.3	##
##	Systemd-250	##
##	D-Bus-1.12.20	##
##	Man-DB-2.10.1	##
##	Procps-ng-3.3.17	##
##	Util-linux-2.37.4	##
##	E2fsprogs-1.46.5 	##
