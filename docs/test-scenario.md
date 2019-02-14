# Ansible Role: lxd-testenv - Test Scenario

- [Ansible Role: lxd-testenv - Test Scenario](#ansible-role-lxd-testenv---test-scenario)
  - [Overview](#overview)
  - [Settings](#settings)
    - [centos](#centos)
      - [centos group](#centos-group)
      - [ansible-centos-1](#ansible-centos-1)
      - [ansible-centos-2](#ansible-centos-2)
    - [ubuntu](#ubuntu)
      - [ubuntu group](#ubuntu-group)
      - [ansible-ubuntu-1](#ansible-ubuntu-1)
      - [ansible-ubuntu-2](#ansible-ubuntu-2)
      - [ansible-ubuntu-3](#ansible-ubuntu-3)
      - [ansible-ubuntu-4](#ansible-ubuntu-4)

## Overview

This doc is intended to:

- cover the settings applied by the `test-settings` branch of the
  `ansible-playbook-lxd-testenv` repo against the Ansible role maintained in
  the `ansible-role-lxd-testenv` repo.
- serve as a checklist until these settings can be automatically checked by
  the test framework provided by Ansible.

## Settings

### centos

#### centos group

Unless overridden by a host-specific file, these settings apply to all CentOS
LXD containers:

```yaml
lxd_containers_image_source: "centos/7/amd64"
python_install_command: "yum install -y python"
lxd_containers_add_proxy_to_etc_environment_file: false
```

Results:

- latest "stable" CentOS 7 x64 image used during container creation
- `yum install -y python` used to install Python (if needed)
- `/etc/environment` NOT populated with proxy settings

#### ansible-centos-1

Settings:

```yaml
lxd_containers_add_proxy_to_etc_environment_file: true
lxd_containers_service_account: "crickets"
lxd_containers_service_group: "insects"
```

Results:

- `/etc/environment` IS updated with proxy settings
- Custom "crickets" service account created
- Custom "insects" service group created

#### ansible-centos-2

Settings:

```yaml
lxd_containers_update_hosts_file: true
lxd_containers_bootstrap: false
lxd_containers_add_proxy_to_etc_environment_file: false
```

Results:

- `/etc/hosts` in container is updated
- bootstrapping phase is skipped
  - since the CentOS LXD image already contains Python, most (all?) of the
    later setup steps are still possible

### ubuntu

#### ubuntu group

Settings:

```yaml
lxd_containers_image_source: "ubuntu/xenial/amd64"
python_install_command: "apt-get update && apt-get install -y python"

lxd_containers_packages_extra:
  - "subversion"
```

Results:

- latest "stable" Ubuntu 16.04 x64 image used during container creation
- `apt-get update && apt-get install -y python` used to install Python (if needed)
- `subversion` package installed in place of `nano` as an "extra" package
  - i.e., `nano` should NOT be installed in the container unless overridden
    later

#### ansible-ubuntu-1

Settings:

```yaml
lxd_containers_bootstrap: false
```

Results:

- Inherited group settings
- bootstrapping phase is skipped
  - this forces nearly all other steps to be skipped for this host

#### ansible-ubuntu-2

Settings:

```yaml
lxd_containers_packages_extra:
  - "nano"
  - "tmux"
```

Results:

- Inherited group settings
- `tmux` installed in addition to `nano` (which was explicitly noted here)

#### ansible-ubuntu-3

Settings:

```yaml
lxd_containers_packages_extra:
  - "nano"
  - "htop"
```

Results:

- Inherited group settings
- `htop` installed in addition to `nano` (which was explicitly noted here)

#### ansible-ubuntu-4

Settings:

```yaml
lxd_containers_configure: false
lxd_containers_bootstrap: false
lxd_containers_update_hosts_file: true
```

Results:

- All container configure tasks blocked (see first option)
- Bootstrap phase skipped (see second option)
- `/etc/hosts` file NOT updated (even though third option specifies this)
  because the second "global" option has precedence
