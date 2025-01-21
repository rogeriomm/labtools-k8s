FROM bitnami/postgresql:15.5.0-debian-11-r18

USER root:root

COPY ./plugin/decoderbufs.control /opt/bitnami/postgresql/share/extension/
COPY ./plugin/decoderbufs.so /opt/bitnami/postgresql/lib/

# FIX libprotobuf-c.so.1 => not found
#  ldd /opt/bitnami/postgresql/lib/decoderbufs.so
#        linux-vdso.so.1 (0x00007ffe7f799000)
#        libprotobuf-c.so.1 => /usr/lib/x86_64-linux-gnu/libprotobuf-c.so.1 (0x00007ff610db6000)
#        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff610be2000)
#        /lib64/ld-linux-x86-64.so.2 (0x00007ff610dd1000)
RUN ln -s /opt/bitnami/common/lib/libprotobuf-c.so.1 /usr/lib/x86_64-linux-gnu/

USER 1001
