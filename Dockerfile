# coredns image
FROM docker.io/coredns/coredns:1.9.0 as coredns

# builder image - compile confd
FROM docker.io/library/golang:1.9-alpine as confd

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN mkdir -p /go/src/github.com/kelseyhightower/confd

WORKDIR /go/src/github.com/kelseyhightower/confd

RUN \
  apk add --no-cache \
    bzip2=1.0.6-r7 \
    make=4.2.1-r2 \
  && \
  tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
  go install github.com/kelseyhightower/confd && \
  rm -rf /tmp/v${CONFD_VERSION}.tar.gz

# main image
FROM docker.io/library/debian:buster-20220509

# install confd from builder image
COPY --from=confd /go/bin/confd /usr/local/bin/confd

# install coredns from docker hub image
COPY --from=coredns /coredns /usr/local/bin/coredns

# install prerequisites
RUN \
  apt-get update \
  && \
  apt-get install -y \
    musl=1.1.21-2 \
  && \
    rm -rf /var/lib/apt/lists/*

COPY root/ /
ENTRYPOINT ["custom-entrypoint"]
CMD ["/usr/local/bin/coredns","-conf", "/etc/coredns/Corefile"]
