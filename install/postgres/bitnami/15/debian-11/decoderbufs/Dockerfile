FROM bitnami/postgresql:15.5.0-debian-11-r18

USER root:root

COPY ./plugin/decoderbufs.control /opt/bitnami/postgresql/share/extension/
COPY ./plugin/decoderbufs.so /opt/bitnami/postgresql/lib/

USER 1001
