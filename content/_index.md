---
title: "SimpleK8s"
date: 2023-06-23T18:10:03+02:00
draft: false
---

{{< center >}}

- [🤔 About](/documentation/information/about/)
- [🧩 Features](/documentation/information/features/)
- [❓ FAQs](/documentation/information/faqs/)
{{< /center >}}

## Start in minutes

- **[Install from the browser](/documentation/installation/install-web/)** —
  no commands: the `nodectl wizard` creates users, storage and the first
  control plane.
- **[Install from the terminal](/documentation/installation/install-terminal/)** —
  `nodectl install` writes a verified image to the disk.
- **[Download the image](/download/)** and verify its GPG signature
  before flashing it.

## Platforms

`x86-64` · `rpi4` · `rpi5` — one signed bootable file per board. See
[supported platforms and integrations](/documentation/information/platforms/).

## Backends

Proven with **CephFS, CephRBD and NFS** for storage, and **Calico and
MetalLB** for networking. And since the cluster is plain Kubernetes,
standard tooling (`kubectl`, Helm, ArgoCD, Flux, Terraform) works as is.

## Community

Non-profit and community-driven: questions, ideas and feedback at
[github.com/simplek8s/discussions](https://github.com/orgs/simplek8s/discussions),
or [community@simplek8s.org](mailto:community@simplek8s.org).
