---
title: "Install SimpleK8s and build your cluster from the browser"
date: 2026-09-30T00:00:00+02:00
draft: false

tags:
  - installation
  - kubernetes
  - wizard
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

**TL;DR:** You can now install SimpleK8s and build a whole
Kubernetes cluster without typing a single command. Boot the latest
stable ISO, open `https://<node-IP>:5443`, and click through:
install, create, join. The full walkthrough with screenshots is in the
new [web installation
guide](/documentation/installation/install-web/).

SimpleK8s exists for one reason: simplicity. Installing a distro and
raising a cluster should be easy — and now it is. The web wizard takes
you from a bare machine to a multi-node cluster in three acts:

1. **Install.** Pick the disk, choose the `dev` channel, set the root
   password (or paste your own `simplek8s.yaml`), confirm, reboot.
   A few seconds, one screen.
2. **Create.** Give the first node a hostname and press Create. It
   becomes the first control plane.
3. **Join.** Mint one token per new node — control plane or worker —
   paste the JSON config into each node's wizard, press Join. Done.

Everything you need to see is shown: live progress logs, the exact
join commands, token expiry. Nothing happens behind your back, and the
terminal path is still there for whoever wants it ([terminal
installation guide](/documentation/installation/install-terminal/),
`kubeadm`, [`nodectl`](/documentation/commands/nodectl/)).

Grab the latest stable ISO on the [download page](/download/) and try
it — a three-node cluster is minutes away. 🎉
