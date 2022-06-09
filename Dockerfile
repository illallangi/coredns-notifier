# coredns image
FROM docker.io/coredns/coredns:1.9.3 as coredns

# builder image - compile confd
FROM ghcr.io/illallangi/confd-builder:v0.0.3 as confd

# main image
FROM docker.io/library/debian:buster-20220527

# install confd from builder image
COPY --from=confd /go/bin/confd /usr/local/bin/confd

# install coredns from docker hub image
COPY --from=coredns /coredns /usr/local/bin/coredns

# install prerequisites
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
      musl=1.1.21-2 \
    && \
    rm -rf /var/lib/apt/lists/*

COPY root/ /
ENTRYPOINT ["custom-entrypoint"]
CMD ["/usr/local/bin/coredns","-conf", "/etc/coredns/Corefile"]
