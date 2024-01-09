---
title: "SimpleK8s-Update"
date: 2024-01-08T20:32:02Z
draft: true
---
## Description

The SimpleK8s-Update is a user-friendly program that help you to update your SimpleK8s node.

The command `simplek8s-update` is located by default in `/usr/local/bin/simplek8s-update`.

There are some subcommands for SimpleK8s:


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

- **``--url``**: URL from the repository where to download the files SHA256SUMS, SHA256SUMS.gpg and the releases. There are some alias as `dev`, `rolling` and `stable` for the official SimpleK8s repository URL.
- **`--version`**: The version to download. By default will be the alias `latest`.
- **`--dry-run`**: Just do not write anything in the storage.
- **`--preserve`**: How many releases will be preserved. Maybe you wish to boot an order version.

As example, to upgrade a SimpleK8s:

```console
$ simplek8s-update update
```

To use a more experimental channel (there are more aliases as `dev`, `rolling` and `stable`):

```console
$ simplek8s-update update --url dev
```

Maybe the file `/usr/lib/systemd/import-pubring.gpg` is so old (because you are using a very old SimpleK8s release) that the GPG keyring was changed from the official repository. You can skip the GPG verification as the next example:

```console
$ simplek8s-update update --checksign=false
```

### Self Update

The command `simplek8s-update` could be updated with new features and fixes. This subcommand will upgrade the command `simplek8s-update` itself.

#### List

Soon…

### Boot

Soon…

#### Purge

Soon …

#### Search

Soon…

### Download

Soon…
