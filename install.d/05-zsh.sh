#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if dpkg -s zsh &>/dev/null; then log_info "zsh is already installed"
else
  sudo apt -y install zsh
fi

if [[ $SHELL != $(which zsh) ]]; then
  chsh -s $(which zsh)
fi

if assert_is_installed antibody; then log_info "antibody is already installed"
else
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
  antibody bundle < $HOME/.zsh_plugins > $HOME/.zsh_plugins.sh
fi

sudo apt -y install python3-pip
pip3 install thefuck

