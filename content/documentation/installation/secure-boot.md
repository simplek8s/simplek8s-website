---
title: "Secure Boot"
date: 2026-09-17T00:26:34Z
draft: false
---
## How it works

On `x86-64` (BIOS and UEFI alike) SimpleK8s boots through GRUB from
the EFI System Partition, which carries a Microsoft-signed shim
(`EFI/BOOT/BOOTX64.EFI`), GRUB itself (`grubx64.efi`), the MokManager
(`mmx64.efi`) and the SimpleK8s key (`EFI/BOOT/MOK.cer`).

With Secure Boot disabled — or when booting in BIOS mode — the system
boots directly and there is nothing else to do. With Secure Boot
enabled, the shim only trusts binaries signed by keys your firmware
knows, so you enroll the SimpleK8s key **once per machine**. Later
boots, including future kernel upgrades, then work unattended.

## One-time enrollment

1. Boot the new device. In the GRUB menu, select `Enroll MOK key
   (first boot with Secure Boot)`.
2. In MokManager, select `Enroll key from disk`, choose the disk, and
   open `EFI/BOOT/MOK.cer`.
3. Check that the key details belong to SimpleK8s, select `Continue`,
   answer `Yes` to `Enroll the key(s)?`, and select `Reboot`.

Done. If you replace the machine's firmware settings (factory reset
of the Secure Boot databases), enroll again.

## Notes

- The GRUB menu keeps the `Enroll MOK key` entry last on purpose: the
  update tooling (`nodectl`, the Controller) manages kernel
  entries newest-first and never touches it.
- Kernel upgrades do not require re-enrollment: staged kernels boot
  under the already-enrolled key.
- Re-imaging a disk preserves nothing: the enrollment lives in the
  machine's firmware, not on the disk, so a fresh disk on an enrolled
  machine boots straight away.
