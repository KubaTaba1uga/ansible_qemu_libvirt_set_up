#!/usr/bin/env bash

expect <<EOF

  set timeout 300
  spawn virsh console {{ vyos_vm_name }} --force

  # Intro
  expect "Escape character is"  {send "\r"}
  expect "vyos login:"  {send "vyos\r"}
  expect "Password:"  {send "vyos\r"}
  expect "vyos@vyos*" {send "configure\r"}
  # Configure router OS
  expect "vyos@vyos*" {send "set system host-name '{{ vyos_vm_name }}'\r"}
  expect "vyos@vyos*" {send "set system name-server '208.67.222.222'\r"}
  expect "vyos@vyos*" {send "set system name-server '208.67.220.220'\r"}
  expect "vyos@vyos*" {send "set system name-server '94.140.14.14'\r"}
  expect "vyos@vyos*" {send "set system name-server '76.223.122.150'\r"}
  expect "vyos@vyos*" {send "set system static-host-mapping host-name 'router.lab' inet '{{ private_router_ip }}'\r"}
  expect "vyos@vyos*" {send "set system static-host-mapping host-name 'host.lab' inet '{{ private_bridge_ip }}'\r"}
  # Configure public interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth0 address '{{ public_router_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set protocols static route 0.0.0.0/0 next-hop '{{ public_bridge_ip }}'\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 outbound-interface name 'eth0'\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 source address '{{ private_network_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 translation address '{{ public_router_ip }}'\r"}
  # Configure private interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth1 address '{{ private_router_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE authoritative\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' default-router '{{ private_router_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' domain-name 'lab'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' name-server '{{ private_router_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' lease '86400'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 start '{{ private_network_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 stop '{{- private_network_ip | regex_replace('\d+$', '254') -}}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ private_router_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ private_bridge_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server host-decl-name\r"}
  expect "vyos@vyos*" {send "set service dhcp-server hostfile-update\r"}
  expect "vyos@vyos*" {send "set service dns forwarding system\r"}
  expect "vyos@vyos*" {send "set service dns forwarding listen-address '{{ private_router_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding allow-from '{{ private_network_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding authoritative-domain lab records a 'router' address '{{ private_router_ip }}'\r"}

  expect "vyos@vyos*" {send "set service dns forwarding dhcp eth1\r"}
  expect "vyos@vyos*" {send "set service ssh port 22\r"}
  expect "vyos@vyos*" {send "set service ssh listen-address '{{ private_router_ip }}'\r"}
  # Outro
  expect "vyos@vyos*" {send "commit\r"}
  expect "vyos@vyos*" {send "save\r"}
  expect "vyos@vyos*" {send "exit\r"}
  expect "vyos@vyos*" {send "exit\r"}

EOF

