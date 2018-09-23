# Tor - stable version

FROM armhf/alpine:latest
MAINTAINER Edilson Jardim Filho "https://github.com/54cr4m3n70"

ENV TOR_VERSION 0.3.4.8

EXPOSE 9050

RUN export GPG_TTY=/dev/console

RUN build_pkgs=" \
        openssl-dev \
        zlib-dev \
        libevent-dev \
        gnupg \
        " \
  && runtime_pkgs=" \
        build-base \
        openssl \
        zlib \
        libevent \
        " \
  && apk --update add ${build_pkgs} ${runtime_pkgs} \
  && cd /tmp \
  && wget https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz \
  && wget https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz.asc \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x4E2C6E8793298290 \
  || gpg --fingerprint 0x4E2C6E8793298290 \
  || gpg --verify tor-$TOR_VERSION.tar.gz.asc \
  && tar xzf tor-$TOR_VERSION.tar.gz \
  && cd /tmp/tor-$TOR_VERSION \
  && ./configure \
  && make -j6 \
  && make install \
  && cd \
  && rm -rf /tmp/* \
  && apk del ${build_pkgs} \
  && rm -rf /var/cache/apk/*

RUN adduser -Ds /bin/sh tor

RUN mkdir /etc/tor
COPY torrc /etc/tor/

USER tor
CMD ["tor", "-f", "/etc/tor/torrc"]
