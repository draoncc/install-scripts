#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed curl
error_if_not_installed add-apt-repository

if dpkg -s docker-ce &>/dev/null; then
	log_info "docker is already installed"
else
	sudo apt -y install \
		apt-transport-https \
		ca-certificates \
		gnupg-agent

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

	sudo apt update
	sudo apt -y install docker-ce docker-ce-cli containerd.io

	sudo usermod -aG docker $USER
	newgrp docker

	sudo systemctl enable docker
fi
