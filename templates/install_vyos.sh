#!/usr/bin/env bash

expect <<EOF

  set timeout 120
  spawn virsh console {{ vyos_vm_name }} --force

  expect "Escape character is"  {send "\r"}
  expect "vyos login:"  {send "vyos\r"}
  expect "Password:"  {send "vyos\r"}
  expect "vyos@vyos:" {send "install image\r"}
  expect "Would you like to continue\?*" {send "y\r"}
  expect "What would you like to name this image\?*" {send "1.4\r"}
  expect "Please enter a password*" {send "vyos\r"}
  expect "What console*" {send "\r"}
  expect "Which one should be used for installation\?*" {send "\r"}
  expect "Installation will delete all data on the drive. Continue\?*" {send "y\r"}
  expect "Would you like to use all the free space on the drive\?*" {send "y\r"}
  expect "vyos@vyos*" {send "reboot now\r"}

EOF
