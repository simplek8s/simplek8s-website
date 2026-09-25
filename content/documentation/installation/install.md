---
title: "Installation guide"
date: 2024-01-30T20:22:58+01:00
draft: false
weight: 1
---

## 1. Install SimpleK8s with nodectl

`nodectl install` downloads the distro IMG and installs it onto a
whole-disk device; it also creates a `/var` partition expanded to the
maximum free space on the device.

From a running SimpleK8s node, list all the block devices to identify
the destination device.

```console
$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xda    259:0    0  1.8T  0 disk
├─xda1 259:1    0    1G  0 part /boot
├─xda2 259:2    0   16M  0 part
├─xda3 259:3    0  931G  0 part
└─xda4 259:4    0  931G  0 part /
xdb    259:0    0    1G  0 disk
```

{{< alert type="warning" >}}
**ALL DATA ON THE DESTINATION DEVICE WILL BE DESTROYED.**

Verify twice before running the command.
{{< /alert >}}

```console
$ nodectl install /dev/xdb
root password (typing hidden):
confirm root password (typing hidden):

ALL DATA ON /dev/xdb WILL BE DESTROYED.
Press Ctrl+C or Enter to cancel, or wait 10s to continue.
Continuing in 1s...
downloaded 60 MiB / wrote 513 MiB...

Installed SimpleK8s 202609241139 on /dev/xdb
```

The command asks for the root password (twice, typing hidden) and writes
a `simplek8s.yaml` with the root password and the `/var` mount — or pass
your own with `-config`. Before writing, it prints the destructive
warning and waits 10 seconds: press `Ctrl+C` or `Enter` to cancel, or
let the countdown run to continue.

Flags (before the positional arguments):

- `-url`: release channel (`dev`, `rolling` or `stable`) or a custom
  base URL. Default: `stable`.
- `-config`: install FILE as `simplek8s.yaml` instead of prompting for
  the root password and writing the `/var` mount.
- `-dry-run`: print the plan; download and touch nothing.
- `-yes`: skip the confirmation countdown (required without a terminal).
- `<ts>` (optional, before the device): install a specific release
  instead of the newest one in the channel.

## 2. Secure Boot

With Secure Boot disabled, or when booting in BIOS mode, there is
nothing else to do.

On a UEFI system you can check the state with:

```console
$ od -A n -t x1 /sys/firmware/efi/efivars/SecureBoot-*
06 00 00 00 01
```

The last byte is the state: `01` means enabled, `00` means disabled
(the file is absent when the machine is not booted with UEFI). Secure
Boot is a machine setting, so check it on the machine the new device
will run on.

With Secure Boot enabled, enroll the SimpleK8s key once per machine:
[Secure Boot](/documentation/installation/secure-boot/).

**Done!**
Reboot your system and boot from your new device.
