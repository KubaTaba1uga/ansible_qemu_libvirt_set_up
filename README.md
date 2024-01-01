# Manage Virtualization Hypervisor via ansible

## Prepare environment
Before proceeding further make sure that You have ansible installed in Your current python's environment.

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

## Network Architecture
![Network architecture](/network.svg)
