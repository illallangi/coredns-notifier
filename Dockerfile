# Main image
FROM docker.io/coredns/coredns:1.8.4

COPY ./root /

CMD ["-conf", "/etc/coredns/Corefile"]

ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
LABEL maintainer="Andrew Cole <andrew.cole@illallangi.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="TODO: Specify Description" \
      org.label-schema.name="dnsrpzrecord-coredns" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="http://github.com/illallangi/dnsrpzrecord-controller" \
      org.label-schema.usage="https://github.com/illallangi/dnsrpzrecord-controller/blob/master/README.md" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/illallangi/dnsrpzrecord-coredns" \
      org.label-schema.vendor="Illallangi Enterprises" \
      org.label-schema.version=$VERSION
