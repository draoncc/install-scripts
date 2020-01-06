#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git
error_if_not_installed cargo

if dpkg -s xorg &>/dev/null; then log_info "xorg is already installed"
else
  sudo apt -y install \
    xorg openbox \
    compton \
    feh \
    xsel
fi

if assert_is_installed i3; then log_info "i3 is already installed"
else
  sudo apt -y install \
    libxcb1-dev \
    libxcb-keysyms1-dev \
    libpango1.0-dev \
    libxcb-util0-dev \
    libxcb-icccm4-dev \
    libyajl-dev \
    libstartup-notification0-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-xrm-dev \
    libev-dev \
    libxcb-cursor-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    autoconf \
    xutils-dev \
    libtool \
    automake

	cd /tmp
	git clone https://github.com/Airblader/i3.git i3-gaps && cd i3-gaps
  git checkout gaps && git pull
	autoreconf --force --install
	rm -rf build
	mkdir build
	cd build
	../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
	make && sudo make install

	tee -a $HOME/.xinitrc <<EOF > /dev/null
setxkbmap -layout us -variant dvp -option compose:102 -option numpad:shift3 -option kpdl:semi -option keypad:atm -option caps:escape
exec i3
EOF

	tee -a $HOME/.profile <<EOF > /dev/null
if systemctl -q is-active graphical.target && [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then
  exec startx
fi
EOF
fi

if assert_is_installed i3status-rs; then log_info "i3status-rs is already installed"
else
	cd /tmp
	git clone https://github.com/greshake/i3status-rust && cd i3status-rust
	cargo build --release
	cp target/release/i3status-rs $HOME/.local/bin/i3status-rs
fi
