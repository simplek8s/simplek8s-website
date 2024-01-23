---
title: "Download"
date: 2023-07-10T08:01:00+02:00
draft: false
---


## Channels

- [Stable](#stable)
- [Rolling](#rolling)
- [Dev](#dev)


{{< details summary="Stable" open=true id="stable" class="primary" >}}
These links are parsed from the file [SHA256SUMS](https://dl.simplek8s.org/simplek8s/stable/SHA256SUMS).

```console
$ curl https://dl.simplek8s.org/simplek8s/stable/SHA256SUMS -O
$ curl https://dl.simplek8s.org/simplek8s/stable/SHA256SUMS.gpg -O
$ gpg --verify SHA256SUMS.gpg SHA256SUMS
```

{{< releases url="https://dl.simplek8s.org/simplek8s/stable/SHA256SUMS" >}}
{{< /details >}}


{{< details summary="Rolling" open=false id="rolling" class="warning" >}}
These links are parsed from the file [SHA256SUMS](https://dl.simplek8s.org/simplek8s/rolling/SHA256SUMS).

```console
$ curl https://dl.simplek8s.org/simplek8s/rolling/SHA256SUMS -O
$ curl https://dl.simplek8s.org/simplek8s/rolling/SHA256SUMS.gpg -O
$ gpg --verify SHA256SUMS.gpg SHA256SUMS
```

{{< releases url="https://dl.simplek8s.org/simplek8s/rolling/SHA256SUMS" >}}
{{< /details >}}


{{< details summary="Dev" open=false id="dev" class="danger" >}}
These links are parsed from the file [SHA256SUMS](https://dl.simplek8s.org/simplek8s/dev/SHA256SUMS).

```console
$ curl https://dl.simplek8s.org/simplek8s/dev/SHA256SUMS -O
$ curl https://dl.simplek8s.org/simplek8s/dev/SHA256SUMS.gpg -O
$ gpg --verify SHA256SUMS.gpg SHA256SUMS
```

{{< releases url="https://dl.simplek8s.org/simplek8s/dev/SHA256SUMS" >}}
{{< /details >}}
