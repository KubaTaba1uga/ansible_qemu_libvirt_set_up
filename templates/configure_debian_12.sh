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

  expect "Escape character is"  {send "\r"}
  expect "localhost login:"  {send "root\r"}
  # Fix not working sshd 
  expect "root@localhost*" {send "cd /etc/ssh/ ; ssh-keygen -A\r"}
  # Add $SUDO_USER keys to VM's authorized keys
  expect "root@localhost*" {send "mkdir -p /root/.ssh && echo $ssh_key >> /root/.ssh/authorized_keys\r"}
  # Change hostname
  expect "root@localhost*" {send "echo {{ vm_name }} > /etc/hostname \r"}
  # Grow disk
  expect "root@localhost*" {send "growpart /dev/vda 1\r"}
  expect "root@localhost*" {send "resize2fs /dev/vda1\r"}
  # Outro - DON'T TOUCH
  expect "root@localhost*" {send "\r"}
  expect "root@localhost*" {send "reboot now\r"}
  expect "root@localhost*" {send "\r"}

EOF

