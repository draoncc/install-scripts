#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

error_if_not_installed yarn

if assert_is_installed tsserver; then
	log_info "tsserver is already installed"
else
	sudo yarn global add typescript typescript-language-server
fi
