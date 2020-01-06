#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if dpkg -s network-manager &>/dev/null; then log_info "network-manager is already installed"
else
  sudo apt -y install network-manager
  sudo systemctl start NetworkManager.service
  sudo systemctl enable NetworkManager.service
fi
