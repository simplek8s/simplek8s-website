---
title: "Deprecatin warning for Containerd to 2.1"
date: 2025-05-25T17:00:01+02:00
draft: true

tags:
- updates
- containerd
authors:
- José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

{{< alert type="warning" >}}
We updated containerd to version 2.1.x at SimpleK8s release 202505xx.
{{< /alert >}}

The following deprecation warning will be warned by containerd:

```
DEPRECATION: The `bin_dir` property of `[plugins."io.containerd.cri.v1.runtime".cni`] is deprecated since containerd v2.1 and will be removed in containerd v2.2. Use `bin_dirs` in the same section instead.
```

You only need to execute the next command in order to fix this deprecation:

```sh
$ sed -ei 's///g' /etc/containerd/config.toml
```
