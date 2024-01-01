#!/usr/bin/env bash

ssh_key_file="/home/$SUDO_USER/.ssh/id_rsa.pub"

if [ ! -f "$ssh_key_file" ]; then
    mkdir -p /home/$SUDO_USER/.ssh
    ssh-keygen -t rsa -f /home/$SUDO_USER/.ssh/id_rsa -N '' -P ''
    chown $SUDO_USER -R /home/$SUDO_USER/.ssh/
fi

ssh_key=$(cat $ssh_key_file)

expect <<EOF

  set timeout 300
  spawn virsh console {{ vm_name }} --force

  # Fix not working ssh
  expect "Escape character is"  {send "\r"}
  expect "localhost login:"  {send "root\r"}
  expect "root@localhost*" {send "cd /etc/ssh/ ; ssh-keygen -A\r"}
  expect "root@localhost*" {send "mkdir -p /root/.ssh && echo $ssh_key >> /root/.ssh/authorized_keys\r"}
  expect "root@localhost*" {send "echo {{ vm_name }} > /etc/hostname \r"}
  expect "root@localhost*" {send "\r"}
  expect "root@localhost*" {send "\r"}
  expect "root@localhost*" {send "reboot now\r"}
  expect "root@localhost*" {send "\r"}
  # Wait for OS to reboot
  expect "root@localhost*" {send "Debian GNU/Linux 12 localhost\r"}
  

EOF

