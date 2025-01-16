---
title: "Upgrade Containerd to 2.x"
date: 2025-01-16T23:30:48+01:00
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

Containerd has upgraded from 1.x to 2.x, which also introduces changes to its
configuration file.

Follow these steps to upgrade Containerd:

1. Ensure you are using at least SimpleK8s version **202501160115**,
[download it here](/download).
2. Stop the Containerd service:
    ```sh
    systemctl stop containerd
    ```
3. Remove the old Containerd binary:
    ```sh
    rm /usr/local/bin/containerd
    ```
2. Delete the deprecated configuration file:
    ```sh
    rm /etc/containerd/config.toml
    ```
4. Restart the Containerd service. The configuration file
(`/etc/containerd/config.toml`) will be recreated automatically.
    ```sh
    systemctl start containerd
    ```
