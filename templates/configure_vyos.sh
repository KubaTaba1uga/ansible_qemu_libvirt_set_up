#!/usr/bin/env bash

VYOS_CONFIG_CONTENT="$(cat <<-EOF
	set system host-name '{{ vyos_vm_name }}'
	set system name-server '208.67.222.222'
	set system name-server '208.67.220.220'
	set system name-server '94.140.14.14'
	set system name-server '76.223.122.150'
	set system static-host-mapping host-name 'router.lab' inet '{{ private_router_ip }}'
	set system static-host-mapping host-name 'host.lab' inet '{{ private_bridge_ip }}'
	set interfaces ethernet eth0 address '{{ public_router_ip }}/{{ ip_cidr_netmask }}'
	set protocols static route 0.0.0.0/0 next-hop '{{ public_bridge_ip }}'
	set nat source rule 100 outbound-interface name 'eth0'
	set nat source rule 100 source address '{{ private_network_ip }}/{{ ip_cidr_netmask }}'
	set nat source rule 100 translation address '{{ public_router_ip }}'
	set interfaces ethernet eth1 address '{{ private_router_ip }}/{{ ip_cidr_netmask }}'
	set service dhcp-server shared-network-name PRIVATE authoritative
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' default-router '{{ private_router_ip }}'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' domain-name 'lab'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' name-server '{{ private_router_ip }}'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' lease '86400'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 start '{{ private_network_ip }}'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' range 0 stop '{{- private_network_ip | regex_replace('\d+$', '254') -}}'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ private_router_ip }}'
	set service dhcp-server shared-network-name PRIVATE subnet '{{ private_network_ip }}/{{ ip_cidr_netmask }}' exclude '{{ private_bridge_ip }}'
	set service dhcp-server host-decl-name
	set service dhcp-server hostfile-update
	set service dns forwarding system
	set service dns forwarding listen-address '{{ private_router_ip }}'
	set service dns forwarding allow-from '{{ private_network_ip }}/{{ ip_cidr_netmask }}'
	set service dns forwarding authoritative-domain lab records a 'router' address '{{ private_router_ip }}'
	set service dns forwarding dhcp eth1
	set service ssh port 22
	set service ssh listen-address '{{ private_router_ip }}'

EOF
)"

generate_config_expect()
{
    local vls vl

    readarray -t vls <<<"$VYOS_CONFIG_CONTENT"

    for vl in "${vls[@]}"
    do
        printf "expect \"vyos@vyos*\" {send \"%s\\r\"}\n" "$vl"
    done
}

expect <<EOF

  set timeout 300
  spawn virsh console {{ vyos_vm_name }} --force

  # Intro
  expect "Escape character is"  {send "\r"}
  expect "vyos login:"  {send "vyos\r"}
  expect "Password:"  {send "vyos\r"}
  expect "vyos@vyos*" {send "configure\r"}
  $(generate_config_expect)
  # Outro
  expect "vyos@vyos*" {send "commit\r"}
  expect "vyos@vyos*" {send "save\r"}
  expect "vyos@vyos*" {send "exit\r"}
  expect "vyos@vyos*" {send "exit\r"}

EOF
