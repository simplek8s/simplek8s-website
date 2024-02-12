---
title: "Installation guide"
date: 2024-01-30T20:22:58+01:00
draft: false
---

## Without preserving previous data

Download the latest SimpleK8s image for your platform.
The URL can be found in the [Download]({{< ref "/download" >}}) page.

```console
$ curl -O https://dl.simplek8s.org/simplek8s/stable/simplek8s.latest.x86-64.img.zst
```

List all devices in your system to identify the destination device for SimpleK8s.

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

Write the SimpleK8s image to the destination device.

{{< alert type="warning" >}}
__THIS WILL OVERWRITE THE DESTINATION DEVICE WITHOUT PROMPT.__

Verify twice before press ENTER.
{{< /alert >}}

```console
$ zstdcat simplek8s.latest.x86-64.img.zst | dd of=/dev/xdb
```

Create a persistent `/var` partition on the device:

1. Execute `fdisk /dev/xdb`.
2. Press `n` and Enter, to create a new partition.
3. Press Enter, to accept default partition number.
4. Press Enter, to accept default first sector.
5. Press Enter, to accept default last sector.
6. Press `w` and Enter, to save all changes.

```console
$ fdisk /dev/xdb

Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

The backup GPT table is not on the end of the device. This problem will be corrected by write.
A hybrid GPT was detected. You have to sync the hybrid MBR manually (expert command 'M').

Command (m for help): n
Partition number (2-128, default 2):
First sector (1050624-2097118, default 1050624):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-2097118, default 2095103):

Created a new partition 2 of type 'Linux filesystem' and of size 510 MiB.

Command (m for help): w
The device contains hybrid MBR -- writing GPT only.

The partition table has been altered.
Syncing disks.
```

Create a filesystem for the `/var` partition.

```console
$ mkfs.ext4 -L simplek8s /dev/xdb2
```

Mount the first partition to edit the `simplek8s.yaml.example` file.

```console
$ mount /dev/xdb1 /mnt
$ nano /mnt/simplek8s/simplek8s.yaml.example
```

Modify the root password, ssh passphrase, storage mounts, static IP, etc. in the `simplek8s.yaml.example` file.

{{< alert type="info" >}}
You can create a passwordHash using the next command. Press space before the command to do not write it in your shell history.

```console
$ openssl passwd -6 "your password"
```
{{< /alert >}}

```yaml
users:
  - name: "root"
    passwordHash: "$6$n2yzXErLUUm5/C38$PtFZeevgw7A5LlD7J8WZlElsIl6yfpse4F6MeVx0GhIHn9WdHkVePiyd2x/kQE2UeJit.tKPn/Yez0fvL9O0K." # root
    sshAuthorizedKeys:
      - "ssh-ed25519 AAA..." # your SSH passphrase
storage:
  mounts:
    - what: /dev/disk/by-label/simplek8s
      where: /var
```

Rename the `simplek8s.yaml.example` to enable it.

```console
$ mv /mnt/simplek8s/simplek8s.yaml.example /mnt/simplek8s/simplek8s.yaml
$ umount /mnt
```

If using EFI to boot your system, create a new boot entry.

```console
$ efibootmgr -c -d /dev/xdb -p 1 -L SimpleK8s -l '\EFI\BOOT\BOOTX64.EFI'
```

__Done!__
Reboot your system and boot from your new device.
