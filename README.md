# Manage Virtualization Hypervisor via ansible

Create virtualized environment which mimic home network. 

## Network Architecture
![Network architecture](/network_diagram.png) 

## Prepare environment
```
pip install -r requirements.txt
```
```
ansible-galaxy collection install community.libvirt
ansible-galaxy collection install community.general
```

## Configure environment
```
ansible-playbook -i <ip>, set-up.yml -u <username>
```

Example:
```
ansible-playbook -i 10.0.0.26, set-up.yml -u user
```

## Create VM
```
ansible-playbook -i <ip>, create-vm.yml -u <username> -e vm_name=<vm_name>
```

Example:
```
ansible-playbook -i 10.0.0.26, create-vm.yml -u user -e vm_name=vm0
```

## Delete VM
```
ansible-playbook -i <ip>, delete-vm.yml -u <username> -e vm_name=<vm_name>
```

Example:
```
ansible-playbook -i 10.0.0.26, delete-vm.yml -u user -e vm_name=vm0
```

## List snapshots
```
ansible-playbook -i <ip>, list-snapshot.yml -u <username> -e vm_name=<vm_name>
```

Example:
```
ansible-playbook -i 10.0.0.26, list-snapshot.yml -u user -e vm_name=vm0
```


## Create snapshot
```
ansible-playbook -i <ip>, create-snapshot.yml -u <username> -e vm_name=<vm_name> -e snapshot_name=<snaphot_name>
```

Example:
```
ansible-playbook -i 10.0.0.26, create-snapshot.yml -u user -e vm_name=vm0 -e snapshot_name=fresh_install
```

## Restore snapshot
```
ansible-playbook -i <ip>, restore-snapshot.yml -u <username> -e vm_name=<vm_name> -e snapshot_name=<snaphot_name>
```

Example:
```
ansible-playbook -i 10.0.0.26, restore-snapshot.yml -u user -e vm_name=vm0 -e snapshot_name=fresh_install
```
