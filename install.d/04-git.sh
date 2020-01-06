#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if dpkg -s git &>/dev/null; then log_info "git is already installed"
else
  sudo apt -y install git

  git config --global user.email "14227820+draoncc@users.noreply.github.com"
  git config --global user.name "Draon con Color"
fi
