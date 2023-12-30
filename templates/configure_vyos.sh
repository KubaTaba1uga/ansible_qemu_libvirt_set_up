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
  expect "vyos@vyos*" {send "set system name-server '1.1.1.1'\r"}
  # Configure public interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth0 address '{{ router_public_ip }}/{{ ip_cidr_netmask }}'\r"}
  # Configure private interface
  expect "vyos@vyos*" {send "set interfaces ethernet eth1 address '{{ router_private_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}' default-router '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}' domain-name 'private'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}' lease '86400'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}' range 100 start '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dhcp-server shared-network-name PRIVATE subnet '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}' exclude '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding cache-size '0'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding listen-address '{{ router_private_ip }}'\r"}
  expect "vyos@vyos*" {send "set service dns forwarding allow-from '{{ private_bridge_ip }}/{{ ip_cidr_netmask }}'\r"}
  expect "vyos@vyos*" {send "set service ssh \r"}
  expect "vyos@vyos*" {send "set service ssh listen-address '{{ router_private_ip }}:22'\r"}
  # Outro
  expect "vyos@vyos*" {send "commit\r"}
  expect "vyos@vyos*" {send "save\r"}
  expect "vyos@vyos*" {send "exit\r"}
  expect "vyos@vyos*" {send "exit\r"}

EOF

