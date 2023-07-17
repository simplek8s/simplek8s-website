---
title: "SimpleK8s Wizard"
date: 2023-07-17T21:49:29Z
draft: true
---
## Description
Listening for connections at https://0.0.0.0:5443 (replace by your node IP).

Enabled by default. Can be disabled with the next command:

```console
# systemctl disable --now simplek8s-wizard
```


## Sections
- **Installer** (only visible on non-persistent environments)
- **Status**
	- **Node**
		- Name
		- CPU
		- RAM
		- Storage
		- Interfaces
		- Mountpoints
		- Process list
- **KubeAdm**
	- **Create or Join a K8s cluster**
	- **Tokens** (only visible on Control Plane nodes after creation/joined)
	- **Add-ons**
		- Network controller (CNI)
			- Calico
		- Storage controller (CSI)
		- Load Balancer controller
			- MetalLB
		- Ingress controller
			- Kubernetes-Nginx
