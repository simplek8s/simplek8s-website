---
title: "Nodectl: local node updates, rebuilt"
date: 2026-09-17T00:00:00+02:00
draft: false

tags:
  - updates
  - nodectl
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

**TL;DR:** There is a new way to update a single SimpleK8s node by
hand: [`nodectl`](/documentation/commands/nodectl). It
replaces the legacy `simplek8s-update` command and shares its verified
core with the [SimpleK8s
Controller](/documentation/maintenance/controller).

`simplek8s-update` served us well, but it grew organically: seven
subcommands, short flags that collide with each other, per-command
quirks, and its own update mechanism (`selfupdate`) that never quite
fit how the distro ships. `nodectl` starts over with five flat
subcommands — `check`, `update`, `list`, `purge`, `boot` — plus a
`version` introspection, written with stdlib only (`flag` +
`log/slog`) and tested end to end on real nodes.

A few things I'm particularly happy with:

- **It verifies before it touches anything**: the release index is
  fetched and GPG-checked (against an embedded keyring, overridable
  with `--keyring`), every download is sha256-checked, and a staged
  file that already matches the verified hash is never downloaded
  again. `update --dry-run` prints the exact plan and touches
  nothing.
- **No guessing**: board flavor, boot device and bootloader are all
  auto-detected (GRUB, legacy syslinux and rpi), and every failure —
  unknown flavor, decoy partition, missing kernel file — fails closed
  instead of writing somewhere surprising. There are deliberately no
  override flags left.
- **One mechanism per concern**: the same code stages kernels for the
  Controller and the CLI, so a CLI-staged kernel is adopted by the
  Controller through the normal `next-kernel` annotation with zero
  migration. I verified this live in both directions, including a
  reboot into a staged kernel and back (~15 seconds each way).
- **Small, static, everywhere**: one `CGO_ENABLED=0` binary per
  architecture (`amd64`, `arm64`), published per release on
  `dl.simplek8s.org/simplek8s-nodectl/` (`dev`, `rolling`, `stable`), with
  `nodectl version` reporting exactly what build you're running.

The old `simplek8s-update` is on its way out: the next distro
release simply drops the binary, and `nodectl` takes its place. You
don't have to do anything — no migration steps, no flags to
translate by hand; just use `nodectl` from now on. If you do
maintain scripts around the old binary, the [command
reference](/documentation/commands/nodectl) lists every difference.

Enjoy! 🎉
