#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed startx

if [ -f /usr/share/X11/xorg.conf.d/50-touchpad.conf ]; then log_info "touchpad is already configured"
else
  xinput set-prop "SYNA3092:00 06CB:CD78 Touchpad" "libinput Tapping Enabled" 1
  sudo tee /usr/share/X11/xorg.conf.d/50-touchpad.conf <<EOF > /dev/null
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "Tapping" "true"
EndSection
EOF
fi
