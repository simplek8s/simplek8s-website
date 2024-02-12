---
title: "SimpleK8s-Wizard"
date: 2023-07-17T21:49:29Z
draft: false
aliases:
- /documentation/wizard
---
## Description

The SimpleK8s-Wizard is a user-friendly program that enables you to manage your Kubernetes node through a web-based UI.

{{< alert type="info" >}}
The `Installer` section is only visible when using SimpleK8s without persistence.
{{< /alert >}}

To access the web UI, go to: `https://<your-node-IP>:5443`

By default, the SimpleK8s-Wizard is enabled. However, you can disable it using the following command:

```console
# systemctl disable --now simplek8s-wizard
```


## Sections

- **[Installer](#installer)** (visible only on non-persistent environments)
- **[Status](#status)**
	- **Node**
		- Name
		- CPU
		- RAM
		- Storage
		- Interfaces
		- Mountpoints
		- Process list
- **[KubeAdm](#kubeadm)**
	- **Create or Join a K8s cluster** (visible only on nodes that have not the folder `/etc/kubernetes`)
	- **Clean up** (visible only on nodes that have the folder `/etc/kubernetes`)
	- **Tokens** (visible only on Control Plane nodes after creation/joining)
	- **Add-ons**
		- Network controller (CNI)
			- Calico
		- Storage controller (CSI)
		- Load Balancer controller
			- MetalLB
		- Ingress controller
			- Kubernetes-Nginx

### Installer

The Installer section allows you to install SimpleK8s on a persistent storage medium, such as MVME, SSD, or HDD disk drivers.

{{< alert type="warning" >}}
Please note that the `Installer` does not support partition editing. Selecting a disk will result in a full wipe of the selected disk.
{{< /alert >}}

The wizard will guide you through the following steps:

1. Select the disk
2. Create partitions
3. (Optionally) Upload a simplek8s.yaml file for configuration.


### Status

The `Status` section provides an overview of your Kubernetes node's current status and resource utilization.

#### Node

- **Name:** [Node Name]
- **CPU:** [CPU Details]
- **RAM:** [RAM Details]
- **Storage:** [Storage Details]
- **Interfaces:** [Network Interfaces Details]
- **Mountpoints:** [Mounted Filesystems Details]
- **Process List:** [List of Running Processes]


### KubeAdm

The `KubeAdm` section allows you to manage your Kubernetes cluster setup.

#### Create or Join a K8s Cluster

In this section, you can create a new Kubernetes cluster or join an existing one.

#### Tokens

This section is only visible on Control Plane nodes after successfully creating or joining a Kubernetes cluster. It allows you to create `kubeadm` tokens to join new nodes.


### Add-ons

The `Add-ons` section lets you configure various Kubernetes add-ons for enhanced functionality.

#### Network Controller (CNI)

- **Calico:** Set up the Calico network controller for your cluster.

#### Storage Controller (CSI)

Configure the storage controller for seamless storage management in your Kubernetes cluster.

#### Load Balancer Controller

- **MetalLB:** Set up MetalLB, the Load Balancer controller, to efficiently distribute incoming traffic.

#### Ingress Controller

- **Kubernetes-Nginx:** Set up the Kubernetes-Nginx Ingress controller to manage incoming HTTP and HTTPS traffic.

