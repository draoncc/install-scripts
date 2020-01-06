#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

if dpkg -s rofi &>/dev/null; then log_info "rofi is already installed"
else
  sudo add-apt-repository -y ppa:jasonpleau/rofi
  sudo apt update
  sudo apt -y install rofi

  cd /tmp
  git clone https://github.com/davatorium/rofi-themes && cd rofi-themes

  xdg=${XDG_DATA_HOME:-${HOME}/.local/share}
  DIRECTORY="${xdg}/rofi/themes/"

  if [ ! -d "${DIRECTORY}" ]; then
    echo "Creating theme directory: ${DIRECTORY}"
    mkdir -p "${DIRECTORY}"
  fi

  for themefile in **/*.rasi; do
    if [ -f "${themefile}" ] && [ ${ia} -eq 0 ]; then
      echo "+Overwriting '${themefile}'"
    else
      echo "+Installing '${themefile}'"
    fi

    install "${themefile}" "${DIRECTORY}"
  done
fi

if [ -f /usr/lib/x86_64-linux-gnu/rofi/calc.so ]; then log_info "rofi-calc is already installed"
else
  sudo apt -y install rofi-dev qalc libqalculate-dev

  cd /tmp
  git clone https://github.com/svenstaro/rofi-calc && cd rofi-calc
  autoreconf -i
  mkdir build && cd build
  ../configure
  make && sudo make install
fi
