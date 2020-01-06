#!/bin/bash

set -e

readonly PPWD=$PWD

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with sudo"
  exit 1
fi

function prompt {
  while true; do
    read -p "$1 (y|n)" yn
    case $yn in
      [Yy]* ) return 0; break;;
      [Nn]* ) return 1;;
      * ) continue;;
    esac
  done
}

KERNEL_VERSION=5.1.21
KERNEL_VERSION_URL=5.1.21-050121
KERNEL_TIMESTAMP=201907280731

# Download kernel
mkdir -p /tmp/kernel
cd /tmp/kernel

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v${KERNEL_VERSION}/linux-headers-${KERNEL_VERSION_URL}_${KERNEL_VERSION_URL}.${KERNEL_TIMESTAMP}_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v${KERNEL_VERSION}/linux-headers-${KERNEL_VERSION_URL}-generic_${KERNEL_VERSION_URL}.${KERNEL_TIMESTAMP}_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v${KERNEL_VERSION}/linux-image-unsigned-${KERNEL_VERSION_URL}-generic_${KERNEL_VERSION_URL}.${KERNEL_TIMESTAMP}_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v${KERNEL_VERSION}/linux-modules-${KERNEL_VERSION_URL}-generic_${KERNEL_VERSION_URL}.${KERNEL_TIMESTAMP}_amd64.deb

dpkg -i *.deb
update-grub
cd $PPWD

prompt "Continue signing kernel?"
if [[ $? -ne 0 ]]; then exit 1; fi

# Sign kernel
mkdir -p /root/module-signing
cd /root/module-signing

openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=FoxBase GmbH/"
openssl x509 -in MOK.der -inform DER -outform PEM -out MOK.pem
chmod 600 MOK.priv

sbsign --key MOK.priv --cert MOK.pem /boot/vmlinuz-${KERNEL_VERSION_URL}-generic --output /boot/vmlinuz-${KERNEL_VERSION_URL}-generic.signed
cp /boot/initrd.img-${KERNEL_VERSION_URL}-generic /boot/initrd.img-${KERNEL_VERSION_URL}-generic.signed

mokutil --import /root/module-signing/MOK.der

update-grub
cd $PPWD
