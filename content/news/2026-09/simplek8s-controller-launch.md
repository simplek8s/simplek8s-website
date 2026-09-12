---
title: "SimpleK8s Controller"
date: 2026-09-12T23:45:00+02:00
draft: false

tags:
  - updates
  - simplek8s-controller
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

**TL;DR:** We have a new tool: [SimpleK8s
Controller](https://github.com/simplek8s/simplek8s-controller). It
safely reboots your nodes and stages SimpleK8s distro updates on them.

I'm happy to announce the launch of SimpleK8s Controller, a
node-management controller for SimpleK8s Kubernetes clusters. It runs as a
privileged DaemonSet (one pod per node) and handles two jobs:

- **Distro updates**: verified staging of signed SimpleK8s releases on each
  node's boot partition. Every release file is checked against a
  GPG-signed, sha256-verified index before it touches the disk, so an
  untrusted repo can never write to a boot partition. Staging happens on a
  schedule (every 12 hours by default), and reboots into the new release
  only happen while a maintenance window is open — never automatically by
  default.
- **Node reboots**: a small HTTP API (reached via `kubectl port-forward`)
  to schedule reboots for one node, a few nodes, or the whole cluster.
  Reboots are concurrency-limited, availability-aware and
  PodDisruptionBudget-aware, with control plane nodes always going last and
  at most one of them rebooting at a time.

Why a new tool? Because updating the distro on a cluster used to be a very
manual process: download and verify releases, stage them on each node,
cordon and drain, reboot, wait, uncordon... one node at a time, keeping a
spreadsheet in your head about which node was in which state. It worked,
but it was tedious and easy to get wrong, especially on multi-node
clusters.

The Controller turns that into a supervised lifecycle. A few things I'm
particularly happy with:

- **The reboot lifecycle is fully observable**: each node walks through
  `requested` → `draining` → `rebooting` → `completed`/`failed`, with
  Kubernetes Events at every step and the state kept in Node annotations,
  so it survives controller restarts and even a leader change.
- **Failures are safe by design**: if a node fails, the whole queue pauses
  until you clear it; a stuck drain times out instead of hanging forever;
  and the controller only uncordons nodes it cordoned itself.
- **Rollback is one command**: set the `simplek8s.org/next-kernel`
  annotation back to the currently running version and reboot — the old
  kernel is always kept on the boot partition.

Installation is a single `helm install` of the chart from
`oci://ghcr.io/simplek8s/charts/simplek8s-controller`, and everything is
tunable through one ConfigMap (update windows, reboot windows, concurrency,
drain timeouts...). The code is written in Go, and the whole project —
including the design document — is [on
GitHub](https://github.com/simplek8s/simplek8s-controller), so feel free to
take a look and send feedback! 🎉
