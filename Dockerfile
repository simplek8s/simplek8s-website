#FROM alpine:latest AS builder
#WORKDIR /usr/src/app
#RUN apk add --no-cache npm
#COPY package.json package-lock.json ./
#RUN npm ci
#RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo
#COPY . ./
#ARG CACHEBUST
#RUN echo "$CACHEBUST"
#RUN hugo --minify

FROM hugomods/hugo:exts AS builder
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm ci
COPY . ./
ARG CACHEBUST
RUN echo "$CACHEBUST"
RUN hugo --minify

FROM nginx:latest
RUN sed -i 's/#error_page  404/error_page  404/g' /etc/nginx/conf.d/default.conf
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
COPY --from=builder /usr/src/app/public /usr/share/nginx/html/
