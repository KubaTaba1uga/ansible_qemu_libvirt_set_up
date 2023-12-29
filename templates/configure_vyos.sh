#!/usr/bin/env bash

expect <<EOF

  set timeout 120
  spawn virsh console {{ vyos_vm_name }} --force

  expect "Escape character is*"  {send "\r"}
  expect "vyos login:*"  {send "vyos\r"}
  expect "Password:*"  {send "vyos\r"}
  expect "vyos@vyos:" {send "configure\r"}
  expect "vyos@vyos*" {send "set interfaces ethernet eth0 address {{ router_public_ip }} \r"}
  expect "vyos@vyos*" {send "set system name-server 1.1.1.1 \r"}
  expect "vyos@vyos*" {send "set system host-name {{ vyos_vm_name }} \r"}
  expect "vyos@vyos*" {send "commit \r"}
  expect "vyos@vyos*" {send "save \r"}
  expect "vyos@vyos*" {send "exit\r"}
  expect "vyos@vyos*" {send "exit\r"}

EOF
