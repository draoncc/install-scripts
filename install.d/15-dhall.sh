#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed curl

if assert_is_installed dhall; then
	log_info "dhall is already installed"
else
	cd $(mktemp -d)

	curl -s https://api.github.com/repos/dhall-lang/dhall-haskell/releases/latest |
		grep "browser_download_url.*-linux.tar.bz2" |
		cut -d : -f 2,3 |
		tr -d \" |
		wget -i -

	for file in dhall-*-linux.tar.bz2; do
		tar -jxf "$file"
	done

	install -C bin/* $HOME/.local/bin
fi
