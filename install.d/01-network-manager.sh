#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

sudo apt -y install network-manager
sudo systemctl start NetworkManager.service
sudo systemctl enable NetworkManager.service
