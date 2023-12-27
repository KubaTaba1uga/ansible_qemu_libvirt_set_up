# Manage Virtualization Hypervisor via ansible

## Prepare environment

```
ansible-galaxy collection install community.libvirt
ansible-galaxy collection install community.general
```

## Set up
```
ansible-playbook -i <ip>, set-up.yml -u <username>
```

Example:
```
ansible-playbook -i 10.0.0.26, set-up.yml -u user
```
