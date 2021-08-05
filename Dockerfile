FROM ghcr.io/linuxserver/baseimage-alpine:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MONIT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

RUN \
  echo "**** install packages ****" && \
  apk add --update --no-cache --virtual=build-dependencies \
    gcc \
    musl-dev \
    python3-dev \
    py3-wheel \
    libffi-dev \
    openssl-dev
    cargo && \
  apk add -U --upgrade --no-cache  \
    bash \
    curl \
    python3 \
    py3-pip && \
  apk add -U --upgrade --no-cache \
    monit==${MONIT_RELEASE} && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine/ \
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