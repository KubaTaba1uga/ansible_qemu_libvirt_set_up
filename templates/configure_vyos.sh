#!/usr/bin/env bash

expect <<EOF

  set timeout 120
  spawn virsh console {{ vyos_vm_name }} --force

  # Intro
  expect "Escape character is"  {send "\r"}
  expect "vyos login:"  {send "vyos\r"}
  expect "Password:"  {send "vyos\r"}
  expect "vyos@vyos*" {send "configure\r"}
  expect "vyos@vyos*" {send "set system host-name '{{ vyos_vm_name }}'\r"}
  expect "vyos@vyos*" {send "set system name-server '8.8.8.8'\r"}
  # Configure public interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth0 address '{{ router_public_ip }}/{{ ip_cidr_netmask }}'\r"}
  # expect "vyos@vyos*" {send "set protocols static route 0.0.0.0/0 next-hop '{{ public_bridge_ip }}'\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 outbound-interface eth0\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 source address '{{ private_network_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set nat source rule 100 translation address '{{ router_public_ip }}'\r"}
  # Configure private interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth1 address '{{ router_private_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' default-router '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE authoritartive\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' domain-name 'lab'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' name-server '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' lease '86400'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 start '{{ private_network_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 stop '{{- private_network_ip | regex_replace('\d+$', '254') -}}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ private_bridge_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server host-decl-name\r"}
  expect "vyos@vyos*" {send "set service dns forwarding system\r"}
  expect "vyos@vyos*" {send "set service dns forwarding cache-size '0'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding listen-address '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding allow-from '{{ private_network_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding dhcp eth1\r"}
  expect "vyos@vyos*" {send "set service ssh port 22\r"}
  expect "vyos@vyos*" {send "set service ssh listen-address '{{ router_private_ip }}'\r"}
  # Outro
  expect "vyos@vyos*" {send "commit\r"}
  expect "vyos@vyos*" {send "save\r"}
  expect "vyos@vyos*" {send "exit\r"}
  expect "vyos@vyos*" {send "exit\r"}

EOF

