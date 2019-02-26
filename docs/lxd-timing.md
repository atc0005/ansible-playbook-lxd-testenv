# Ansible Role: LXD Test Environment (lxd-testenv)

## Table of Contents

- [Ansible Role: LXD Test Environment (lxd-testenv)](#ansible-role-lxd-test-environment-lxd-testenv)
  - [Table of Contents](#table-of-contents)
  - [Spinup and teardown "benchmarks"](#spinup-and-teardown-%22benchmarks%22)
    - [ZFS-based storage](#zfs-based-storage)
      - [Re-run of `site.yml`, no needed changes](#re-run-of-siteyml-no-needed-changes)
      - [Removal of containers (`lxd-remove.yml`)](#removal-of-containers-lxd-removeyml)
      - [Fresh `site.yml` run (complete setup)](#fresh-siteyml-run-complete-setup)
      - [Fresh `lxd-setup.yml` run (partial setup)](#fresh-lxd-setupyml-run-partial-setup)
    - [dir based storage](#dir-based-storage)
      - [Re-run of `site.yml`, no needed changes](#re-run-of-siteyml-no-needed-changes-1)
      - [Removal of containers (`lxd-remove.yml`)](#removal-of-containers-lxd-removeyml-1)
      - [Fresh `site.yml` run (complete setup)](#fresh-siteyml-run-complete-setup-1)
      - [Fresh `lxd-setup.yml` run (partial setup)](#fresh-lxd-setupyml-run-partial-setup-1)
  - [References](#references)

## Spinup and teardown "benchmarks"

*I say benchmark only in the loosest sense.*

### ZFS-based storage

3.1 GB for images/containers (`/var/lib/lxd/`)

#### Re-run of `site.yml`, no needed changes

```ShellSession
real	3m10.174s
user	0m26.084s
sys	0m8.208s
```

#### Removal of containers (`lxd-remove.yml`)

```ShellSession
real	0m40.381s
user	0m5.460s
sys	0m1.528s
```

#### Fresh `site.yml` run (complete setup)

```ShellSession
real	9m1.974s
user	0m39.720s
sys	0m11.784s
```

#### Fresh `lxd-setup.yml` run (partial setup)

```ShellSession
real	8m14.754s
user	0m37.216s
sys	0m11.300s
```

### dir based storage

6.3 GB for images/containers (`/var/lib/lxd/`)

#### Re-run of `site.yml`, no needed changes

```ShellSession
real	3m12.435s
user	0m26.972s
sys	0m9.652s
```

#### Removal of containers (`lxd-remove.yml`)

```ShellSession
real	0m40.351s
user	0m5.460s
sys	0m1.408s
```

#### Fresh `site.yml` run (complete setup)

```ShellSession
real	9m26.728s
user	0m40.732s
sys	0m12.344s
```

#### Fresh `lxd-setup.yml` run (partial setup)

```ShellSession
real	7m54.446s
user	0m35.020s
sys	0m10.744s
```

## References

- <https://github.com/atc0005/ansible-playbook-lxd-testenv>
- <https://github.com/atc0005/ansible-role-lxd-testenv>
- <https://github.com/atc0005/ansible-role-lxd-testenv/issues/12>
