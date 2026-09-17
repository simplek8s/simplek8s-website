---
title: "simplek8s-update"
date: 2024-01-08T20:32:02Z
draft: false
aliases:
- /documentation/maintenance/simplek8s-update
---
## Description

The SimpleK8s-Update is a user-friendly program that help you to update your SimpleK8s node.

{{< alert type="warning" >}}
Legacy: `simplek8s-update` is superseded by
[simplek8sctl](/documentation/commands/simplek8sctl), which shares
its verified core with the Controller. The old binary keeps working,
but there is no flag-compatibility promise — prefer `simplek8sctl`
for new installs.
{{< /alert >}}

The command `simplek8s-update` is located by default in `/usr/local/bin/simplek8s-update`.

There are some subcommands for `simplek8s-update`:


## Subcommands

- Update subcommands:
  - **[Update](#update)**
  - **[Self Update](#self-update)**
- Local management
  - **[List](#list)**
  - **[Boot](#boot)**
  - **[Purge](#purge)**
- Remote subcommands:
  - **[Search](#search)**
  - **[Download](#download)**

### Update

This subcommand will search the latest release from an URL (the official SimpleK8s repository by default), download and decompress it into `/boot/simplek8s/`; the last step will configure the bootloader to boot this new version on the next reboot.

There are some configurations as the following:

- **``--url``**: URL from the repository where to download the files `SHA256SUMS`, `SHA256SUMS.gpg` and the releases. There are some alias as `dev`, `rolling` and `stable` for the official SimpleK8s repository URL.
- **`--version`**: The version to download. By default will be the alias `latest`.
- **`--dry-run`** (`-n`): Just do not write anything in the storage.
- **`--preserve`** (`-p`): How many releases will be preserved. Maybe you wish to boot an order version. Default: `5`.
- **`--next-boot`** (`-nb`): Configure the bootloader to boot the downloaded release. Default: `true`.
- **`--overwrite`**: Overwrite any file with the same name as the release. Default: `true`.
- **`--no-confirm`**: Do not ask for confirmation; always accept the default answers.
- **`--bootloader`** (`-bl`): Bootloader type: `auto` (detected from the boot partition), `syslinux` or `rpi`.
- **`--max-percent-usage`** (`-mpu`): Delete releases until the partition usage is below this percent (default `75`, `0` to ignore).

To upgrade a SimpleK8s:

```console
$ simplek8s-update update
```

To use the most experimental channel (there are more aliases as `dev`, `rolling` and `stable`):

```console
$ simplek8s-update update --url dev
```

Maybe the file `/usr/lib/systemd/import-pubring.gpg` is so old (because you are using a very old SimpleK8s release) that the GPG keyring was changed from the official repository. You can skip the GPG verification as the next example:

```console
$ simplek8s-update update --checksign=false
```

### Self Update

The command `simplek8s-update` could be updated with new features and fixes. This subcommand will upgrade the command `simplek8s-update` itself.

### List

List all the installed releases on the boot device (`l` for short):

```console
simplek8s-update list
```

It accepts the boot locating flags (`--bootdevice`, `--bootloader`,
`--output`, `--syslinux-config`, `--rpi-config`) and `--maxitems`
(`-m`, default `20`) to cap how many releases are shown.

### Boot

Show or set which release boots next (`b` for short). The release is
resolved with the same boot locating flags as `list`, plus
`--dry-run` to preview without writing.

### Purge

Delete installed releases keeping `--preserve` (default `5`) of them
while the partition usage stays above `--max-percent-usage` (default
`75`), then clean the bootloader entries of the deleted ones (`p`
for short):

```console
simplek8s-update purge --dry-run
```

It accepts the boot locating flags and `--dry-run`. Unlike `update`,
it never asks for confirmation.

### Search

List the releases published by a repository matching the filters,
without downloading anything (`s` for short). It tolerates a missing
or unreadable boot device:

```console
simplek8s-update search --architecture rpi4
```

Filters: `--distribution`, `--architecture` (`-arch`, `auto` by
default: `amd64` machines resolve to `x86-64`, `arm64` machines read
the device-tree model for `rpi4`/`rpi5`), `--component`,
`--version` and `--maxitems` (default `20`).

### Download

Download releases somewhere else without installing them (`d` for
short):

```console
simplek8s-update download --output /tmp --version 202608291203
```

Relevant flags: `--output` (`-o`, default: the current directory),
`--decompress` (`-d`, default `true`), `--overwrite` (default
`true`) and `--dry-run`.

{{< alert type="info" >}}
Several short aliases collide across commands and flags (`-p` is both
`purge` and `preserve`, `-d` is both `download` and `decompress`).
The successor [simplek8sctl](/documentation/commands/simplek8sctl)
dropped all of them in favor of long kebab-case flags only.
{{< /alert >}}
