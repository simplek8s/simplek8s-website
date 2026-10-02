---
title: "nodectl"
date: 2026-09-17T00:00:00Z
draft: false
toc: true
aliases:
- /documentation/maintenance/nodectl
---
## Description

`nodectl` is the local-node administration tool: the replacement for
the legacy
[simplek8s-update](/documentation/commands/simplek8s-update), rebuilt
on the same verified core as the
[SimpleK8s Controller](/documentation/maintenance/controller). It
manages **its own node only**.

It must run as root on the node itself. It exits `0` on success, `1`
on operational errors and `2` on misuse. `wizard` adds a fourth:
`3` (idle) when the node has nothing to manage — not an error.

{{< alert type="info" >}}
Flags go before positional arguments
(`nodectl update --url dev 202609121031`), following standard
`getopt` order.
{{< /alert >}}

## Subcommands

Each subcommand is detailed below, in the same order `nodectl help` lists them.

### Check

Fetch and GPG-verify the release index and compare the newest release
for this node's board flavor against the running kernel (`uname -r`)
and the staged kernels. Read-only.

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
partition; preview the re-point with `--dry-run`.

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
### Install

Download the distro IMG and install it onto
a whole-disk device: it writes the image, creates a `/var` partition
expanded to the maximum free space, and writes the `simplek8s.yaml`
with the root password and the `/var` mount. The device must be a whole
disk — everything on it is destroyed.

It asks for the root password (twice, typing hidden), then prints the
destructive warning and waits 10 seconds — press `Ctrl+C` or `Enter`
to cancel, or let the countdown run to continue:

```console
$ nodectl install -url dev /dev/sda
root password (typing hidden):
confirm root password (typing hidden):

ALL DATA ON /dev/sda WILL BE DESTROYED.
Press Ctrl+C or Enter to cancel, or wait 10s to continue.
Continuing in 1s...
downloaded 60 MiB / wrote 513 MiB...

Installed SimpleK8s 202609241139 on /dev/sda
```

Like the [web installer](/documentation/installation/install-web/),
it can also store root SSH public keys in the generated
`simplek8s.yaml` (`ssh_authorized_keys`):

```console
$ nodectl install --ssh-key "ssh-ed25519 AAAA... user@host" \
    --ssh-key "ssh-rsa BBBB... other@host" /dev/sda
$ nodectl install --ssh-keys-file ~/.ssh/authorized_keys /dev/sda
```

For non-interactive installs, the root password can also come from a
file or the environment instead of the tty prompt (no confirmation
round-trip in either case):

```console
$ nodectl install --password-file /run/secrets/root-pw --yes /dev/sda
$ NODECTL_ROOT_PASSWORD=secretpwd1 nodectl install --yes /dev/sda
```

Usage: `nodectl install [flags] [<ts>] <device>` — flags before the
release `ts`, `ts` before the device. Without a `ts` it installs the
newest release of the channel.

Flags:

- **`--url`**: release channel (`dev`, `rolling` or `stable`) or a
  custom base URL. Default: `stable`.
- **`--config`**: install FILE as `simplek8s.yaml` instead of prompting
  for the root password and writing the `/var` mount. The file is
  installed verbatim, so it cannot be combined with `--ssh-key`,
  `--ssh-keys-file`, `--password-file` or `$NODECTL_ROOT_PASSWORD` —
  put `password_hash`/`ssh_authorized_keys` in the file instead.
- **`--password-file`**: read the root password from FILE (trailing
  newline ignored). Takes precedence over `$NODECTL_ROOT_PASSWORD`.
- **`$NODECTL_ROOT_PASSWORD`**: environment alternative to
  `--password-file` (empty counts as unset). Useful with `--yes` for
  fully non-interactive installs.
- **`--ssh-key`**: root SSH public key, one key per flag; repeat the
  flag for several keys. Same format as the web installer: one
  `authorized_keys` line per key. Optional.
- **`--ssh-keys-file`**: file with root SSH public keys, one per line
  (blank lines ignored). Can be combined with `--ssh-key`.
- **`--dry-run`**: print the plan; download and touch nothing.
- **`--yes`**: skip the confirmation countdown (required without a
  terminal).

### Wizard

Serve the [web setup wizard](/documentation/installation/install-web/):
an HTTPS server (self-signed, ephemeral certificate regenerated on
every start) on port `5443` with an embedded single-page UI. This is
what the `simplek8s-wizard.service` unit runs, so
`systemctl disable --now simplek8s-wizard` still opts out.

Login is root-only, with the root password (the one printed on the
live console, or the installed one). What the wizard offers depends
on the detected node state:

- **`live`** (booted from the ISO, nothing installed): the installer
  — same whole-disk install as [`nodectl install`](#install), plus a
  reboot button when it finishes.
- **`fresh`** (installed, not in a cluster yet): run `kubeadm init`
  to create a cluster or join this node to an existing one.
- **`cp`** (control plane): mint, list and revoke join tokens.
- **`worker`** (joined worker): nothing to manage — the command logs
  so and exits `3` (idle) instead of serving.

The listening URL is announced on the node's own console via
`/run/issue.d/50-wizard.issue`, removed on shutdown.

Flags:

- **`--listen`**: HTTPS listen address (`host:port`). Default
  `0.0.0.0:5443`.

```console
# nodectl wizard
time=2026-10-06T09:00:00Z level=INFO msg="wizard listening" listen=https://0.0.0.0:5443
```

### Selfupdate

Check the nodectl channel and install the latest published build, GPG-
verified. The check also runs automatically once a day; run it to force
a check on demand.

Automatic updates can be disabled with the `NODECTL_NO_SELFUPDATE=1`
environment variable.

Flags:

- **`--url`**: release channel (`dev`, `rolling` or `stable`) or a
  custom base URL. Default: the `stable` nodectl channel
  (`dl.simplek8s.org/simplek8s-nodectl/`) — note this is the nodectl
  channel, not the distro releases channel.
- **`--keyring`**: custom keyring path. Default: the keyring embedded
  in the binary. `--keyring /dev/null` skips GPG verification
  (break-glass only: a loud warning is printed).
- **`--dry-run`**: print what would be installed; download and touch
  nothing.

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
