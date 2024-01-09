---
title: "Update"
date: 2024-01-09T07:59:06+01:00
draft: true
---
**Q: How do I update SimpleK8s?**

A: SimpleK8s is delivered as a single file, typically located in `/boot/simplek8s/`. To update to a new version, you can directly download it from the [official download page](https://simplek8s.org/download/).
A more convenient alternative is to use the `simplek8s-update` command for upgrading SimpleK8s:

```console
$ # By default, simplek8s-update will upgrades from the stable channel.
$ simplek8s-update update
```

Now is an opportune time to upgrade third-party programs, such as Kubernetes. You can temporarily stop these third-party programs and remove them, as they will redeployed upon the next reboot.

{{< warning >}}
Please be cautious! If you have custom third-party programs in `/usr/local/bin`, the next command will remove all of then! Alternatively you can manually remove each one.
{{< /warning >}}

```console
$ # The next command will stop all Kubernetes components
$ stop-k8s

$ # This command will removes all files from /usr/local/bin/
$ rm /usr/local/bin/*
```

The next step is to reboot your system to activate the new version:

```console
$ reboot
```

And you are done!
