---
title: "Containerd Update to 2.1 - Deprecation Warning"
date: 2025-05-25T17:00:01+02:00
draft: true

tags:
- updates
- containerd
authors:
- José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

{{< alert type="warning" >}}
A recent update to containerd to version 2.1.x was applied within SimpleK8s release 202505xx. This update includes a deprecation warning that requires attention.
{{< /alert >}}

**Deprecation Warning:**
Containerd v2.1 introduced a deprecation warning related to the configuration of CNI plugins. Specifically:

```
DEPRECATION: The `bin_dir` property of `[plugins."io.containerd.cri.v1.runtime".cni`] is deprecated since containerd v2.1 and will be removed in containerd v2.2. Use `bin_dirs` in the same section instead.
```

**Resolution:**

To address this deprecation, execute the following command:
```sh                                                                              sed -i 's/bin_dir/bin_dirs/g' /etc/containerd/config.toml                          ```
```

**Explanation:**

This command replaces all occurrences of `bin_dir` with `bin_dirs` within the `/etc/containerd/config.toml` configuration file. This action is necessary to comply with the upcoming removal of the `bin_dir` property in containerd v2.2.

**Notes:**
*   This update was implemented as part of the SimpleK8s infrastructure.
*   Please ensure this change is properly tested to avoid any disruption to your cluster.
