# lxd-testenv playbooks

*Small suite of playbooks intended to help quickly spin up a test environment
for other playbook work.*

## Overview

| Name                       | Purpose (short)                                                      | Documentation                                                                |
| -------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `site.yml`                 | Call `lxd-setup.yml` and `docker-setup.yml`                          | [lxd-setup.yml](docs/lxd-setup.md), [docker-setup.yml](docs/docker-setup.md) |
| `docker-setup.yml`         | Install packages, configure specified hosts to run Docker containers | [playbook](docs/docker-setup.md)                                             |
| `lxd-setup-host.yml`       | Setup LXD container host to run test containers                      | [playbook](docs/lxd-setup.md)                                                |
| `lxd-setup-containers.yml` | Create LXD containers for testing purposes                           | [playbook](docs/lxd-setup.md)                                                |
| `lxd-remove.yml`           | Tear down LXD container test environment                             | [playbook](docs/lxd-remove.md)                                               |

See [lxd-timing](docs/lxd-timing.md) for *very* rough estimates on the time
needed to spinup/teardown a test environment.

## Limitations

### Linux Distributions

Tested on Ubuntu 16.04+ only. Future versions of these playbooks and associated
roles may add support for additional distributions.

### Docker storage driver

Some Docker storage options are currently incompatible with LXD containers.
For the most stable results, stick with the default `vfs` Docker storage
driver. While slower than other options, it works with LXD 'dir' and 'zfs'
storage. For better performance, use the `overlay` Docker storage driver if
your backing LXD filesystem supports it. As of this writing, the `overlay2`
Docker storage driver is not supported with LXD LTS 2.0.x or 3.0.x.

See the [Docker storage drivers](docs/docker-storage-drivers.md) doc for
details.

## Prerequisites

### Inventory

To effectively use this collection of `lxd-testenv` playbooks, you will need to
make sure you configure a test inventory entirely separate from your main
production or development environment. Roles used by this playbook do not
have the required polish and lack sufficient testing to safely interact with
any system of lasting value.

To serve as a starting point, a `testing` inventory has been provided that
already includes relevant settings needed by these playbooks.

### LXD packages

These playbooks require that you first install the LXD daemon and client
packages. After that, `sudo lxd init` should be used. The `atc0005.lxd-host`
role is intended to handle these steps, but as of this writing is only a stub
role. For now, install the `lxd` and `lxd-client` packages and then run `sudo
lxd init` and follow the instructions.

Note: Make sure to logout and then back in after completing the `lxd init`
menu-driven setup process in order to properly apply the new group membership.
Without this, the playbooks will be denied access to the LXD interface.

### LXD configuration

#### TL;DR

1. Insert any block devices that you wish to use with either LVM or ZFS storage
    - *you also have the option of going with `dir` LXD storage, though it is
      not as efficient as either LVM or ZFS with storage usage*
1. Run `sudo lxd init`
1. Answer questions; strongly consider going with NAT and IPv4 for simplicity

If you later find that you do not want the chosen settins, reconfigure LXD:

1. Run `sudo dpkg-reconfigure -p medium lxd`
1. Answer questions, providing the new settings as desired

#### Networking: NAT bridge

For most (playbook) testing purposes, **the NAT bridge will probably be
sufficient**.

A NAT bridge allows host-to-container and container-to-container connections
which covers many quick/one-off test cases that these playbooks and roles are
intended to support. Be sure to use NAT, DHCP and setup a bridge network
device (NAT). Containers created and attached to this bridge will be reachable
by the host (and each other), but will not be directly reachable by external
systems. To work around this on a small scale, you can setup port forwarding
rules.

For advanced use cases, you will need to setup a bridge that permits external
access to containers and then assign that profile to containers as needed.

