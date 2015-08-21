# vim:set ts=2 sw=2 sts=2 et:
FROM debian:jessie
MAINTAINER Hellyna NG <hellyna@hellyna.com>

ENV DEBIAN_FRONTEND=noninteractive \
    OPENRESTY_VERSION=1.9.3.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl

RUN curl -LO "https://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz" && \
    tar -xvf "ngx_openresty-${OPENRESTY_VERSION}.tar.gz"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libncurses5-dev \
      libpcre3-dev \
      libreadline-dev \
      libssl-dev \
      make \
      perl

RUN cd "ngx_openresty-${OPENRESTY_VERSION}" && \
    ./configure \
      --with-ipv6 \
      --with-pcre-jit \
      -j5 && \
    make -j5 && \
    make install

RUN apt-get purge -y \
      build-essential \
      curl \
      libncurses5-dev \
      libpcre3-dev \
      libreadline-dev \
      libssl-dev \
      make \
      perl && \
     apt-get install -y --no-install-recommends \
      libncurses5 \
      libpcre3 \
      libreadline6 \
      libssl1.0.0 \
      perl && \
     apt-get autoremove -y && \
     apt-get clean -y && \
     rm -rvf \
       "/ngx_openresty-${OPENRESTY_VERSION}" \
       "/ngx_openresty-${OPENRESTY_VERSION}.tar.gz" \
       /var/lib/apt/lists/* \
       /var/tmp/* \
       /tmp/*

ENV OPENRESTY_DIR=/usr/local/openresty
ENV PATH="${OPENRESTY_DIR}/nginx/sbin:${PATH}"

RUN ln -svf /dev/stdout "${OPENRESTY_DIR}/nginx/logs/access.log" && \
    ln -svf /dev/stderr "${OPENRESTY_DIR}/nginx/logs/error.log"

EXPOSE 80/tcp 443/tcp

CMD ["nginx", "-g", "daemon off;"]
