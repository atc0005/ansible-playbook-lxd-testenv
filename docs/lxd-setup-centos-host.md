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
    - [UNIX-socket access](#unix-socket-access)
    - [HTTPS API ACCESS](#https-api-access)
  - [References](#references)

## Installation steps

### Prerequisites

These steps need to be performed regardless of which direction we go later.

1. `sudo yum install epel-release`
1. `sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7`
1. `sudo yum check-update`
1. `sudo yum install snapd ansible git`
1. `sudo systemctl enable --now snapd.socket`
1. `sudo ln -s /var/lib/snapd/snap /snap`
1. `sudo journalctl -u snapd.service`
1. `sudo grubby --args="user_namespace.enable=1" --update-kernel="$(grubby --default-kernel)"`
1. `sudo grubby --args="namespace.unpriv_enable=1" --update-kernel="$(grubby --default-kernel)"`
1. `sudo bash -c 'echo "user.max_user_namespaces=3883" > /etc/sysctl.d/99-userns.conf'`
1. `sudo reboot`

### UNIX-socket access

1. `sudo snap install lxd`
1. `sudo usermod -a -G lxd $USER`
1. logout
1. `sudo /var/lib/snapd/snap/bin/lxd init`

The UNIX socket at `/var/snap/lxd/common/lxd/unix.socket` is now available
for use with Ansible.

### HTTPS API ACCESS

This access seems to depend not only ona trust password being set, but an
existing client certificate and key. LXD versions 3.0 and greater appear to
only generate these files when adding a remote, not on first use of `lxc`.
To work around that, we first install the older LXD 2.0 package, generate the
files and then upgrade to a later version (LTS, stable, etc) of our choice.

1. Install LXD 2.0.x via snap
   - `sudo snap install lxd --channel=2.0/stable`
1. Initialize storage, network, etc
   - `sudo /var/lib/snapd/snap/bin/lxd init`
1. Create test container
   - `lxc init images:centos/6/amd64 testing`
   - at this point the client cert/key pair are created
1. Upgrade to the latest stable release
   - `sudo snap refresh lxd --channel=stable`

Results:

- LXD client cert at `$HOME/snap/lxd/current/.config/lxc/client.crt`
- LXD client key at `$HOME/snap/lxd/current/.config/lxc/client.key`
- LXD daemon accessible at `https://127.0.0.1:8443`
  - *provided that you chose this config option when following prompts from
    lxd init*

## References

- <https://discuss.linuxcontainers.org/t/lxd-on-centos-7/1250>
- <https://discuss.linuxcontainers.org/t/4218>
