#/bin/bash

./configure --with-features=huge \
	--enable-cscope \
	--enable-python3interp=yes \
	--enable-multibyte \
	--enable-fontset \
	--disable-gui \
	--disable-netbeans \
	--enable-luainterp=yes \
	--enable-largefile

make && sudo make install
