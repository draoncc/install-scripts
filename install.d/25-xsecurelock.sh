#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git

# TODO: figure out a way to tell the user scrot & libvips-tools is required

if assert_is_installed xsecurelock; then log_info "xsecurelock is already installed"
else
  sudo apt -y install \
    apache2-utils \
    autotools-dev \
    binutils \
    gcc \
    libc6-dev \
    libpam-dev \
    libx11-dev \
    libxcomposite-dev \
    libxext-dev \
    libxfixes-dev \
    libxft-dev \
    libxmuu-dev \
    libxrandr-dev \
    libxss-dev \
    make \
    pamtester \
    pkg-config \
    x11proto-core-dev

  cd /tmp
  git clone https://github.com/google/xsecurelock.git && cd xsecurelock
  sh autogen.sh
  ./configure --with-pam-service-name=common-auth
  make && sudo make install

  cp "$SCRIPT_PATH/${SCRIPT_NAME%.*}.d/saver_pixelate" /usr/local/libexec/xsecurelock/saver_pixelate
  cp "$SCRIPT_PATH/${SCRIPT_NAME%.*}.d/run-xsecurelock.sh" $HOME/.local/bin/run-xsecurelock.sh
fi
