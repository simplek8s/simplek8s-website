---
title: "SimpleK8s Controller"
date: 2026-09-17T00:00:00Z
draft: false
---
## Description

The SimpleK8s Controller automates distro updates and reboots across
a whole Kubernetes cluster. It runs as a privileged DaemonSet (one
pod per node) with two jobs:

- **Distro updates**: each pod checks the signed release repo on a
  schedule, verifies every artifact against the GPG-signed sha256
  index, and stages new kernels on its own boot partition. Nodes only
  ever consider their own board flavor (`x86-64`, `rpi4`, `rpi5`).
- **Node reboots**: a small HTTP API schedules reboots with a global
  queue — workers before control planes, at most one control plane at
  a time — with PodDisruptionBudget-aware, concurrency-limited drains
  and one Kubernetes Event per state transition.

Reboots only ever start inside a **maintenance window** you configure;
by default nothing reboots automatically.

## Installation

```console
$ helm install simplek8s-controller oci://ghcr.io/simplek8s/charts/simplek8s-controller \
    --namespace simplek8s --create-namespace
```

The code and the design document live at
[github.com/simplek8s/simplek8s-controller](https://github.com/simplek8s/simplek8s-controller).

## Configuration

One flat ConfigMap (`simplek8s/simplek8s-controller`):

| Key | Default | Meaning |
| --- | --- | --- |
| `updates.url` | `https://dl.simplek8s.org/simplek8s/stable` | release channel (`dev`/`rolling`/`stable`) or custom URL |
| `updates.preserve` | `3` | staged kernels to keep per node |
| `updates.max-percent-usage` | `75` | boot-partition usage cap |
| `updates.windows` | `["@every 12h"]` | when update work (checks, staging) may run |
| `reboots.windows` | `[]` | when reboots may start (**empty = opt-in**; nothing auto-reboots until you set it) |
| `reboots.max-concurrent` | `1` | parallel reboots |
| `reboots.drain-timeout` | `10m` | stuck drains fail instead of hanging |

## Node annotations

Per-node state lives in annotations, so it survives restarts:

- `simplek8s.org/next-kernel`: the node's boot goal (a release `ts`).
  Point it at a staged version and the local pod re-points the
  bootloader; while `reboots.windows` is open, a node whose goal
  differs from the running kernel becomes reboot-eligible by
  derivation and is enqueued automatically.
- Reboot state (`requested → draining → rebooting →
  completed|failed`) tracks an in-flight reboot.

## Reboot API

There is no Service by design — reach it with a port-forward:

```console
$ kubectl port-forward -n simplek8s daemonset/simplek8s-controller 1880:8080
```

```console
$ # Schedule a reboot:
$ curl -X POST localhost:1880/api/v1/reboots/my-node
$ # Inspect it:
$ curl localhost:1880/api/v1/reboots/my-node
$ # Cancel it:
$ curl -X DELETE localhost:1880/api/v1/reboots/my-node
```

## Manual updates and rollback

For one node without (or outside) the Controller, use
[simplek8sctl](/documentation/commands/simplek8sctl) — it writes the
same files, and the Controller adopts a CLI-staged default through
the normal `next-kernel` comparison once annotated.

Rollback is one annotation edit: set `simplek8s.org/next-kernel`
back to the running (or any preserved) version and reboot — old
kernels stay on the boot partition under retention.
