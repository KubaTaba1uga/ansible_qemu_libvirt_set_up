#!/usr/bin/env bash

# fix bug with missing hostname keys
dpkg-reconfigure openssh-server

systemctl restart sshd


# fix networking bug
tee /etc/network/interfaces <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp1s0
iface enp1s0 inet dhcp

EOF

systemctl restart networking


