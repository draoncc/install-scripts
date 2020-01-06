#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"
source $SCRIPT_PATH/../util.sh

error_if_not_installed git

if dpkg -s gopass &>/dev/null; then log_info "gopass is already installed"
else
  sudo apt -y install gnupg2 rng-tools

  wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -
  echo "deb https://dl.bintray.com/gopasspw/gopass bionic main" | sudo tee /etc/apt/sources.list.d/gopass.list

  sudo apt update
  sudo apt -y install gopass

  read_password password

  if [[ ! -z $password ]]; then
    readonly opts=$(mktemp)
    tee $opts <<EOF > /dev/null
%echo Generating OpenGPG key for usage with gopass
Key-Type: RSA
Key-Length: 4096
Name-Real: $(whoami)
Name-Comment: $(whoami)@$(hostname)
Expire-Date: 0
Passphrase: $password
%commit
%echo Done
EOF

    unset password
    gpg --batch --gen-key $opts
  else echo "Skipped GPG key generation. Make sure to generate a key for gopass (https://github.com/gopasspw/gopass/blob/master/docs/setup.md)"
  fi
fi
