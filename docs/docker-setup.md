# Ansible Playbook: docker-setup.yml

## Overview

Small playbook that uses the `atc0005.docker-host` role to install Docker
related packages (APT, pip) for managing and running Docker containers. That
role is often paired with the [`lxd-setup.yml`](lxd-setup.md) playbook for
installing Docker within LXD containers for isolated testing.

## Limitations

- The `atc0005.docker-host` role (as of v1.0) is only compatible with Ubuntu,
  therefore this playbook is only compatible with Ubuntu.

## Requirements

1. Move into directory containing inventories and playbooks dir
1. Install required roles
    - `ansible-galaxy install -r requirements.yml -p roles --force`

## Usage

Run playbook against relevant inventory. In this case, we target our
testing inventory from the main directory:

`ansible-playbook -i inventories/testing docker-setup.yml -K`

## References

- <https://github.com/atc0005/ansible-role-docker-host>
- <https://github.com/atc0005/ansible-role-docker-host/blob/v1.0/README.md>
