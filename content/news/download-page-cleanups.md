---
title: "Download Page Cleanups"
date: 2024-01-30T22:37:29+01:00
draft: false
---

These days, I ([José Luis Salvador Rufo](mailto:salvador.joseluis+simplek8s@gmail.com)), have been working on enhancing the [Download](/download) page.

Previously, it was just a dump of the official [SHA256SUMS](https://dl.simplek8s.org/simplek8s/stable/SHA256SUMS), contradicting the simplicity philosophy of this distribution.

I set a few requirements for myself during this improvement:

- Parse data from the official SHA256SUMS files.
- Implement filters.
- Ensure no reliance on JavaScript.
- Make the page responsive.

With these requirements in mind, I spent a few hours these days to enhance the user experience.

Addressing the first point was straightforward. The initial iteration involved organizing the SHA256SUMS into an HTML table, breaking down each token, such as channel, version, architecture, component, compression, and hash.

The second point posed more complexity due to the third requirement (no JavaScript support). I opted to useCSS selectors like `:has()` and `:not()` to hide specific rows from the releases table. When drawing each row, I added a few classes. Using CSS selectors, I could hide different rows and columns without Javascript. 🙌

The last requirement added an element of entertainment, at least for now. Perhaps in the future, with more architectures, I may change input radios to a vertical layout. On very small screens, I've hidden a few icons and shortened some texts. The column visibility selector was a nice feature to reduce the columns glut.

I genuinely believe that I've made significant improvements to the SimpleK8s website this week. 👍

[José Luis Salvador Rufo](mailto:salvador.joseluis+simplek8s@gmail.com).