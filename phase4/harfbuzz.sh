mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dgraphite2=enabled &&
ninja

ninja install
