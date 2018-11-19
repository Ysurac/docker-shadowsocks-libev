The Dockerfile is modified from https://github.com/shadowsocks/shadowsocks-libev/docker/alpine with no crypto patch from https://github.com/SPYFF/shadowsocks-libev-nocrypto

# Shadowsocks-libev Docker Image

shadowsocks-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
It is a port of shadowsocks created by @clowwindy maintained by @madeye and @linusyang.

## Pull the image

```bash
$ docker pull ysurac/shadowsocks-libev
```
This pulls the latest release of shadowsocks-libev.

## Start a container

```bash
$ docker run -p 8388:8388 -p 8388:8388/udp -d --restart always ysurac/shadowsocks-libev:latest
```

