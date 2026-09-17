---
title: "About"
date: 2023-07-10T08:06:00+02:00
draft: false
aliases:
- /documentation/about
---

SimpleK8s is a lightweight Linux distribution whose only job is to
run Kubernetes clusters effortlessly: one bootable file per board
(`x86-64`, `rpi4`, `rpi5`), immutable by design, with signed releases
you can verify before you boot them.

## Principles

- **Boring to operate**: flash, boot, join. Day-two operations;
  updates, reboots, rollbacks; are explicit, observable commands,
  not background magic.
- **Small and auditable**: a minimal Buildroot-based system (~40 MB)
  with no bloatware and no hidden state; configuration lives in one
  optional `simplek8s.yaml`.
- **Signed and open**: every release is GPG-signed and checksummed;
  development happens in the open, driven by user needs instead of
  vendor roadmaps (non-profit, community-first).

## Ecosystem

- [SimpleK8s Wizard](/documentation/commands/simplek8s-wizard);
  first boot, install to disk and cluster bootstrap from the browser.
- [simplek8sctl](/documentation/commands/simplek8sctl); local node
  updates from the terminal.
- [SimpleK8s Controller](/documentation/maintenance/controller);
  fleet-wide updates and supervised reboots from Kubernetes itself.

The code lives at [github.com/simplek8s](https://github.com/simplek8s);
issues, ideas and pull requests are welcome.
