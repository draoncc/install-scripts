#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed add-apt-repository

if dpkg -s golang-go &>/dev/null; then log_info "go is already installed"
else
  sudo add-apt-repository -y ppa:longsleep/golang-backports
  sudo apt update
  sudo apt -y install golang-go
fi
