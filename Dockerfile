FROM alpine:latest AS builder
WORKDIR /usr/src/app
RUN apk add --no-cache npm
COPY package.json package-lock.json ./
RUN npm ci
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo
COPY . ./
RUN hugo --minify

FROM nginx:latest
RUN sed -i 's/#error_page  404/error_page  404/g' /etc/nginx/conf.d/default.conf
COPY <<EOF /etc/nginx/conf.d/privacy.conf
server_tokens off;
EOF
COPY --from=builder /usr/src/app/public /usr/share/nginx/html/