See the [LXD Network configuration](#lxd-network-configuration) section for
various external guides that provide the necessary steps to accomplish this.

#### Networking: External bridge

If you wish to have external systems connect to LXD containers you will need
to configure a non-NAT bridge and use that for your containers.

Creating a separate non-NAT bridge can be done initially or after the initial
`sudo lxd init` setup process has completed.

- If setting up the bridge after the initial setup process, you will need to
  either create a new LXD profile or update the existing one.
  - If updating the existing profile, those changes will be applied
    automatically to containers already using it.
  - If setting up a new profile, you will need to apply or assign the new
    profile () to have the networking changes and then creating and applying a
    custom profile for containers that *should* be externally accessible
- If setting up the bridge during the initial `sudo lxd init` process you
  *should* be able to define all needed options during setup.
  - You can also setup the bridge *before* running `sudo lxd init` and then
    have LXD use the existing bridge. This will provide that bridge by default
    to all newly created containers.

As of playbook and `atc0005.lxd-testenv` role version 1.1, this playbook and
associated role can assign specified LXD profiles to containers, but you will
have to take care of creating the role(s) yourself.

See the [LXD Network configuration](#lxd-network-configuration) section for
various external guides that provide the necessary steps to accomplish this.

## Usage

### Install roles

See the guide [here](docs/install-roles.md) for the steps needed to install
roles required by these playbooks.

### Customize playbook variables

Each of the following playbooks have common active and inactive settings
configured which are intended to allow easy override of the base settings
defined within the `defaults/main.yml` file included within the
`atc0005.lxd-testenv` role.

While you *can* override those settings within the playbook, doing so at that
level applies the setting across *all* containers. You will likely get better
results by applying overrides at `group_vars` or even `host_vars` level.

For example, if you wish to use Ubuntu 18.04 (bionic) instead of the default
Ubuntu 16.04 (xenial), you should modify the `group_vars/ubuntu.yml` file to
specify the desired image instead of setting this as the playbook level where
it would override the CentOS 7 image specificed for CentOS containers.

See these docs for more information:

- [lxd-setup](docs/lxd-setup.md)
- [docker-setup](docs/docker-setup.md)

Review those settings and tweak as needed. See also the [README](#references)
for the `atc0005.lxd-testenv` role (listed as `ansible-role-lxd-testenv`) for
additional information for each supported option.

### Create new test environment

The following steps will prep the host to run LXD containers and then proceed
to spin up several CentOS and Ubuntu containers:

- `ansible-playbook -i inventories/testing site.yml -K`

Note: By default, at least one additional container will be spun up as a
Docker Host for testing Docker related playbooks. To disable this behavior,
edit `inventories/testing/hosts` to remove the `ansible-ubuntu-docker` host
entries and then modify the `site.yml` playbook to remove the inclusion of the
`docker-setup.yml` playbook.

See these docs for more information:

- [lxd-setup](docs/lxd-setup.md)
- [docker-setup](docs/docker-setup.md)

See [lxd-timing](docs/lxd-timing.md) for *very* rough estimates on the time
needed to spinup/teardown a test environment.

### Teardown test environment

- `ansible-playbook -i inventories/testing lxd-remove.yml -K`

See [this doc](docs/lxd-remove.md) for more information.

See [lxd-timing](docs/lxd-timing.md) for *very* rough estimates on the time
needed to spinup/teardown a test environment.

## References

### External

#### General

- [Generate /etc/hosts with Ansible](https://gist.github.com/rothgar/8793800)
- <https://docs.ansible.com/ansible/latest/modules/lxd_container_module.html>
- <https://stackoverflow.com/questions/30226113/ansible-ssh-prompt-known-hosts-issue>

#### LXD Network configuration

- <https://bayton.org/docs/linux/lxd/lxd-zfs-and-bridged-networking-on-ubuntu-16-04-lts/>
- <https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/>
- <https://discuss.linuxcontainers.org/t/how-to-create-a-non-nat-lxd-network-bridge-using-lxd-network/1547>
- <https://www.technibble.com/forums/threads/start-using-containers-on-ubuntu.74887/>
- <https://blog.ubuntu.com/2016/04/07/lxd-networking-lxdbr0-explained>

### Related repos

- <https://github.com/atc0005/ansible-playbooks>

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>

- <https://github.com/atc0005/ansible-role-lxd-host>
- <https://github.com/atc0005/ansible-role-lxd-testenv>
- <https://github.com/atc0005/ansible-role-docker-host>
