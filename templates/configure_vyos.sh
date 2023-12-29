#!/usr/bin/env vbash

source /opt/vyatta/etc/functions/script-template

configure
set interfaces ethernet eth1 address '172.16.0.2/16'
commit
save

