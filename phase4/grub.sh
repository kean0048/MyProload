mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-15.1.04.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     &&
unset TARGET_CC &&
make

make install &&
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
