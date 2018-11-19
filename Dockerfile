#
# Dockerfile for shadowsocks-libev
#

FROM alpine
LABEL maintainer="Ycarus (Yannick Chabanois) <ycarus@zugaina.org>"

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_ADDR_IPV6 ::0
ENV SERVER_PORT 8388
ENV KEY=
ENV METHOD      aes-256-gcm
ENV TIMEOUT     300
ENV DNS_ADDRS    8.8.8.8,8.8.4.4
ENV ARGS=
ENV SS_VERSION 3.2.1

ADD https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VERSION}/shadowsocks-libev-${SS_VERSION}.tar.gz /tmp/
RUN tar xvf /tmp/shadowsocks-libev-${SS_VERSION}.tar.gz -C /tmp/
WORKDIR /tmp/shadowsocks-libev-${SS_VERSION}
RUN apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      patch \
      pcre-dev

ADD https://github.com/Ysurac/openmptcprouter-feeds/raw/master/shadowsocks-libev/patches/020-NOCRYPTO.patch /tmp/shadowsocks-libev-${SS_VERSION}
RUN patch -p1 < 020-NOCRYPTO.patch
RUN autoreconf --install --force && ./configure --prefix=/usr --disable-documentation
RUN make install
RUN apk del .build-deps \
 && apk add --no-cache \
      rng-tools \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u)
RUN rm -rf /tmp/shadowsocks-libev-${SS_VERSION}

USER nobody

CMD exec ss-server \
      -s $SERVER_ADDR \
      -s $SERVER_ADDR_IPV6 \
      -p $SERVER_PORT \
      --key $KEY \
      -m $METHOD \
      -t $TIMEOUT \
      -d $DNS_ADDRS \
      -u \
      $ARGS
