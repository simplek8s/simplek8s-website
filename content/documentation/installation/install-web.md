---
title: "Web installation guide"
date: 2026-09-30T00:00:00Z
draft: false
weight: 4
toc: true
aliases:
- /documentation/installation/install/
---

Install SimpleK8s and build a Kubernetes cluster from your browser.
No commands needed.

## What you need

- The latest stable ISO from the [download page](/download/).
- A machine booted from that ISO (live session, nothing installed yet).
- The machine's IP address on your network.

{{< alert type="info" >}}
Screenshots in this guide were taken on SimpleK8s `202609290644`; newer versions may look slightly different.
{{< /alert >}}

## 1. Open the wizard and log in

Find the node's IP, wizard address, and live root password on the
node's own screen (console). It prints them on every boot:

{{< shot src="/img/wizard/00-tty-issue.png" alt="Node console with IP, wizard address, and live root password" caption="Node console with IP, wizard address, and live root password (click to enlarge)" >}}

Then go to `https://<node-IP>:5443` and accept the self-signed certificate warning.

Log in as `root` with the password from that screen. A fresh one is
generated on every live boot.

{{< shot src="/img/wizard/01-login.png" alt="Wizard login" caption="Wizard login (click to enlarge)" >}}

## 2. Install SimpleK8s on the disk

The `Installer` page appears because the live session is not persistent yet.

{{< shot src="/img/wizard/02-installer-dev.png" alt="Installer, simple mode" caption="Installer, simple mode (click to enlarge)" >}}

1. **Disk**: pick the destination disk. __Everything on it will be erased.__
2. **Channel**: `stable` (recommended), `rolling` (releases getting ready for stable), or `dev` (latest builds to try out).
3. **Version**: keep `latest`.
4. **Root password**: type it twice (or switch to `Custom` and paste your own `simplek8s.yaml` instead — see below).
5. **SSH keys** (optional): paste root SSH public keys, one per line.
6. **Confirm**: type the disk path (for example `/dev/vda`) to prove you checked it twice.
7. Press **Install SimpleK8s**.

Prefer a config file? Select `Custom` and paste (or upload) your [`simplek8s.yaml`](/documentation/installation/simplek8s-yaml/):

{{< shot src="/img/wizard/03-installer-config.png" alt="Installer, custom config mode" caption="Installer, custom config mode (click to enlarge)" >}}

When it finishes, press **Reboot**:

{{< shot src="/img/wizard/05-install-done.png" alt="Installation finished" caption="Installation finished (click to enlarge)" >}}

The node now boots from its disk. Log in to the wizard again — this time with the root password you set during the install.

## 3. Create the cluster

Open the `KubeAdm` page. Keep **Create cluster** selected, check the
advertise address, give the node a hostname, and press **Create**:

{{< shot src="/img/wizard/06-kubeadm-init.png" alt="Create cluster" caption="Create cluster (click to enlarge)" >}}

When it is done, press **Continue**:

{{< shot src="/img/wizard/09-cluster-done.png" alt="Cluster created" caption="Cluster created (click to enlarge)" >}}

Your cluster exists: one control-plane node, ready for workers.

## 4. Create join tokens

Open the `Tokens` page and press **List** to see the active tokens:

{{< shot src="/img/wizard/10-tokens.png" alt="Tokens page" caption="Tokens page (click to enlarge)" >}}

Create one token per node you want to add:

- Role **control-plane**, hostname of the new control-plane node. The page shows the join command and the JSON config the new node needs:

{{< shot src="/img/wizard/11-token-cp.png" alt="Control-plane token" caption="Control-plane token (click to enlarge)" >}}

- Role **worker** for worker nodes:

{{< shot src="/img/wizard/12-token-worker.png" alt="Worker token" caption="Worker token (click to enlarge)" >}}

Tokens expire. Create fresh ones if a join fails with an expired token.

## 5. Join a second control-plane node

On the new node (installed the same way as above), open its wizard,
select **Join cluster**, and paste the control-plane JSON config:

{{< shot src="/img/wizard/13-cp-join-form.png" alt="Join as control plane" caption="Join as control plane (click to enlarge)" >}}

Press **Join**. When it finishes:

Done — the cluster now has two control-plane nodes:

{{< shot src="/img/wizard/13-cp-join-done.png" alt="Control plane joined" caption="Control plane joined (click to enlarge)" >}}

## 6. Join a worker node

Same steps on the worker: paste its worker JSON config and press **Join**:

{{< shot src="/img/wizard/14-wk-join-form.png" alt="Join as worker" caption="Join as worker (click to enlarge)" >}}

{{< shot src="/img/wizard/14-wk-join-done.png" alt="Worker joined" caption="Worker joined (click to enlarge)" >}}

That's it. You built a three-node Kubernetes cluster — install, create,
join — without typing a single command.

## Notes

- With Secure Boot enabled, enroll the SimpleK8s key once per machine — see [Secure Boot](/documentation/installation/secure-boot/).
- Prefer the terminal? Follow the [terminal installation guide](/documentation/installation/install-terminal/).
