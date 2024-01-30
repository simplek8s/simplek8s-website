---
title: "Installation guide"
date: 2024-01-30T20:22:58+01:00
draft: false
---

## Install SimpleK8s to a device without preserving previous data

```console
# Download the latest SimpleK8s image for your platform
# The URL can be found in {{< ref path="download.md" >}}
$ curl -O https://dl.simplek8s.org/simplek8s/stable/simplek8s.latest.x86-64.img.zst

# List all devices in your system to identify the destination device for SimpleK8s
$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xda    259:0    0  1.8T  0 disk
├─xda1 259:1    0    1G  0 part /boot
├─xda2 259:2    0   16M  0 part
├─xda3 259:3    0  931G  0 part
└─xda4 259:4    0  931G  0 part /
xdb    259:0    0  1.8T  0 disk

# Write the SimpleK8s image to the destination device
# CAUTION: THIS WILL OVERWRITE THE DEVICE
$ zstdcat simplek8s.latest.x86-64.img.zst | dd of=/dev/xdb

# Create a persistent /var partition on the device
$ fdisk /dev/xdb
n
<accept the default option, 2>
<accept the default start value>
<accept the default end value>
w

# Create a filesystem for the /var partition
$ mkfs.ext4 -L var /dev/xdb2

# Mount the first partition to create a simplek8s.yaml file
$ mount /dev/xdb1 /mnt
$ nano /mnt/simplek8s/simplek8s.yaml.example

# Modify the root password, ssh passphrase, static IP, etc. in the simplek8s.yaml.example file

# Rename the simplek8s.yaml.example to enable it
$ mv /mnt/simplek8s/simplek8s.yaml.example /mnt/simplek8s/simplek8s.yaml
$ umount /mnt

# If using EFI to boot your system, create a new boot entry
$ efibootmgr -c -d /dev/xdb -p 1 -L SimpleK8s -l '\EFI\BOOT\BOOTX64.EFI'

# Done!
# Reboot your system and boot from your new device
```
