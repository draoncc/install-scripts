#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git

if [[ -f "$HOME/.local/share/fonts/Ubuntu Mono derivative Powerline.ttf" ]]; then log_info "fonts-powerline is already installed"
else
  cd /tmp
  git clone https://github.com/powerline/fonts.git --depth 1 && cd fonts
  ./install.sh
fi
