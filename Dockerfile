FROM ubuntu:24.04
LABEL maintainer="LanCache.Net Team <team@lancache.net>"
ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install supervisor curl wget bzip2 locales tzdata --no-install-recommends && \
    locale-gen en_GB.utf8 && \
    update-locale LANG=en_GB.utf8 && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Installing these here even though they are already in monolithic.  Speeds up testing a bit
# TODO remove
RUN apt-get update && \
    apt-get install -y  nginx-full jq git nano apt-transport-https ca-certificates --no-install-recommends && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

ENV \
    SUPERVISORD_EXIT_ON_FATAL=1 \
    LC_ALL=en_GB.UTF-8 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB.UTF-8 \
    TZ=Europe/London \
    SUPERVISORD_LOGLEVEL=WARN

COPY overlay/ /
RUN chmod -R 755 /init /hooks

ENTRYPOINT ["/bin/bash", "-e", "/init/entrypoint", "/init/supervisord"]