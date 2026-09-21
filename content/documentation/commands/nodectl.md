---
title: "nodectl"
date: 2026-09-17T00:00:00Z
draft: false
aliases:
- /documentation/maintenance/nodectl
---
## Description

`nodectl` is the local-node administration tool: the replacement for
the legacy
[simplek8s-update](/documentation/commands/simplek8s-update), rebuilt
on the same verified core as the
[SimpleK8s Controller](/documentation/maintenance/controller). It
manages **its own node only** — no controller, no cluster access, no
Kubernetes API. Use it for pre-cluster installs and out-of-band
maintenance (or drive a fleet with an operator loop around it).

It must run as root on the node itself. It exits `0` on success, `1`
on operational errors and `2` on misuse.

{{< alert type="info" >}}
Flags go before positional arguments
(`nodectl update --url dev 202609121031`), following standard
`getopt` order.
{{< /alert >}}

## Subcommands

- **[Check](#check)** — newest indexed release vs running vs staged (read-only)
- **[Update](#update)** — stage a release, retention, bootloader re-point
- **[List](#list)** — staged versions, running kernel, bootloader default (read-only)
- **[Purge](#purge)** — retention and bootloader prune, never prompts
- **[Boot](#boot)** — inspect or re-point the bootloader default
- **[Version](#version)** — embedded build info (needs no root)

### Check

Fetch and GPG-verify the release index and compare the newest release
for this node's board flavor against the running kernel (`uname -r`)
and the staged kernels. Read-only: it never writes to the boot
partition.

```console
$ nodectl check
flavor: x86-64
running: 202609161303
staged-newest: 202609161303
remote-newest: 202609161935
verdict: update available 202609161935
```

The verdict is `up-to-date`, `update available <ts>`, or `reboot
to apply <ts>` — the last one means the release is already staged
and only the reboot is missing.

`--verbose` also lists every remote release of the flavor, every
staged file, and the keyring and URL used.

### Update

Download, verify (sha256 + GPG), extract and stage a release on the
boot partition, apply retention, and re-point the bootloader default
— unless `--next-kernel=false`, which stages the file only. Without
an argument it stages the newest indexed release; with one, that
release (it must exist in the verified index). Re-downloading is
skipped when the staged file already matches the verified hash, and
an already-staged release is a no-op (exit 0). The running kernel is
never touched: rebooting into the new release is left to you (or to
the Controller).

```console
$ nodectl update --url dev 202609121031
staged 202609121031
default: 202609121031
purged: []
```

Common flags:

- **`--url`**: release channel (`dev`, `rolling` or `stable`) or a
  custom base URL. Default: `stable`.
- **`--keyring`**: custom keyring path. Default: the keyring embedded
  in the binary. `--keyring /dev/null` skips GPG verification
  (break-glass only: downloads are still sha256-verified, and a loud
  warning is printed).
- **`--next-kernel`**: `true` (default) re-points the bootloader
  default at the staged version; `false` stages without re-pointing.
- **`--preserve`**: staged versions to keep (default `3`, same as the
  Controller).
- **`--max-percent-usage`**: boot-partition usage cap in percent
  (default `75`). Purge only deletes while the partition is over the
  cap.
- **`--dry-run`**: print the exact plan (it may download to scratch
  for exact sizing) and touch nothing on the partition.

### List

Local staged versions, the running kernel and the current bootloader
default. Read-only.

```console
$ nodectl list
running: 202609161303
bootloader: grub
default: 202609161303
staged:
  202609121031
  202609161303
```

The default shows the release `ts`; a foreign or undetectable
default is shown raw so anomalies stay visible.

### Purge

Apply retention (`--preserve`, `--max-percent-usage`) and prune the
bootloader entries of deleted kernels in the same session. The
running kernel and the bootloader default are never deleted, and
foreign files are never touched. It never asks for confirmation —
preview with `--dry-run`.

```console
$ nodectl purge --preserve 3
deleted: [simplek8s.202608211728.x86-64.efi]
kept: [202608291203 202609061935 202609090435 202609121031 202609161303]
```

### Boot

Inspect the bootloader default with no arguments, or re-point it at
a staged release by passing its `ts` — no downloading involved.
Setting refuses a release whose file is absent from the boot
partition.

```console
$ nodectl boot
bootloader: grub
default: 202609161303
staged:
  202609121031
  202609161303

$ nodectl boot 202609121031
default: 202609161303 -> 202609121031
```

### Version

```console
$ nodectl version
nodectl v0.4.2 (abc1234, built 2026-09-16T23:20:00Z)
```

## Detection notes

Everything is auto-detected; there are no override flags:

- **Board flavor** (`x86-64`, `rpi4`, `rpi5`) from the staged
  filenames first, then the device-tree, then the build architecture.
  If it cannot be resolved, commands fail closed instead of guessing.
- **Boot device** by enumerating candidates and verifying contents
  (`simplek8s/` plus a bootloader config); decoys are skipped and an
  empty result fails closed.
- **Bootloader** (`grub`, `syslinux` on legacy images, `rpi`) by
  config presence.
