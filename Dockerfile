# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.19

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

RUN \
  echo "**** install packages ****" && \
  apk add --update --no-cache --virtual=build-dependencies \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo && \
  apk add -U --upgrade --no-cache  \
    python3 && \
  echo "**** install monit ****" && \
  if [ -z ${APP_VERSION+x} ]; then \
    APP_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.19/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:'"monit"'$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add -U --upgrade --no-cache \
    monit==${APP_VERSION} && \
  python3 -m venv /lsiopy && \
  pip3 install -U --no-cache-dir \
    pip \
    wheel && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.19/ \
    apprise && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    /root/.cargo \
    /root/.cache

COPY root/ /

EXPOSE 2812

VOLUME /config
