#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git

if dpkg -s libvips-tools &>/dev/null; then log_info "vips is already installed"
else
  sudo apt -y install libvips-tools
fi

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

  tee .local/bin/run-xsecurelock.sh <<EOF > /dev/null
#!/bin/bash
set -e

tmpfile=xsecurelock_saver_pixelate_screenshot

if [ ! -f "/tmp/\${tmpfile}.jpg" ]; then
  scrot "/tmp/\${tmpfile}.jpg" -q 100
  vips shrink "/tmp/\${tmpfile}.jpg" "/tmp/\${tmpfile}.v" 20 20
  vips zoom "/tmp/\${tmpfile}.v" "/tmp/\${tmpfile}.jpg" 20 20
  rm -f "/tmp/\${tmpfile}.v"
fi

XSECURELOCK_SHOW_DATETIME=1 \
XSECURELOCK_SHOW_HOSTNAME=0 \
XSECURELOCK_SHOW_USERNAME=1 \
XSECURELOCK_SAVER=saver_pixelate \
  exec xsecurelock
EOF

  sudo tee /usr/local/libexec/xsecurelock/saver_pixelate <<EOF > /dev/null
#!/bin/bash

tmpfile=xsecurelock_saver_pixelate_screenshot

if [ -f "/tmp/\${tmpfile}.jpg" ]; then
  unset x y w h
  eval \$(xwininfo -id \${XSCREENSAVER_WINDOW} |
    sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
           -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
           -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
           -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )

  xloadimage \
    -quiet \
    -windowid "\${XSCREENSAVER_WINDOW}" \
    -clip "\$x,\$y,\$w,\$h" \
    "/tmp/\${tmpfile}.jpg"

  rm -f "/tmp/\${tmpfile}.jpg"
fi
EOF
fi
