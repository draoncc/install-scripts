#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if assert_is_installed nvim; then log_info "nvim is already installed"
else
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/bin/nvim.appimage
  sudo ln -s /usr/bin/nvim.appimage /usr/bin/nvim
fi

sudo apt -y install python-pip python3-pip
pip2 install pynvim
pip3 install pynvim
