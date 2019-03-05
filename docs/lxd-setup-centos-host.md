# Setting up a CentOS host to run lxd-testenv playbooks

## Overview

The following steps *appear* to be needed in order to setup a CentOS system to
run the playbooks in this repo via UNIX socket, or alternatively, via
localhost HTTPS REST API.

See the linked LinuxContainers.org threads in the [References](#references)
section for more information.

## Table of Contents

- [Setting up a CentOS host to run lxd-testenv playbooks](#setting-up-a-centos-host-to-run-lxd-testenv-playbooks)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Installation steps](#installation-steps)
    - [Prerequisites](#prerequisites)
      - [Package installation, basic configuration](#package-installation-basic-configuration)
      - [Apply required kernel/namespace changes](#apply-required-kernelnamespace-changes)
    - [UNIX-socket access](#unix-socket-access)
    - [HTTPS API ACCESS](#https-api-access)
  - [References](#references)

## Installation steps

### Prerequisites

These steps need to be performed regardless of which direction we go later.

#### Package installation, basic configuration

1. `sudo yum install epel-release`
1. `sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7`
1. `sudo yum check-update`
1. `sudo yum install snapd ansible git`
1. `sudo systemctl enable --now snapd.socket`
1. OPTIONAL: `sudo ln -s /var/lib/snapd/snap /snap`
    - Note: This does not appear to be needed for LXD use, only for "classic"
      snap packages. LXD does not appear to be distributed as a classic snap
      package, so this is entirely optional

#### Apply required kernel/namespace changes

*These steps were provided on the "LXD on CentOS 7" Linux Containers Forum
thread (see [References](#references) section) and are required in order
to have LXD operate properly (at least for our purposes).*

1. `sudo grubby --args="user_namespace.enable=1" --update-kernel="$(grubby --default-kernel)"`
1. `sudo grubby --args="namespace.unpriv_enable=1" --update-kernel="$(grubby --default-kernel)"`
1. `sudo bash -c 'echo "user.max_user_namespaces=3883" > /etc/sysctl.d/99-userns.conf'`
1. `sudo reboot`

**Note**: There were some concerns expressed on that forum thread that these
steps will not persist between kernel upgrades. I have not confirmed whether
that is the case.

### UNIX-socket access

1. `sudo snap install lxd`
1. `sudo usermod -a -G lxd $USER`
1. logout
1. `sudo /var/lib/snapd/snap/bin/lxd init`

The UNIX socket at `/var/snap/lxd/common/lxd/unix.socket` is now available
for use with Ansible.

### HTTPS API ACCESS

This access requires a client certificate and key. LXD versions 3.0 and
greater appear to only generate these files when adding a remote, not on first
use of `lxc`. To work around that, we add our "remote" explicitly.

1. Install LXD via snap using a channel/version of your choice
   - tested on v3.0, v3.10
   - `sudo snap install lxd`
1. Add your user account to the `lxd` group
   - `sudo usermod -a -G lxd $USER`
   - *I am not 100% sure this is actually needed for HTTPS REST API access,
     but adding your account to this group also opens up UNIX socket access*
1. Initialize LXD, choosing to connect LXD to the network on 127.0.0.1
   - `sudo /var/lib/snapd/snap/bin/lxd init`
1. Add new "remote" that references the localhost HTTPS REST API
   - `lxc remote add local-rest-api https://127.0.0.1:8443`
   - at this point the client cert/key pair are created

Output from `lxd init`:

```ShellSession
Would you like to use LXD clustering? (yes/no) [default=no]: no
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (btrfs, ceph, dir, lvm) [default=btrfs]: dir
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]: none
Would you like LXD to be available over the network? (yes/no) [default=no]: no
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] yes
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: no
```

Results:

- LXD client cert at `$HOME/snap/lxd/current/.config/lxc/client.crt`
- LXD client key at `$HOME/snap/lxd/current/.config/lxc/client.key`
- LXD daemon accessible at `https://127.0.0.1:8443`

## References

- <https://linuxcontainers.org/lxd/getting-started-cli/>
- <https://docs.snapcraft.io/installing-snap-on-centos/>
- <https://discuss.linuxcontainers.org/t/lxd-on-centos-7/1250>
- <https://discuss.linuxcontainers.org/t/4218>
