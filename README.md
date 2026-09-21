# SimpleK8s Website

![SimpleK8s Website Logo](docs/images/icon.png)

The official website for [SimpleK8s](https://simplek8s.org), the site where users read the documentation, browse the news, and download the software.

Built with [Hugo](https://gohugo.io/) and deployed as a static site served by Nginx from a container image.

## Structure

- `content/` — site content in Markdown
  - `documentation/` — docs (installation, commands, maintenance, information)
  - `news/` — news posts
- `layouts/` — Hugo templates and partials
- `config/` — Hugo configuration
- `hugo.toml` — Hugo site configuration
- `assets/` / `static/` — CSS (Bootstrap + PostCSS) and static files

## Prerequisites

- [Hugo](https://gohugo.io/) (extended)
- Node.js and npm
- Docker (for container builds)

## Development

Install JS dependencies and run the dev server:

```sh
npm ci
make watch
```

The site will be served locally with live reload.

## Formatting

Templates and code are formatted with Prettier:

```sh
npx prettier --check .
npx prettier --write .
```

## Building the container

Build the image locally (multi-stage: Hugo build → Nginx):

```sh
make build
```

Publish the multi-arch (amd64/arm64) image to GHCR:

```sh
make publish
```

CI builds and pushes the image on every push via GitHub Actions (see `.github/workflows/build.yaml`).
