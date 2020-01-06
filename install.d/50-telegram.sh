#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if assert_is_installed Telegram; then log_info "Telegram is already installed"
else
  wget https://telegram.org/dl/desktop/linux -O /tmp/tsetup.tar.xz
  tar -xf /tmp/tsetup.tar.xz -C $HOME/.local/bin --strip-components 1

  tee /tmp/telegram.desktop <<EOF > /dev/null
[Desktop Entry]
Type=Application
Name=Telegram
GenericName=Messaging App
Comment=Telegram Messenger
TryExec=Telegram
Exec=Telegram
Keywords=Messenger;messaging;
Terminal=false
EOF

  desktop-file-install --dir $HOME/.local/share/applications /tmp/telegram.desktop
fi
