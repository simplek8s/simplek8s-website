---
title: "GRUB, hybrid ISOs and Secure Boot"
date: 2026-09-17T02:27:04+02:00
draft: false

tags:
  - updates
  - bootloader
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

**TL;DR:** The `x86-64` boot story is now GRUB everywhere: new
hybrid `.ISO` images boot BIOS and UEFI alike (burned to CD or
`dd`'d to USB), and Secure Boot works via a one-time MOK enrollment.
Syslinux stays around for legacy images only.

Three related changes landed together in the boot stack:

- **GRUB is the managed bootloader.** The boot menu uses named
  defaults (one entry per staged kernel, newest first), and both
  `simplek8sctl` and the Controller maintain it the same way: stage,
  re-point, prune — with the `Enroll MOK key` entry always kept last
  and never pruned. Syslinux images keep booting exactly as before;
  nothing migrates them, nothing breaks them.
- **Hybrid `.ISO` images for `x86-64`.** One image boots on a classic
  BIOS (CD or USB stick) and on UEFI, following the regular
  [installation guide](/documentation/installation/install/).
- **Secure Boot with MOK.** The ESP ships a Microsoft-signed shim, so
  machines with Secure Boot enabled get past firmware verification;
  you then enroll the SimpleK8s key once per machine from the GRUB
  menu. Full background and steps live on the new [Secure Boot
  page](/documentation/installation/secure-boot/). Later boots —
  including kernel upgrades — need no interaction.

If you run older nodes: keep them as they are. The tooling speaks
both bootloader dialects and will keep doing so; when you re-image a
machine with a current release you get GRUB (and the Secure Boot
option) automatically. Enjoy! 🎉
