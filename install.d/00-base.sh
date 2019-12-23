#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

sudo apt -y install \
  curl \
  git

git config --global user.email "14227820+draoncc@users.noreply.github.com"
git config --global user.name "Draon con Color"
