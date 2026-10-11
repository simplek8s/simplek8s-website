---
title: "Features"
date: 2023-07-10T01:51:00+02:00
draft: false
weight: 100
aliases:
  - /documentation/features
---

- 🧩 **Simplified**: Effortlessly create a production-ready Kubernetes cluster using a web UI.

- 🧭 **Predictable**: Streamlined essentials for a production-ready Kubernetes cluster, free from unnecessary bloatware.

- 🪶 **Lightweight**: Only ~40MB in size, built with Buildroot for embedded Linux distributions.

- 📦 **Embedded**: Complete Linux distribution packed in a single bootable file.

- 💿 **Immutable**: Read-only distribution files stored in RAM, preserving only what you need.

- 🛡️ **Privacy**: Open source, signed releases, and community-driven development.

- 🤝 **Compatibility**: Seamless integration with Kubernetes using standard toolsets like Linux, Systemd, Containerd and Kubeadm — `kubectl`, Helm, ArgoCD, Flux and Terraform work as usual.

💾 **Proven integrations**: Ceph (CephFS, CephRBD) and NFS for storage;
Calico and MetalLB for networking.

- 🔧 **Preconfigurable**: Easily configure your system on each reboot with an optional `simplek8s.yaml` file.

- ⚙️ **Rolling distro**: a new image is published every time any component is released (new Kubernetes, kernel, containerd, ...); images move from `dev` to `rolling` to `stable` as the community validates them.

- ⏫ **Upgradeable**: Perform upgrades anytime with a simple `simplek8s-upgrade` command and reboot.

- 🧬 **Cloneable**: Gain independence by cloning this distribution whenever desired.

- 💰 **Non-profit driven**: Prioritizes the interests of the user community and aims to provide a high-quality Kubernetes distribution.

## Working on

- 📑 **Documentation**: Comprehensive documentation to help users understand and utilize the features effectively.

- 📚 **Extensibility**: Provides a range of extensions, allowing users to integrate custom tools, or kernel modules into SimpleK8s.
