#!/bin/bash
set -e

for script in $(dirname "$(readlink -f "$BASH_SOURCE")")/install.d/*.sh; do
	source "$script"
done
