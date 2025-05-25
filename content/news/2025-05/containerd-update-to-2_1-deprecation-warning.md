---
title: "Containerd Update to 2.1 - Deprecation Warning"
date: 2025-05-25T17:00:01+02:00
draft: false

tags:
  - updates
  - containerd
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

{{< alert type="info" >}}
By default, SimpleK8s does not upgrade third-party files automatically.
{{< /alert >}}

Containerd v2.1 introduced a deprecation warning related to the configuration of CNI plugins. Specifically, the `bin_dir` property within the `[plugins."io.containerd.cri.v1.runtime".cni]` section is deprecated. It has been replaced with the `bin_dirs` property, which expects an array of values.

{{< alert type="warning" >}}
DEPRECATION: The `bin_dir` property of `[plugins."io.containerd.cri.v1.runtime".cni`] is deprecated since containerd v2.1 and will be removed in containerd v2.2.
{{< /alert >}}

**Example Configuration (Valid for Containerd 2.1):**

```toml
...
[plugins]
  ...
  [plugins.'io.containerd.cri.v1.runtime']
    ...
    [plugins.'io.containerd.cri.v1.runtime'.cni]
      bin_dirs = ['/opt/cni/bin']
      ...
    ...
  ...
...
```

## Resolution:

Follow these steps to properly upgrade Containerd:

1. Stop the Containerd service:
   ```sh
   systemctl stop containerd
   ```
2. Restore Containerd binary from factory:
   ```sh
   cp /usr/share/factory/usr/local/bin/containerd /usr/local/bin/containerd
   ```
3. Delete the deprecated configuration file:
   ```sh
   rm /etc/containerd/config.toml
   ```
4. Restart the Containerd service. The configuration file
   (`/etc/containerd/config.toml`) will be recreated automatically.
   ```sh
   systemctl start containerd
   ```
