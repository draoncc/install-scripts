#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if dpkg -s libvips-tools &>/dev/null; then
	log_info "vips is already installed"
else
	sudo apt -y install libvips-tools
fi
