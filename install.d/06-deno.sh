#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed curl

if assert_is_installed deno; then
	log_info "deno is already installed"
else
	curl -fsSL https://deno.land/install.sh | sh
fi
