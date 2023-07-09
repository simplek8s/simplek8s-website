FROM alpine:latest AS builder
WORKDIR /usr/src/app
RUN apk add --no-cache npm
COPY package.json package-lock.json ./
RUN npm ci
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo
COPY . ./
RUN hugo --minify

FROM nginx:latest
COPY --from=builder /usr/src/app/public /usr/share/nginx/html/
