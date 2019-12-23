#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

if ! assert_is_installed cargo; then
	source $HOME/.cargo/env
	echo "export PATH=\$PATH:\$HOME/.cargo/bin" | tee -a $HOME/.zshrc
fi
