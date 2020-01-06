#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed add-apt-repository

if dpkg -s mariadb-server &>/dev/null; then log_info "mariadb is already installed"
else
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
  sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://ftp.icm.edu.pl/pub/unix/database/mariadb/repo/10.2/ubuntu bionic main'

  sudo apt update
  sudo apt -y install mariadb-server
fi
