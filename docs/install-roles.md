# Ansible Playbook: lxd-testenv

## Table of contents

- [Ansible Playbook: lxd-testenv](#ansible-playbook-lxd-testenv)
  - [Table of contents](#table-of-contents)
  - [Install roles needed for playbook use](#install-roles-needed-for-playbook-use)
    - [Option 1: Within your home directory](#option-1-within-your-home-directory)
    - [Option 2: Within a `roles` directory in the same location as playbooks](#option-2-within-a-roles-directory-in-the-same-location-as-playbooks)
    - [Option 3: System-wide for all users](#option-3-system-wide-for-all-users)
  - [See also](#see-also)

## Install roles needed for playbook use

- While it is technically possible to install each role manually, a
  `requirements.yml` file is provided to help automate this step.
- Because `ansible-galaxy` does not yet natively support updating existing
  roles, the example installation instructions provided below include the
  `--force` parameter to *force* pulling in the latest updates as directed by
  the `requirements.yml` file.

### Option 1: Within your home directory

- `ansible-galaxy install -r requirements.yml --force`

### Option 2: Within a `roles` directory in the same location as playbooks

- `ansible-galaxy install -r requirements.yml -p roles --force`

### Option 3: System-wide for all users

- `sudo ansible-galaxy install -r requirements.yml --force`

## See also

- Main [README](../README.md) file
- <https://github.com/atc0005/ansible-playbook-lxd-testenv>

- <https://github.com/atc0005/ansible-role-lxd-host>
- <https://github.com/atc0005/ansible-role-lxd-testenv>
- <https://github.com/atc0005/ansible-role-docker-host>
