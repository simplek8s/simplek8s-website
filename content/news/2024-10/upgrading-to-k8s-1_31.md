---
title: "Upgrading to K8s 1.31"
date: 2024-10-25T20:05:45+02:00
draft: false

tags:
- kubernetes
- maintenance
authors:
- José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

During the past week, I upgraded my home cluster to Kubernetes 1.31, which was not the first time I attempted an upgrade to this version. A few weeks ago, I had tried to upgrade unsuccessfully, but I couldn't afford to fall behind on kubernetes and SimpleK8s updates. Therefore, it was time for me to address some issues that arose during the process.

The problems I encountered were:
- Google changed the Kubernetes binaries CDN from `storage.googleapis.com/kubernetes-release` to `dl.k8s.io`, which is supported by Fastly.
- Kubernetes 1.31 introduces changes in service selectors.
- The Kubeadm upgrade process now requires upgrading the cluster before updating the binaries.

Due to these issues, I was unable to upgrade my cluster until now (it required additional understanding of these changes).

It's time to explain each issue:


## Kubernetes CDN changes

Google changes binaries URL from:
`https://storage.googleapis.com/kubernetes-release/release/v${INSTALL_VERSION}/bin/${INSTALL_PLATFORM}/${INSTALL_ARCH}/${INSTALL_BASENAME}`
to:
`https://dl.k8s.io/release/v${INSTALL_VERSION}/bin/${INSTALL_PLATFORM}/${INSTALL_ARCH}/${INSTALL_BASENAME}`

This change uses Fastly, which prevents proxy passing from their CDN to our nginx proxy. As a result, all requests return an [HTTP Status 421 Misdirected Request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/421). I was unable to resolve this issue within my time constraints, so I disabled our CDN for the Kubernetes binaries.


## Kubernetes 1.31 and Services changes

The changes were triggered by two commits:
- [don't watch headless services on kubelet](https://github.com/kubernetes/kubernetes/commit/7d78fb791d362d08ac0cfd672b7f07aa547d205b)
- [implement field selector for clusterIP on services](https://github.com/kubernetes/kubernetes/commit/c37e14364c261eda9e4991c8942d5fd20688441a)

Normally, a Kubeadm upgrade is straightforward, but this time was not the case. The changes require upgrading the `kubeadm` binary first, while keeping it at version 1.30 for the rest of the binaries (`kubelet`, `kubectl`, `kube-api`, `kube-controller`, `kube-scheduler`, and `kube-proxy`). After upgrading the cluster, you can upgrade the remaining binaries.

This approach was not ideal, requiring a lot of additional understanding from my part. It seems that this is the official way to upgrade Kubernetes:
https://github.com/kubernetes/kubernetes/issues/127316

However, this means that some third-party tools and configurations will also be affected:
- Calico & Flannel: https://github.com/flannel-io/flannel/issues/2031
- Control plane load balancers (a few CP might have lower versions than kubeadm during the upgrade)
- Requires an experimental feature gate [`ControlPlaneKubeletLocalMode`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#feature-gates). Normally, this feature is not required until it's GA. Now, it seems that alpha features can be released without sufficient notice (🫣).

I'm not comfortable with this approach, but I acknowledge that the importance of non-surprise upgrades in production environments cannot be ignored. Alpha features should never be required for anyone; everyone has limited time to understand and learn about Kubernetes commits and issue messages.


## The Official Way to Upgrade a Kubeadm Cluster

In the past, I would upgrade all binaries before running `kubeadm upgrade plan` and `kubeadm upgrade apply v1.31.2`. However, this approach is not recommended: https://github.com/kubernetes/kubernetes/issues/127316#issuecomment-2354195820 ⚠️

The correct steps are:
- Upgrade the `kubeadm` binary.
- Upgrade you cluster version.
- Upgrade your k8s binaries from all yours control-planes and nodes.

If you, like me, missed these steps, you might encounter pods disconnections (Calico or Flannel). You can resolve this by downgrading all binaries to v1.30.5; upgrade just the kubeadm to v1.31.2, and follow the guide from before.

Good luck!


Enough changes for this month!
