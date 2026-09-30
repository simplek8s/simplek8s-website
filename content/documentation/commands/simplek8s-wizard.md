---
title: "simplek8s-wizard"
date: 2023-07-17T21:49:29Z
updated: 2026-09-30T00:00:00Z
draft: false
aliases:
  - /documentation/wizard
  - /documentation/maintenance/simplek8s-wizard
---

## Description

The SimpleK8s wizard is a web UI to install SimpleK8s and manage your
Kubernetes cluster from the browser. No commands needed.

To open it, go to: `https://<your-node-IP>:5443`

Log in as `root`:

- On a **live** session (booted from ISO, nothing installed), the
  password is shown on the node's own screen — a fresh one is generated
  on every boot.
- On an **installed** node, use the root password you set during the install.

By default the wizard is enabled. To disable it:

```console
# systemctl disable --now simplek8s-wizard
```

Step-by-step guides with screenshots: [web installation](/documentation/installation/install-web/).

## Views

- **[Installer](#installer)** — visible only on live (non-persistent) sessions.
- **[KubeAdm](#kubeadm)** — create a cluster or join this node to one.
- **[Tokens](#tokens)** — visible on control-plane nodes: mint join tokens for new nodes.

### Installer

Installs SimpleK8s on a disk of this machine.

{{< alert type="warning" >}}
The installer erases the whole destination disk. Type the disk path to confirm.
{{< /alert >}}

Fill in: disk, release channel (`dev` for the latest), version
(`latest`), and either a root password (typed twice) or your own
`simplek8s.yaml` in `Custom` mode. Press Install, wait a few seconds,
then reboot from the disk.

### KubeAdm

Two modes:

- **Create cluster** — on a fresh installed node. Set the API server
  advertise address and the node hostname, press Create. This node
  becomes the first control plane.
- **Join cluster** — paste the JSON join config (minted on the
  `Tokens` page of a control-plane node) and press Join. Works for
  both control-plane and worker nodes.

Progress logs stream on the page; press Continue when done.

### Tokens

Mint join tokens for new nodes: pick the role (`control-plane` or
`worker`), type the new node's hostname, and press Create. The page
shows the `kubeadm join` command and the JSON config to paste into the
new node's KubeAdm page. Tokens expire — mint fresh ones if a join
complains.
