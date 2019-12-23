#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

xinput set-prop "SYNA3092:00 06CB:CD78 Touchpad" "libinput Tapping Enabled" 1
