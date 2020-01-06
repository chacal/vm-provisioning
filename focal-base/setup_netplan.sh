#!/usr/bin/env bash
set -e

NETPLAN_CONF=/etc/netplan/90-custom.yaml

sudo tee ${NETPLAN_CONF} >/dev/null <<'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: true
EOF
