---
title: "Platforms and integrations"
date: 2026-10-11T00:00:00+02:00
draft: false
toc: true
aliases:
  - /documentation/information/platforms
  - /documentation/platforms
---

SimpleK8s ships one bootable file per board. Today, supported platforms:

| Platform | Architecture | Notes                  |
| -------- | ------------ | ---------------------- |
| `x86-64` | amd64        | Desktops, servers, VMs |
| `rpi4`   | arm64        | Raspberry Pi 4         |
| `rpi5`   | arm64        | Raspberry Pi 5         |

`nodectl` auto-detects the board flavor and the boot device, and the
[SimpleK8s Controller](/documentation/maintenance/controller/) also only
considers each node's own flavor.

## Extensibility

The base image is intentionally minimal: it does not ship out-of-scope
kernel drivers or firmware. For other boards, or components that need extra
kernel modules, you can compile your own flavor or use extensions.

## Proven integrations

The distro has been tested with:

- **Storage**: Ceph (CephFS and CephRBD) and NFS.
- **Networking**: Calico and MetalLB.
- **Cluster tooling**: `kubectl`, Helm, ArgoCD, Flux, Terraform — it is
  plain Kubernetes, so any standard CSI/CNI works as usual.
