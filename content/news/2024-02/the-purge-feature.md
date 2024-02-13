---
title: "The Purge Feature"
date: 2024-02-13T20:14:30+01:00
draft: false

tags:
- simplek8s-update
- maintenance
authors:
- José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

I am excited to announce the latest improvement to the `simplek8s-update` component.

Previously incomplete, the "purge" subcommand in `simplek8s-update` is now fully functional!

With this update, you can now clean up old releases from the boot partition based on either the usage space percentage or the desired number of releases to preserve.

Don't forget to update the `simplek8s-update` command as follows:

```console
$ simplek8s-update su

Downloading SHA256SUMS ...
Downloading simplek8s-update.latest.arm64 (2.5 MB) ...
10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Validating checksum (c862642da95e0400f41dc4daf723c4f52fd55f3ca43a1b3695bab58c260e2bc4) ...
Checksum is valid.
Saving as "/usr/local/bin/simplek8s-update" (2.5 MB) ...
10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

The next command will remove old releases; by default, preserving the default kernel, 5 releases, and a maximum of 75% used space.

```console
$ simplek8s-update p

Mounting boot device ...
There are 4 installed releases. Preserving a least 5 ...
Device: /dev/disk/by-label/boot, size: 264.3 MB, used: 252.1 MB (95%).
Removed kernel "simplek8s.202308120612.arm64.efi".
Device: /dev/disk/by-label/boot, size: 264.3 MB, used: 191.2 MB (72%).
Unmounting boot device ...
```

The idea is to run `purge` after unattended upgrades.

Let's continue making progress, one step at a time!
