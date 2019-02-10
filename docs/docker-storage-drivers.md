# Ansible Role: Docker storage (docker-setup.yml)

## LXD + Docker CE `overlay2` storage driver

LXD 2.x or 3.x (regardless of LXD storage option) is incompatible with Docker
Community Edition (CE) 18.09 with `overlay2` storage driver.

Workaround:  Use `vfs` Docker storage, or if supported, `overlay` Docker
storage.

## LXD + ZFS storage + Docker CE `overlay` or `overlay` storage driver

Docker storage drivers `overlay` and `overlay2` are not supported when using
ZFS storage with LXD.

Workaround: Use `vfs` Docker storage.

## LXD + `dir` storage + Docker `overlay` storage driver

LXD 2.0.x seems to be fine with this, but LXD 3.0.x with `dir` storage and
Docker CE 18.09 with `overlay` storage driver causes the Docker daemon to fail
to start.

Workarounds:

- Use `vfs` Docker storage
- *or* set a LXD configuration option (either directly to the container or
  within a LXD container profile) to load the required driver for use by the
  container.

## Docker `vfs` storage driver

The `vfs` Docker storage driver is slow, but proved to be the most compatible
during playbook/role testing. Unless you use ZFS storage for LXD, you should
be able to use the `overlay` Docker storage driver. This can be set within the
playbook in order to override the `atc0005.lxd-testenv` role default of using
`vfs` Docker storage.

To set this value (or any other Docker storage driver), set the
`lxd_containers_docker_storage_driver` variable within the
[`lxd-setup.yml`](lxd-setup.md) playbook or another file that you include
from the playbook. As of this writing an override to enable use of the
`overlay` driver is commented out in the appropriate place in the playbook.

## References

- See [the main README file](../README.md)
- <https://github.com/atc0005/ansible-playbook-lxd-testenv>

- <https://github.com/atc0005/ansible-role-lxd-host>
- <https://github.com/atc0005/ansible-role-lxd-testenv>
- <https://github.com/atc0005/ansible-role-docker-host>
