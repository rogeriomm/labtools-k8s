echo Docker image: docker.io/bitnami/debian-base-buildpack:bullseye-r5
echo Commands: && source patches.sh
apt-get update -y
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends libedit-dev libicu-dev uuid-dev flex libpcre3-dev liblz4-dev bzip2 sqlite3 libsqlite3-dev cmake libyaml-dev libzstd-dev libbz2-dev libz-dev
export JAVA_HOME=/opt/bitnami/java
export PATH=/opt/bitnami/java/bin:$PATH
curl -SsLf "https://downloads.bitnami.com/files/stacksmith/java-11.0.21-10-0-linux-amd64-debian-11.tar.gz" -o "/opt/bitnami/java-11.0.21-10-0-linux-amd64-debian-11.tar.gz" && tar -zxf "/opt/bitnami/java-11.0.21-10-0-linux-amd64-debian-11.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && rm -rf "/opt/bitnami/java-11.0.21-10-0-linux-amd64-debian-11.tar.gz"
export PATH=/opt/bitnami/ant/bin:$PATH
mkdir -p /opt/bitnami/ant && \
    VERSION=$(curl -fsSL https://ant.apache.org/bindownload.cgi | grep -oE 'Ant [0-9]+.[0-9]+.[0-9]+ has been released' | grep -oE '[0-9]+.[0-9]+.[0-9]+') && \
curl -fsSLO https://archive.apache.org/dist/ant/binaries/apache-ant-${VERSION}-bin.tar.gz && \
tar --strip-components=1 -C /opt/bitnami/ant -xzf apache-ant-${VERSION}-bin.tar.gz && \
rm apache-ant-${VERSION}-bin.tar.gz

export PATH=/opt/bitnami/maven/bin:$PATH
mkdir -p /opt/bitnami/maven && \
    VERSION=$(curl -fsSL https://maven.apache.org/download.cgi | grep -oE 'Maven [0-9]+.[0-9]+.[0-9]+ is the latest release' | grep -oE '[0-9]+.[0-9]+.[0-9]+') && \
curl -fsSLO https://archive.apache.org/dist/maven/maven-${VERSION%%.*}/${VERSION}/binaries/apache-maven-${VERSION}-bin.tar.gz && \
tar --strip-components=1 -C /opt/bitnami/maven -xzf apache-maven-${VERSION}-bin.tar.gz && \
rm apache-maven-${VERSION}-bin.tar.gz

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -L https://github.com/google/go-containerregistry/releases/download/v0.16.1/go-containerregistry_Linux_x86_64.tar.gz -o /tmp/go-containerregistry-x86_64.tar.gz && \
    tar -zxvf /tmp/go-containerregistry-x86_64.tar.gz -C /usr/local/bin/ crane && \
    mv /usr/local/bin/crane /usr/local/bin/crane-x86_64
curl -L https://github.com/google/go-containerregistry/releases/download/v0.16.1/go-containerregistry_Linux_arm64.tar.gz -o /tmp/go-containerregistry-arm64.tar.gz && \
    tar -zxvf /tmp/go-containerregistry-arm64.tar.gz -C /usr/local/bin/ crane && \
    mv /usr/local/bin/crane /usr/local/bin/crane-arm64
mkdir -p /srp-tools && \
    curl -Lo /srp-tools/srp https://artifactory.eng.vmware.com/artifactory/srp-tools-generic-local/srpcli/0.16.10-20240108091325-b0445dd-283.1/linux-amd64/srp && \
    chmod u+x /srp-tools/srp && \
    /srp-tools/srp --version
mkdir -p /srp-tools/observer && \
    curl -Lo /srp-tools/observer.tar.gz https://artifactory.eng.vmware.com/artifactory/srp-tools-generic-local/observer/2.0.0/linux-observer-2.0.0.tar.gz && \
    tar zxf /srp-tools/observer.tar.gz -C /srp-tools/observer && \
    rm /srp-tools/observer.tar.gz && \
    chmod u+x /srp-tools/observer/bin/observer_agent && \
    /srp-tools/observer/bin/observer_agent --version
wget https://ftp.postgresql.org/pub/source/v16.1/postgresql-16.1.tar.gz -O /tmp/sources/postgresql/postgresql-16.1.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/postgresql/postgresql-16.1.tar.gz
cd /bitnami/blacksmith-sandox/postgresql-16.1
./configure  --prefix=/opt/bitnami/postgresql --with-libedit-preferred --with-openssl --with-libxml --with-libxslt --with-readline --with-icu --with-uuid=e2fs --with-ldap CFLAGS=-O2 CXXFLAGS=-O2 --with-lz4
make  world --jobs=5
make  install-world --jobs=5
wget https://github.com/libgeos/geos/archive/3.8.4.tar.gz  -O /tmp/sources/geos/geos-3.8.4.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/geos/geos-3.8.4.tar.gz
cd /bitnami/blacksmith-sandox/geos-3.8.4
./autogen.sh 
./configure  --prefix=/opt/bitnami/postgresql
make  --jobs=5
make  install --jobs=5
wget https://github.com/OSGeo/PROJ/archive/6.3.2.tar.gz -O /tmp/sources/proj/PROJ-6.3.2.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/proj/PROJ-6.3.2.tar.gz
cd /bitnami/blacksmith-sandox/PROJ-6.3.2
./autogen.sh 
./configure  --prefix=/opt/bitnami/postgresql
make  --jobs=5
make  install --jobs=5
wget https://github.com/OSGeo/gdal/releases/download/v3.8.3/gdal-3.8.3.tar.gz -O /tmp/sources/gdal/gdal-3.8.3.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/gdal/gdal-3.8.3.tar.gz
cd /bitnami/blacksmith-sandox/gdal-3.8.3
cmake  . -DCMAKE_INSTALL_PREFIX:PATH=/opt/bitnami/postgresql -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DBUILD_PYTHON_BINDINGS:BOOL=OFF -DGDAL_USE_EXTERNAL_LIBS:BOOL=OFF -DGDAL_USE_PROJ=ON -DGDAL_USE_GEOS=ON -B/bitnami/blacksmith-sandox/gdal-3.8.3/out
cd out && make  --jobs=5
cmake  --build . --target install
wget https://github.com/json-c/json-c/archive/refs/tags/json-c-0.16-20220414.tar.gz -O /tmp/sources/json-c/json-c-json-c-0.16-20220414.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/json-c/json-c-json-c-0.16-20220414.tar.gz
cd /bitnami/blacksmith-sandox/json-c-json-c-0.16-20220414
cmake  . -DCMAKE_INSTALL_PREFIX:PATH=/opt/bitnami/postgresql -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-Wno-error
make  --jobs=5
make  install --jobs=5
wget https://github.com/orafce/orafce/archive/refs/tags/VERSION_4_9_0.tar.gz -O /tmp/sources/orafce/orafce-VERSION_4_9_0.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/orafce/orafce-VERSION_4_9_0.tar.gz
cd /bitnami/blacksmith-sandox/orafce-VERSION_4_9_0
make  --jobs=5
make  install --jobs=5
wget https://github.com/tada/pljava/archive/V1_6_6.tar.gz -O /tmp/sources/pljava/pljava-1_6_6.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/pljava/pljava-1_6_6.tar.gz
cd /bitnami/blacksmith-sandox/pljava-1_6_6
mvn  clean package
java  -jar ./pljava-packaging/target/pljava-pg16.jar
wget http://www.unixodbc.org/unixODBC-2.3.12.tar.gz -O /tmp/sources/unixodbc/unixODBC-2.3.12.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/unixodbc/unixODBC-2.3.12.tar.gz
cd /bitnami/blacksmith-sandox/unixODBC-2.3.12
./configure  --prefix=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
wget https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-16.00.0000.tar.gz -O /tmp/sources/psqlodbc/psqlodbc-16.00.0000.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/psqlodbc/psqlodbc-16.00.0000.tar.gz
cd /bitnami/blacksmith-sandox/psqlodbc-16.00.0000
./configure  --prefix=/opt/bitnami/postgresql --with-pq=/opt/bitnami/postgresql --with-unixodbc=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
wget https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.21.12.tar.gz -O /tmp/sources/protobuf/protobuf-cpp-3.21.12.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/protobuf/protobuf-cpp-3.21.12.tar.gz
cd /bitnami/blacksmith-sandox/protobuf-3.21.12
./autogen.sh && ./configure  --prefix=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
wget https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz -O /tmp/sources/protobuf-c/protobuf-c-1.5.0.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/protobuf-c/protobuf-c-1.5.0.tar.gz
cd /bitnami/blacksmith-sandox/protobuf-c-1.5.0
./configure  --prefix=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
wget http://download.osgeo.org/postgis/source/postgis-3.4.1.tar.gz -O /tmp/sources/postgis/postgis-3.4.1.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/postgis/postgis-3.4.1.tar.gz
cd /bitnami/blacksmith-sandox/postgis-3.4.1
./configure  --prefix=/opt/bitnami/postgresql --with-pgconfig=/opt/bitnami/postgresql/bin/pg_config --with-geosconfig=/opt/bitnami/postgresql/bin/geos-config --with-projdir=/opt/bitnami/postgresql --with-gdalconfig=/opt/bitnami/postgresql/bin/gdal-config --with-jsondir=/opt/bitnami/postgresql --with-protobufdir=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
wget  https://github.com/pgaudit/pgaudit/archive/16.0.tar.gz -O /tmp/sources/pgaudit/pgaudit-16.0.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/pgaudit/pgaudit-16.0.tar.gz
cd /bitnami/blacksmith-sandox/pgaudit-16.0.0
make  USE_PGXS=1 --jobs=5
make  USE_PGXS=1 install --jobs=5
wget https://github.com/pgbackrest/pgbackrest/archive/release/2.49.tar.gz -O /tmp/sources/pgbackrest/pgbackrest-release-2.49.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/pgbackrest/pgbackrest-release-2.49.tar.gz
cd /bitnami/blacksmith-sandox/pgbackrest-2.49.0
./configure  --prefix=/opt/bitnami/postgresql
make  --jobs=5
make  install --jobs=5
wget https://ftp.samba.org/pub/cwrap/nss_wrapper-1.1.15.tar.gz -O /tmp/sources/nss_wrapper/nss_wrapper-1.1.15.tar.gz
tar --no-same-owner -C /bitnami/blacksmith-sandox/ -xf /tmp/sources/nss_wrapper/nss_wrapper-1.1.15.tar.gz
cd /bitnami/blacksmith-sandox/nss_wrapper-1.1.15
cmake  . -DCMAKE_INSTALL_PREFIX=/opt/bitnami/common
make  --jobs=5
make  install --jobs=5
strip  "/opt/bitnami/postgresql/bin/cct"
strip  "/opt/bitnami/postgresql/bin/clusterdb"
strip  "/opt/bitnami/postgresql/bin/createdb"
strip  "/opt/bitnami/postgresql/bin/createuser"
strip  "/opt/bitnami/postgresql/bin/cs2cs"
strip  "/opt/bitnami/postgresql/bin/dropdb"
strip  "/opt/bitnami/postgresql/bin/dropuser"
strip  "/opt/bitnami/postgresql/bin/ecpg"
strip  "/opt/bitnami/postgresql/bin/gdal_contour"
strip  "/opt/bitnami/postgresql/bin/gdal_create"
strip  "/opt/bitnami/postgresql/bin/gdal_footprint"
strip  "/opt/bitnami/postgresql/bin/gdal_grid"
strip  "/opt/bitnami/postgresql/bin/gdal_rasterize"
strip  "/opt/bitnami/postgresql/bin/gdal_translate"
strip  "/opt/bitnami/postgresql/bin/gdal_viewshed"
strip  "/opt/bitnami/postgresql/bin/gdaladdo"
strip  "/opt/bitnami/postgresql/bin/gdalbuildvrt"
strip  "/opt/bitnami/postgresql/bin/gdaldem"
strip  "/opt/bitnami/postgresql/bin/gdalenhance"
strip  "/opt/bitnami/postgresql/bin/gdalinfo"
strip  "/opt/bitnami/postgresql/bin/gdallocationinfo"
strip  "/opt/bitnami/postgresql/bin/gdalmanage"
strip  "/opt/bitnami/postgresql/bin/gdalmdiminfo"
strip  "/opt/bitnami/postgresql/bin/gdalmdimtranslate"
strip  "/opt/bitnami/postgresql/bin/gdalsrsinfo"
strip  "/opt/bitnami/postgresql/bin/gdaltindex"
strip  "/opt/bitnami/postgresql/bin/gdaltransform"
strip  "/opt/bitnami/postgresql/bin/gdalwarp"
strip  "/opt/bitnami/postgresql/bin/geod"
strip  "/opt/bitnami/postgresql/bin/gie"
strip  "/opt/bitnami/postgresql/bin/gnmanalyse"
strip  "/opt/bitnami/postgresql/bin/gnmmanage"
strip  "/opt/bitnami/postgresql/bin/initdb"
strip  "/opt/bitnami/postgresql/bin/nearblack"
strip  "/opt/bitnami/postgresql/bin/ogr2ogr"
strip  "/opt/bitnami/postgresql/bin/ogrinfo"
strip  "/opt/bitnami/postgresql/bin/ogrlineref"
strip  "/opt/bitnami/postgresql/bin/ogrtindex"
strip  "/opt/bitnami/postgresql/bin/oid2name"
strip  "/opt/bitnami/postgresql/bin/pg_amcheck"
strip  "/opt/bitnami/postgresql/bin/pg_archivecleanup"
strip  "/opt/bitnami/postgresql/bin/pg_basebackup"
strip  "/opt/bitnami/postgresql/bin/pg_checksums"
strip  "/opt/bitnami/postgresql/bin/pg_config"
strip  "/opt/bitnami/postgresql/bin/pg_controldata"
strip  "/opt/bitnami/postgresql/bin/pg_ctl"
strip  "/opt/bitnami/postgresql/bin/pg_dump"
strip  "/opt/bitnami/postgresql/bin/pg_dumpall"
strip  "/opt/bitnami/postgresql/bin/pg_isready"
strip  "/opt/bitnami/postgresql/bin/pg_receivewal"
strip  "/opt/bitnami/postgresql/bin/pg_recvlogical"
strip  "/opt/bitnami/postgresql/bin/pg_resetwal"
strip  "/opt/bitnami/postgresql/bin/pg_restore"
strip  "/opt/bitnami/postgresql/bin/pg_rewind"
strip  "/opt/bitnami/postgresql/bin/pg_test_fsync"
strip  "/opt/bitnami/postgresql/bin/pg_test_timing"
strip  "/opt/bitnami/postgresql/bin/pg_upgrade"
strip  "/opt/bitnami/postgresql/bin/pg_verifybackup"
strip  "/opt/bitnami/postgresql/bin/pg_waldump"
strip  "/opt/bitnami/postgresql/bin/pgbackrest"
strip  "/opt/bitnami/postgresql/bin/pgbench"
strip  "/opt/bitnami/postgresql/bin/postgres"
strip  "/opt/bitnami/postgresql/bin/proj"
strip  "/opt/bitnami/postgresql/bin/projinfo"
strip  "/opt/bitnami/postgresql/bin/psql"
strip  "/opt/bitnami/postgresql/bin/reindexdb"
strip  "/opt/bitnami/postgresql/bin/sozip"
strip  "/opt/bitnami/postgresql/bin/vacuumdb"
strip  "/opt/bitnami/postgresql/bin/vacuumlo"
strip  "/opt/bitnami/postgresql/lib/_int.so"
strip  "/opt/bitnami/postgresql/lib/address_standardizer-3.so"
strip  "/opt/bitnami/postgresql/lib/adminpack.so"
strip  "/opt/bitnami/postgresql/lib/amcheck.so"
strip  "/opt/bitnami/postgresql/lib/auth_delay.so"
strip  "/opt/bitnami/postgresql/lib/auto_explain.so"
strip  "/opt/bitnami/postgresql/lib/autoinc.so"
strip  "/opt/bitnami/postgresql/lib/basebackup_to_shell.so"
strip  "/opt/bitnami/postgresql/lib/basic_archive.so"
strip  "/opt/bitnami/postgresql/lib/bloom.so"
strip  "/opt/bitnami/postgresql/lib/btree_gin.so"
strip  "/opt/bitnami/postgresql/lib/btree_gist.so"
strip  "/opt/bitnami/postgresql/lib/citext.so"
strip  "/opt/bitnami/postgresql/lib/cube.so"
strip  "/opt/bitnami/postgresql/lib/cyrillic_and_mic.so"
strip  "/opt/bitnami/postgresql/lib/dblink.so"
strip  "/opt/bitnami/postgresql/lib/dict_int.so"
strip  "/opt/bitnami/postgresql/lib/dict_snowball.so"
strip  "/opt/bitnami/postgresql/lib/dict_xsyn.so"
strip  "/opt/bitnami/postgresql/lib/earthdistance.so"
strip  "/opt/bitnami/postgresql/lib/euc_cn_and_mic.so"
strip  "/opt/bitnami/postgresql/lib/euc_jp_and_sjis.so"
strip  "/opt/bitnami/postgresql/lib/euc_kr_and_mic.so"
strip  "/opt/bitnami/postgresql/lib/euc_tw_and_big5.so"
strip  "/opt/bitnami/postgresql/lib/euc2004_sjis2004.so"
strip  "/opt/bitnami/postgresql/lib/file_fdw.so"
strip  "/opt/bitnami/postgresql/lib/fuzzystrmatch.so"
strip  "/opt/bitnami/postgresql/lib/hstore.so"
strip  "/opt/bitnami/postgresql/lib/insert_username.so"
strip  "/opt/bitnami/postgresql/lib/isn.so"
strip  "/opt/bitnami/postgresql/lib/latin_and_mic.so"
strip  "/opt/bitnami/postgresql/lib/latin2_and_win1250.so"
strip  "/opt/bitnami/postgresql/lib/libecpg_compat.so.3.16"
strip  "/opt/bitnami/postgresql/lib/libecpg.so.6.16"
strip  "/opt/bitnami/postgresql/lib/libgdal.so.34.3.8.3"
strip  "/opt/bitnami/postgresql/lib/libgeos_c.so.1.13.5"
strip  "/opt/bitnami/postgresql/lib/libgeos-3.8.4.so"
strip  "/opt/bitnami/postgresql/lib/libjson-c.so.5.2.0"
strip  "/opt/bitnami/postgresql/lib/libpgtypes.so.3.16"
strip  "/opt/bitnami/postgresql/lib/libpljava-so-1.6.6.so"
strip  "/opt/bitnami/postgresql/lib/libpq.so.5.16"
strip  "/opt/bitnami/postgresql/lib/libpqwalreceiver.so"
strip  "/opt/bitnami/postgresql/lib/libproj.so.15.3.2"
strip  "/opt/bitnami/postgresql/lib/lo.so"
strip  "/opt/bitnami/postgresql/lib/ltree.so"
strip  "/opt/bitnami/postgresql/lib/moddatetime.so"
strip  "/opt/bitnami/postgresql/lib/old_snapshot.so"
strip  "/opt/bitnami/postgresql/lib/orafce.so"
strip  "/opt/bitnami/postgresql/lib/pageinspect.so"
strip  "/opt/bitnami/postgresql/lib/passwordcheck.so"
strip  "/opt/bitnami/postgresql/lib/pg_buffercache.so"
strip  "/opt/bitnami/postgresql/lib/pg_freespacemap.so"
strip  "/opt/bitnami/postgresql/lib/pg_prewarm.so"
strip  "/opt/bitnami/postgresql/lib/pg_stat_statements.so"
strip  "/opt/bitnami/postgresql/lib/pg_surgery.so"
strip  "/opt/bitnami/postgresql/lib/pg_trgm.so"
strip  "/opt/bitnami/postgresql/lib/pg_visibility.so"
strip  "/opt/bitnami/postgresql/lib/pg_walinspect.so"
strip  "/opt/bitnami/postgresql/lib/pgaudit.so"
strip  "/opt/bitnami/postgresql/lib/pgcrypto.so"
strip  "/opt/bitnami/postgresql/lib/pgoutput.so"
strip  "/opt/bitnami/postgresql/lib/pgrowlocks.so"
strip  "/opt/bitnami/postgresql/lib/pgstattuple.so"
strip  "/opt/bitnami/postgresql/lib/pgxml.so"
strip  "/opt/bitnami/postgresql/lib/pgxs/src/test/isolation/isolationtester"
strip  "/opt/bitnami/postgresql/lib/pgxs/src/test/isolation/pg_isolation_regress"
strip  "/opt/bitnami/postgresql/lib/pgxs/src/test/regress/pg_regress"
strip  "/opt/bitnami/postgresql/lib/plpgsql.so"
strip  "/opt/bitnami/postgresql/lib/postgis_raster-3.so"
strip  "/opt/bitnami/postgresql/lib/postgis_topology-3.so"
strip  "/opt/bitnami/postgresql/lib/postgis-3.so"
strip  "/opt/bitnami/postgresql/lib/postgres_fdw.so"
strip  "/opt/bitnami/postgresql/lib/psqlodbca.so"
strip  "/opt/bitnami/postgresql/lib/psqlodbcw.so"
strip  "/opt/bitnami/postgresql/lib/refint.so"
strip  "/opt/bitnami/postgresql/lib/seg.so"
strip  "/opt/bitnami/postgresql/lib/sslinfo.so"
strip  "/opt/bitnami/postgresql/lib/tablefunc.so"
strip  "/opt/bitnami/postgresql/lib/tcn.so"
strip  "/opt/bitnami/postgresql/lib/test_decoding.so"
strip  "/opt/bitnami/postgresql/lib/tsm_system_rows.so"
strip  "/opt/bitnami/postgresql/lib/tsm_system_time.so"
strip  "/opt/bitnami/postgresql/lib/unaccent.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_big5.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_cyrillic.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_euc_cn.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_euc_jp.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_euc_kr.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_euc_tw.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_euc2004.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_gb18030.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_gbk.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_iso8859_1.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_iso8859.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_johab.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_sjis.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_sjis2004.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_uhc.so"
strip  "/opt/bitnami/postgresql/lib/utf8_and_win.so"
strip  "/opt/bitnami/postgresql/lib/uuid-ossp.so"
strip  "/opt/bitnami/common/bin/protoc"
strip  "/opt/bitnami/common/bin/protoc-gen-c"
strip  "/opt/bitnami/common/lib/libodbc.so.2.0.0"
strip  "/opt/bitnami/common/lib/libodbccr.so.2.0.0"
strip  "/opt/bitnami/common/lib/libodbcinst.so.2.0.0"
strip  "/opt/bitnami/common/lib/libprotobuf-c.so.1.0.0"
strip  "/opt/bitnami/common/lib/libprotobuf-lite.so.32.0.12"
strip  "/opt/bitnami/common/lib/libprotobuf.so.32.0.12"
strip  "/opt/bitnami/common/lib/libprotoc.so.32.0.12"
