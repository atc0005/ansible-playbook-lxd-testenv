# Ansible Playbook: lxd-remove.yml

## Overview

Small playbook that uses the `atc0005.lxd-testenv` role to tear down or remove
a LXD-based testing environment previously created by running the
[`lxd-setup.yml`](lxd-setup.md) playbook.

## Limitations

- This playbook relies upon the `atc0005.lxd-testenv` role and as of v1.0 that
  role is only compatible with Ubuntu. Because of this, this playbook is only
  compatible with Ubuntu.

## Requirements

1. Move into directory containing inventories and playbooks dir
1. Install required roles
    - `ansible-galaxy install -r requirements.yml -p roles --force`

## Usage

Run playbook against relevant inventory. In this case, we target our
testing inventory from the main directory:

`ansible-playbook -i inventories/testing lxd-remove.yml -K`

## Playbook runtime

About 2-3 minutes when using a SSD drive.

## References

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>
- <https://github.com/atc0005/ansible-playbook-lxd-testenv/blob/master/README.md>
