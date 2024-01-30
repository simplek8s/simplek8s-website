---
title: "Installation guide"
date: 2024-01-30T20:22:58+01:00
draft: false
---

## Install SimpleK8s to a device without preserving previous data

Download the latest SimpleK8s image for your platform.
The URL can be found in {{< ref path="download.md" >}}

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
xdb    259:0    0  1.8T  0 disk
```

Write the SimpleK8s image to the destination device.

{{< warning >}}
THIS WILL OVERWRITE THE DESTINATION DEVICE WITHOUT PROMPT. Verify twice before press ENTER.
{{< /warning >}}

```console
$ zstdcat simplek8s.latest.x86-64.img.zst | dd of=/dev/xdb
```

Create a persistent `/var` partition on the device.

```console
$ fdisk /dev/xdb
n
<accept the default option, 2>
<accept the default start value>
<accept the default end value>
w
```

Create a filesystem for the `/var` partition.

```console
$ mkfs.ext4 -L simplek8s /dev/xdb2

# Mount the first partition to create a simplek8s.yaml file
$ mount /dev/xdb1 /mnt
$ nano /mnt/simplek8s/simplek8s.yaml.example

Modify the root password, ssh passphrase, storage mounts, static IP, etc. in the `simplek8s.yaml.example` file.

```simplek8s.yaml
users:
  - name: "root"
    passwordHash: "$6$n2yzXErLUUm5/C38$PtFZeevgw7A5LlD7J8WZlElsIl6yfpse4F6MeVx0GhIHn9WdHkVePiyd2x/kQE2UeJit.tKPn/Yez0fvL9O0K." # example password as root
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

Done!
Reboot your system and boot from your new device.
