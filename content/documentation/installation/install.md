---
title: "Installation guide"
date: 2024-01-30T20:22:58+01:00
draft: false
---

## 1. Dump SimpleK8s image into your disk

List all the block devices to identify the destination device for SimpleK8s.

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

Write the SimpleK8s image to the destination device:

{{< alert type="warning" >}}
__THIS WILL OVERWRITE THE DESTINATION DEVICE WITHOUT PROMPT.__

Verify twice before press ENTER.
{{< /alert >}}

```console
# SimpleK8s images for others platforms can be found in {{< ref "/download" >}}

$ curl https://dl.simplek8s.org/simplek8s/stable/simplek8s.latest.x86-64.img.zst | zstdcat | dd of=/dev/xdb
```

## 2. Data persistance

To create a persistent `/var` partition on the device:

1. Execute `fdisk /dev/xdb`.
2. Press `n` and Enter, to create a new partition.
3. Press `p` and Enter, to create a primary partition.
4. Press Enter, to accept default partition number.
5. Press Enter, to accept default first sector.
6. Press Enter, to accept default last sector.
7. Press `w` and Enter, to save all changes.

```console
$ fdisk /dev/xdb

Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (1050624-2097151, default 1050624):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-2097151, default 2097151):

Created a new partition 2 of type 'Linux' and of size 510 MiB.

Command (m for help): w
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
You can create a passwordHash using the next command:

```console
$ openssl passwd -6
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

## 3. Secure Boot

With Secure Boot disabled, or when booting in BIOS mode, the system boots directly and there is nothing else to do.

With Secure Boot enabled, enroll the SimpleK8s key once per machine:

1. Boot the new device. In the GRUB menu, select `Enroll MOK key (first boot with Secure Boot)`.
2. In MokManager, select `Enroll key from disk`, choose the disk, and open `EFI/BOOT/MOK.cer`.
3. Check that the key details belong to SimpleK8s, select `Continue`, answer `Yes` to `Enroll the key(s)?`, and select `Reboot`.

Done. Later boots, including future SimpleK8s kernel upgrades, work unattended without repeating this step.
Background and notes: [Secure Boot](/documentation/installation/secure-boot/).

__Done!__
Reboot your system and boot from your new device.
