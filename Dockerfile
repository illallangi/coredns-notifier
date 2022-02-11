# builder image - compile confd
FROM golang:1.9-alpine as confd

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN \
  apk add --no-cache \
    bzip2 \
    make && \
  mkdir -p /go/src/github.com/kelseyhightower/confd && \
  cd /go/src/github.com/kelseyhightower/confd && \
  tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
  go install github.com/kelseyhightower/confd && \
  rm -rf /tmp/v${CONFD_VERSION}.tar.gz

# main image
FROM docker.io/library/debian:buster-20220125

# install confd from builder image
COPY --from=confd /go/bin/confd /usr/local/bin/confd

# install coredns from docker hub image
COPY --from=docker.io/coredns/coredns:1.9.0 /coredns /usr/local/bin/coredns

# install prerequisites
RUN \
  apt-get update \
  && \
  apt-get install -y \
    musl \
  && \
  apt-get clean

COPY root/ /
ENTRYPOINT ["custom-entrypoint"]
CMD ["/usr/local/bin/coredns","-conf", "/etc/coredns/Corefile"]

ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
LABEL maintainer="Andrew Cole <andrew.cole@illallangi.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="TODO: Specify Description" \
      org.label-schema.name="coredns-notifier" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="http://github.com/illallangi/coredns-notifier" \
      org.label-schema.usage="https://github.com/illallangi/coredns-notifier/blob/master/README.md" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/illallangi/coredns-notifier" \
      org.label-schema.vendor="Illallangi Enterprises" \
      org.label-schema.version=$VERSION
