---
title: "Update"
date: 2024-01-09T07:59:06+01:00
draft: false
---

## SimpleK8s

SimpleK8s is delivered as a single file, typically located in `/boot/simplek8s/`. To update to a new version, you can directly download it from the [official download page](https://simplek8s.org/download/).

A more convenient alternative is to use the [simplek8s-update](/documentation/commands/simplek8s-update) command for upgrading SimpleK8s:

```console
$ # By default, simplek8s-update will upgrades from the stable channel.
$ simplek8s-update update
```

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

# Reboot your system to activate the new version:
$ reboot
```

And you are done!
