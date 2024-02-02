---
title: "Frequently Asked Questions (FAQs)"
date: 2023-07-10T08:07:00+02:00
draft: false
---
**Q: What is the purpose of this new Linux distribution?**

A: The purpose of SimpleK8s is to provide a hassle-free Linux operating system specifically designed for production-grade Kubernetes clusters. It ensures seamless rolling upgrades without any unpleasant surprises or unnecessary software.


**Q: What are the system requirements for installing and running this Linux distribution?**

A: The system requirements for different scenarios are as follows:
- Bare minimum to boot:
	- 1 CPU
	- 40Mb Storage
	- 128Mb RAM.
- Minimum recommended:
	- 1 CPU
	- 512Mb storage
	- 128Mb RAM
- Kubernetes (v1.27) Control-Plane:
	- 2 CPUs
	- 4Gb storage
	- 3Gb RAM
- Kubernetes (1.27) Worker:
	- 1 CPU
	- 1Gb storage
	- 1Gb RAM


**Q: Is this Linux distribution compatible with my hardware and peripherals?**

A: SimpleK8s is designed to run a lean Kubernetes cluster, so it does not include out-of-scope kernel drivers and firmware, such as sound and HID systems. However, you can compile your own flavor or use extensions to include additional functionality.


**Q: What desktop environments or window managers does this Linux distribution support?**

A: SimpleK8s does not include any desktop environments. You can use the TTY console or access the web UI at [https://node-ip:5443](https://node-ip:5443).


**Q. Can I dual-boot this Linux distribution with another operating system?**

A: Yes, you can dual-boot SimpleK8s with another operating system. SimpleK8s is distributed as one file that can be booted using any BIOS or UEFI boot manager. We distribute a raw storage image too that includes the SimpleK8s kernel image, Syslinux as boot manager (BIOS and UEFI), and a Microsoft-signed Preloader for secure boot.


**Q: What package manager does this Linux distribution use?**

A: SimpleK8s does not include a package manager. However, you can run any container of your choice. SimpleK8s utilizes Containerd and Nerdctl as a Docker replacement (instead of execute the command `docker`, use `nerdctl`). You can also run your preferred distribution as a container inside SimpleK8s. For example, the script `/usr/local/bin/toolbox` launches a privileged Linux Alpine with the host filesystem `/` mounted at `/host`.


**Q: Are there any unique features or applications included in this Linux distribution?**

A: Yes, SimpleK8s includes the following unique applications:
- `simplek8s-wizard`: An optional web UI running at `:5443` that assists you in the installation and setup of your Kubernetes cluster. You can utilize `kubeadm` instead. It can be disabled at any time using the command `systemctl disable --now simplek8s-wizard`
- `simplek8s-update`: A program that checks and upgrades the SimpleK8s kernel image.


**Q: How often are updates and security patches released for this Linux distribution?**

A: SimpleK8s follows a rolling-release upgrade approach.
Whenever a program (such as Systemd, Containerd, Kubernetes, etc.) is updated, an automated build system generates a new SimpleK8s kernel image. This new version is initially released as a `rolling` update for the `simplek8s-update` program. Once we receive sufficient successful reports indicating that the new release correctly launches a fully functional Kubernetes cluster (single and multi-node, control-plane, and worker roles), the release is promoted as `stable`. These procedures are replicated for each supported platform, including `x86-64` and `rpi4`.


**Q: Is there an active and helpful community around this Linux distribution for support and troubleshooting?**

A: Currently, there is no official community established. However, you can reach us at [community@simplek8s.org](mailto:community@simplek8s.org) for assistance. We are planning to introduce new communication channels in the future to enhance support and engagement.


**Q: Are there any known issues or limitations with this Linux distribution that I should be aware of?**

A: SimpleK8s operate using an `/usr` read-only, and a `/` memory-backed storage. To ensure proper functionality, certain directories are bind-mounted at `/var/${DIRECTORY}`, including `/etc`, `/home`, `/mnt`, `/usr/local`, `/usr/libexec`, `/root`, and `/opt`. It is essential to mount a persistent storage at `/var` to maintain data integrity and preserve configurations. Please keep this in mind while working with SimpleK8s.

