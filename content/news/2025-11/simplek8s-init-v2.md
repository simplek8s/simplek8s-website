---
title: "SimpleK8s Init v2"
date: 2025-11-16T17:13:29+02:00
draft: false

tags:
  - updates
  - simplek8s-init
authors:
  - José Luis Salvador Rufo <salvador.joseluis+simplek8s@gmail.com>
---

**TL;DR:** We upgraded SimpleK8s Init. No changes are required on your side.

We decided to upgrade SimpleK8s Init because systemd changed the behavior of
`systemd-generators`. They are now asynchronous (which is cool!). However, this
change means we can no longer guarantee a successful boot process with the old
SimpleK8s Init code 😥.
That said, this turned out to be a great opportunity to modernize and improve
SimpleK8s Init!

The previous version of SimpleK8s Init had many steps and dependencies required
to boot from the initrd into the real system root. It relied on
`systemd-generators` to create transient units that mounted and populated the
mount points defined in `simplek8s.yaml`.

The new SimpleK8s Init (v2) removes many of those requirements and simplifies
the entire flow from initrd to the real system. Here are some of the key
improvements:

- The initrd stage now only executes SimpleK8s Init, instead of booting systemd
  twice (once for initrd, once for the real root).
- `systemd-generators` have been replaced with our own mount logic, removing an
  extra step that previously ran after the second boot stage.
- A large amount of code has been removed, including the dictionary-based
  password generator, systemd unit templates, and D-Bus communication.
- The step that initialized `systemd-tmpfiles` in initrd has been removed.
  Since we no longer boot systemd in initrd, there is no need to run this stage
  anymore.

This update took a significant amount of my time. It is a full rewrite of
SimpleK8s Init, but I believe the improvements are absolutely worth it. 🎉👏
