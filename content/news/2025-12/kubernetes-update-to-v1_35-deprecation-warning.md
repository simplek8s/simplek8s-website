---
title: "Kubernetes Update to v1.35 - Deprecation Warning"
date: 2025-12-31T23:18:21+02:00
draft: false

tags:
  - updates
  - kubernetes
  - maintenance
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

{{< alert type="info" >}}
By default, SimpleK8s does not upgrade third-party files automatically.

You can follow the next guide to upgrade third party programs:
[Upgrade third-party programs](/documentation/maintenance/update/#upgrade-third-party-programs)
{{< /alert >}}

Kubernetes v1.35 was introduced on SimpleK8s releases at version
**202512310724** or later.

Kubernetes v1.35 introduced a deprecation related to the
`--pod-infra-container-image` flag.
This flag **could be set** in the `/var/lib/kubelet/kubeadm-flags.env` file.
To upgrade to Kubernetes v1.35, you need to remove this flag from the file.

```sh
sed -i 's/--pod-infra-container-image=[^ ]*//g' /var/lib/kubelet/kubeadm-flags.env
```

Normally, the kubelet service is restarted automatically. If it is not, you can
restart it manually:

```sh
systemctl restart kubelet
```
