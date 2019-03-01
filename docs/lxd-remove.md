# Ansible Playbook: lxd-remove.yml

## Table of Contents

- [Ansible Playbook: lxd-remove.yml](#ansible-playbook-lxd-removeyml)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Limitations](#limitations)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Playbook runtime](#playbook-runtime)
  - [References](#references)

## Overview

Small playbook that uses the `atc0005.lxd-testenv` role to tear down or remove
a LXD-based testing environment previously created by running the
[`lxd-setup.yml`](lxd-setup.md) playbook.

## Limitations

- This playbook relies upon the `atc0005.lxd-testenv` role and as of v1.1 that
  role is only compatible with Ubuntu. Because of this, this playbook is only
  compatible with Ubuntu.

## Requirements

1. Move into directory containing inventories and playbooks dir
1. [Install required roles](install-roles.md)

## Usage

Run playbook against relevant inventory. In this case, we target our
testing inventory from the main directory:

`ansible-playbook -i inventories/testing lxd-remove.yml -K`

Note: By not specifying a specific hosts list, Ansible will merge all host
lists together into one dynamic list and apply this playbook against all
matching hosts. Since this playbook specifices "all" as the target hosts
group, all of these hosts in the combined list will be targeted.

See the main [README](../README.md) for examples of targeting specific hosts
lists.

## Playbook runtime

Under a minute when using a SSD drive. Teardown time is nearly identical
between using 'dir' and 'zfs' LXD storage. See the [lxd-timing](lxd-timing.md)
doc for more details.

## References

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>
- <https://github.com/atc0005/ansible-playbook-lxd-testenv/blob/master/README.md>
