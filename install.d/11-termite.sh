#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git

sudo apt -y install \
	g++ \
	libgtk-3-dev \
	gtk-doc-tools \
	gnutls-bin \
	valac \
	intltool \
	libpcre2-dev \
	libglib3.0-cil-dev \
	libgnutls28-dev \
	libgirepository1.0-dev \
	libxml2-utils \
	gperf

if assert_is_installed termite; then log_info "termite is already installed"
else
	cd /tmp
	git clone https://github.com/thestinger/vte-ng.git && cd vte-ng
	echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
	./autogen.sh && make && sudo make install

	cd /tmp
	git clone --recursive https://github.com/thestinger/termite.git && cd termite
	make && sudo make install

	sudo ldconfig
	sudo mkdir -p /lib/terminfo/x; sudo ln -s \
		/usr/local/share/terminfo/x/xterm-termite \
		/lib/terminfo/x/xterm-termite

	sudo update-alternatives --install \
		/usr/bin/x-terminal-emulator \
		x-terminal-emulator \
		/usr/local/bin/termite 60
fi
