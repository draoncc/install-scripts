#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

if dpkg -s nginx &>/dev/null; then
	log_info "nginx is already installed"
else
	sudo apt -y install nginx
fi
