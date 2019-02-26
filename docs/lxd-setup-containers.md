# Ansible Playbook: lxd-setup-containers.yml

## Table of Contents

- [Ansible Playbook: lxd-setup-containers.yml](#ansible-playbook-lxd-setup-containersyml)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Limitations](#limitations)
  - [Requirements](#requirements)
    - [Install roles](#install-roles)
    - [Install LXD packages, perform initial configuration](#install-lxd-packages-perform-initial-configuration)
  - [Usage](#usage)
  - [Playbook runtime](#playbook-runtime)
  - [References](#references)

## Overview

Small playbook that uses the `atc0005.lxd-testenv` role to create a LXD-based
testing environment. The [`lxd-remove.yml`](lxd-remove.md) playbook is
intended to tear down the test environment as needed in order to refresh the
environment.

## Limitations

- This playbook relies upon the `atc0005.lxd-testenv` role and as of v1.1 that
  role is only compatible with Ubuntu. Because of this, this playbook is only
  compatible with Ubuntu.

- This playbook imports the `atc0005.lxd-host` role, but as of this writing
  that role is not ready for actual use and only echoes a placeholder debug
  statement.

## Requirements

### Install roles

1. Move into directory containing inventories, and playbooks dir
1. [Install required roles](install-roles.md)

### Install LXD packages, perform initial configuration

For now, see the `atc0005.lxd-testenv` role [README](#references) for the
specific packages and steps needed to prepare an Ubuntu system to run LXD
containers for local testing purposes.

## Usage

Run playbook against relevant inventory. In this case, we target our
testing inventory from the main directory:

`ansible-playbook -i inventories/testing lxd-setup-containers.yml -K`

This step is handled automatically as part of using the site-wide playbook,
`site.yml`:

`ansible-playbook -i inventories/testing site.yml -K`

## Playbook runtime

This playbook takes on average around 8-10 minutes to run. This appears to be
irregardless of whether you use LXD `dir` or `zfs` storage when backed by
physical SSD storage. See the [lxd-timing](lxd-timing.md) doc for more
details.

Have a cup of tea or coffee while you wait. :)

## References

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>
- <https://github.com/atc0005/ansible-playbook-lxd-testenv/blob/master/README.md>
