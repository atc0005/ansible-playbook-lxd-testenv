# Ansible Playbook: docker-setup.yml

## Table of Contents

- [Ansible Playbook: docker-setup.yml](#ansible-playbook-docker-setupyml)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Limitations](#limitations)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [References](#references)

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
1. [Install required roles](install-roles.md)

## Usage

Run playbook against relevant inventory. In this case, we target our
testing inventory from the main directory:

`ansible-playbook -i inventories/testing docker-setup.yml -K`

This step is handled automatically as part of using the site-wide playbook,
`site.yml`:

`ansible-playbook -i inventories/testing site.yml -K`

## References

- <https://github.com/atc0005/ansible-role-docker-host>
- <https://github.com/atc0005/ansible-role-docker-host/blob/master/README.md>
