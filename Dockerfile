FROM --platform=$BUILDPLATFORM hugomods/hugo:node AS builder_base
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm ci

FROM --platform=$BUILDPLATFORM builder_base AS builder
COPY --parents hugo.toml archetypes assets config content data layouts static themes ./
RUN --mount=type=cache,target=/tmp/hugo_cache \
    hugo --minify --environment production

FROM nginx:latest AS site
COPY <<EOF /etc/nginx/conf.d/privacy.conf
server_tokens off;
EOF
COPY <<EOF /etc/nginx/conf.d/gzip.conf
gzip on;
gzip_disable "msie6";
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_min_length 256;
gzip_types
  application/atom+xml
  application/geo+json
  application/javascript
  application/x-javascript
  application/json
  application/ld+json
  application/manifest+json
  application/rdf+xml
  application/rss+xml
  application/xhtml+xml
  application/xml
  font/eot
  font/otf
  font/ttf
  image/svg+xml
  text/css
  text/javascript
  text/plain
  text/xml;
EOF
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

	location /download {
		expires 1h;
        root /usr/share/nginx/html;
	}
    location / {
		expires 1d;
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page  404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
COPY --from=builder /usr/src/app/public /usr/share/nginx/html/
