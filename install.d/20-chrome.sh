#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

sudo apt -y install gdebi-core

if assert_is_installed google-chrome; then log_info "google-chrome is already installed"
else
  cd /tmp
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo gdebi --n google-chrome-stable_current_amd64.deb
fi
