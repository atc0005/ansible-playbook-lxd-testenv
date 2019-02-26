# Ansible Playbook: lxd-setup-host.yml

## WARNING

This playbook does not actually *do* anything yet. The role referenced by this
playbook is a stub only. When that role is finally fleshed out to actually
setup a host this section will be removed.

## Table of contents

- [Ansible Playbook: lxd-setup-host.yml](#ansible-playbook-lxd-setup-hostyml)
  - [WARNING](#warning)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Limitations](#limitations)
  - [Requirements](#requirements)
    - [Install roles](#install-roles)
    - [Install LXD packages, perform initial configuration](#install-lxd-packages-perform-initial-configuration)
  - [Usage](#usage)
  - [Playbook runtime](#playbook-runtime)
  - [References](#references)

## Overview

A small playbook that uses the `atc0005.lxd-host` role to configure an Ubuntu
system to run LXD containers.

The [`lxd-remove.yml`](lxd-remove.md) playbook is intended to tear down the
test environment as needed in order to refresh the environment. While it does
remove container-specific settings from the host, it does not remove any
packages or system-wide changes made to the host which are not container
specific (e.g., creation of NAT bridge, etc.)

## Limitations

- This playbook relies upon the `atc0005.lxd-host` role. As of this writing it
  is only compatible with Ubuntu. Because of this, this playbook is only
  compatible with Ubuntu.

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

`ansible-playbook -i inventories/testing lxd-setup-host.yml -K`

This step is handled automatically as part of using the site-wide playbook,
`site.yml`:

`ansible-playbook -i inventories/testing site.yml -K`

## Playbook runtime

N/A (see WARNING above)

## References

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>
- <https://github.com/atc0005/ansible-playbook-lxd-testenv/blob/master/README.md>
