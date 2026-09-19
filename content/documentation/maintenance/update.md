---
title: "Update"
date: 2024-01-09T07:59:06+01:00
draft: false
---

## SimpleK8s

SimpleK8s is delivered as a single file, typically located in `/boot/simplek8s/`. To update to a new version, you can directly download it from the [official download page](https://simplek8s.org/download/).

There are two supported ways to manage updates.

## Option A — one node, by hand

Use [nodectl](/documentation/commands/nodectl) on the node
itself (as root). It fetches the signed release index, stages the
kernel you ask for, and re-points the bootloader — the running kernel
is never touched until you reboot:

```console
$ # Newest release from the stable channel:
$ nodectl update
staged 202609161935
default: /simplek8s/simplek8s.202609161935.x86-64.efi
purged: []

$ # Reboot into it when ready:
$ reboot
```

Check first what would happen (`nodectl check`, `nodectl
update --dry-run`), keep old kernels with `--preserve`, and roll back
with `nodectl boot set <older-ts>` + reboot. The legacy
[simplek8s-update](/documentation/commands/simplek8s-update) command
still works but is superseded.

## Option B — the whole cluster, automated

Deploy the [SimpleK8s Controller](/documentation/maintenance/controller):
each node stages verified releases on schedule and reboots into them
only inside your maintenance windows — or only when you say so via
the reboot API. Rollback is one annotation edit
(`simplek8s.org/next-kernel` back to a preserved version) plus reboot.

## Upgrade third-party programs

Now is an opportune time to upgrade third-party programs, such as Kubernetes. You can temporarily stop these third-party programs and remove them, as they will redeployed upon the next reboot.

{{< alert type="warning">}}
**Please be cautious!**

If you have custom third-party programs in `/usr/local/bin`, the next command will remove all of then! Alternatively you can manually remove each one.
{{< /alert >}}

```console
$ # The next command will stop all Kubernetes components
$ stop-k8s

$ # Third-party files will be restored from factory on reboot
$ rm /usr/local/bin/* /usr/local/sbin/runc /opt/cni/bin/*

$ # Reboot your system to activate the new version:
$ reboot
```

And you are done!
