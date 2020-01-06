#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed curl

if dpkg -s yarn &>/dev/null; then log_info "yarn is already installed"
else
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt update
  sudo apt -y install yarn
fi

if assert_is_installed n; then log_info "n is already installed"
else
  sudo yarn global add n
  sudo n "8.11.3"
fi
