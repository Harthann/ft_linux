tar -xf vim-8.2.4383.tar.gz
cd vim-8.2.4383

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
chown -Rv tester .
su tester -c "LANG=en_US.UTF-8 make -j1 test" &> vim-test.log
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.4383

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

cd /sources
rm -rf vim-8.2.4383


tar -xf MarkupSafe-2.0.1.tar.gz
cd MarkupSafe-2.0.1

python3 setup.py build
python3 setup.py install --optimize=1

cd /sources
rm -rf MarkupSafe-2.0.1

tar -xf Jinja2-3.0.3.tar.gz
cd Jinja2-3.0.3

python3 setup.py install --optimize=1

cd /sources
rm -rf Jinja2-3.0.3

tar -xf systemd-250.tar.gz
cd systemd-250

patch -Np1 -i ../systemd-250-upstream_fixes-1.patch
sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
mkdir -p build
cd       build

meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-250 \
      ..
ninja
ninja install
tar -xf ../../systemd-man-pages-250.tar.xz --strip-components=1 -C /usr/share/man
rm -rf /usr/lib/pam.d
systemd-machine-id-setup
systemctl preset-all

cd /sources
rm -rf systemd-250


tar -xvf dbus-1.12.20.tar.gz
cd dbus-1.12.20

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket
make
make install
ln -sfv /etc/machine-id /var/lib/dbus

cd /sources
rm -rf dbus-1.12.20


tar -xf man-db-2.10.1.tar.xz
cd man-db-2.10.1

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.10.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap
make
make check
make install

cd /sources
rm -rf man-db-2.10.1

tar -xf procps-ng-3.3.17.tar.xz
cd procps-ng-3.3.17

./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd
make
make check
make install

cd /sources
rm -rf procps-ng-3.3.17


tar -xf util-linux-2.37.4.tar.xz
cd util-linux-2.37.4

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --sbindir=/usr/sbin  \
            --docdir=/usr/share/doc/util-linux-2.37.4 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python
make


cd /sources
rm -rf util-linux-2.37.4
