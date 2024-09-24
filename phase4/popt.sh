./configure --prefix=/usr --disable-static &&
make

make install

install -v -m755 -d /usr/share/doc/popt-1.19 &&
