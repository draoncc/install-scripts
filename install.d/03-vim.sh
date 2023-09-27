#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed curl

if assert_is_installed nvim; then
	log_info "nvim is already installed"
else
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update
	sudo apt install -y neovim
fi

sudo apt -y install python3-pip
pip3 install pynvim
