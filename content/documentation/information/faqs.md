---
title: "Frequently Asked Questions (FAQs)"
date: 2023-07-10T08:07:00+02:00
draft: false
toc: true
aliases:
  - /documentation/faqs
---

## What is the purpose of this new Linux distribution?

The purpose of SimpleK8s is to provide a hassle-free Linux operating system specifically designed for production-grade Kubernetes clusters. It ensures seamless rolling upgrades without any unpleasant surprises or unnecessary software.

## What are the system requirements for installing and running this Linux distribution?

The system requirements for different scenarios are as follows:

- Bare minimum to boot:
  - 1 CPU
  - 40Mb Storage
  - 128Mb RAM.
- Minimum recommended:
  - 1 CPU
  - 512Mb storage
  - 128Mb RAM
- Kubernetes 1.37 Control-Plane:
  - 2 CPUs
  - 4Gb storage
  - 3Gb RAM
- Kubernetes 1.37 Worker:
  - 1 CPU
  - 1Gb storage
  - 1Gb RAM

## Is this Linux distribution compatible with my hardware and peripherals?

SimpleK8s is designed to run a lean Kubernetes cluster, so it does not include out-of-scope kernel drivers and firmware, such as sound and HID systems. However, you can compile your own flavor or use extensions to include additional functionality — see [supported platforms and integrations](/documentation/information/platforms/).

## What desktop environments or window managers does this Linux distribution support?

SimpleK8s does not include any desktop environments. You can use the TTY console or access the web UI at [https://node-ip:5443](https://node-ip:5443).

## Can I dual-boot this Linux distribution with another operating system?

Yes, you can dual-boot SimpleK8s with another operating system. SimpleK8s is distributed as one file that can be booted using any BIOS or UEFI boot manager. We distribute a raw storage image too that includes the SimpleK8s kernel image, GRUB as boot manager (BIOS and UEFI), and a Microsoft-signed shim for secure boot.

## What package manager does this Linux distribution use?

SimpleK8s does not include a package manager. However, you can run any container of your choice. SimpleK8s utilizes Containerd and Nerdctl as a Docker replacement (instead of execute the command `docker`, use `nerdctl`). You can also run your preferred distribution as a container inside SimpleK8s. For example, the script `/usr/local/bin/toolbox` launches a privileged Linux Alpine with the host filesystem `/` mounted at `/host`.

## Are there any unique features or applications included in this Linux distribution?

Yes, SimpleK8s includes the following unique applications:

- [Web installation guide](/documentation/installation/install-web/): An optional web UI (the `nodectl wizard`) running at `:5443` that assists you in the installation and setup of your Kubernetes cluster. You can utilize `kubeadm` instead.
- [nodectl](/documentation/commands/nodectl/): A program that checks and upgrades the SimpleK8s kernel image.

## How often are updates and security patches released for this Linux distribution?

SimpleK8s is a rolling distro: every time one of its components gets a new
release — a new Kubernetes version, a new kernel LTS, containerd, etc. — CI/CD
builds a new image and publishes it. If Kubernetes 1.38.0 came out tomorrow,
there would be a new SimpleK8s release with it in a few days.

Each image is promoted through channels as the community validates it:

- `dev`: freshly published by CI/CD; the newest, not yet validated.
- `rolling`: being promoted; already passed basic validation.
- `stable`: validated by the community — successful reports with fully
  functional clusters (single and multi-node, control plane and worker roles)
  — and ready for production.

This procedure is replicated for each supported platform: `x86-64`, `rpi4`
and `rpi5`.

## Is there an active and helpful community around this Linux distribution for support and troubleshooting?

Yes. The code lives at [github.com/simplek8s](https://github.com/simplek8s);
questions, ideas and feedback are welcome in the
[community discussions](https://github.com/orgs/simplek8s/discussions), and
you can also reach us at [community@simplek8s.org](mailto:community@simplek8s.org).

## Is SimpleK8s backed by a company or do you provide commercial support?

No: SimpleK8s is a non-profit, community-driven project and there is no
commercial support with SLA. If you need enterprise support,
[K3s](https://k3s.io/) is backed by Rancher/SUSE and
[Microk8s](https://microk8s.io/) by Canonical, and both offer commercial
plans.

If what you need is a stack you control — signed, immutable, no lock-in —
with rolling distro upgrades and community support, SimpleK8s is the option.

## Which storage and networking backends has the distro been tested with?

At least the following:

- **Storage**: Ceph (CephFS and CephRBD) and NFS.
- **Networking**: Calico and MetalLB.

The cluster is plain Kubernetes, so any standard CSI/CNI works as usual.
If a component needs extra kernel modules not in the base image, you can
compile your own flavor.

## Can I deploy an HA cluster?

Yes. The [web installation guide](/documentation/installation/install-web/)
shows how to join a second control plane node (and more) with the `nodectl
wizard`, and the [SimpleK8s Controller](/documentation/maintenance/controller/)
reboots nodes with control-plane awareness: workers first, at most one control
plane at a time, and PodDisruptionBudget-aware.

## Are there any known issues or limitations with this Linux distribution that I should be aware of?

SimpleK8s operate using an `/usr` read-only, and a `/` memory-backed storage. To ensure proper functionality, certain directories are bind-mounted at `/var/${DIRECTORY}`, including `/etc`, `/home`, `/mnt`, `/usr/local`, `/usr/libexec`, `/root`, and `/opt`. It is essential to mount a persistent storage at `/var` to maintain data integrity and preserve configurations. Please keep this in mind while working with SimpleK8s.
