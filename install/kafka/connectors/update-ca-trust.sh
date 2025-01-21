#!/bin/bash

if [[ -f /etc/sudoers ]] ; then
  if [ -n "$CA_CERTIFICATE_FILE" ]; then
    cp "$CA_CERTIFICATE_FILE" /etc/pki/ca-trust/source/anchors/
    sudo update-ca-trust
  fi
  sudo rm /etc/sudoers
fi
