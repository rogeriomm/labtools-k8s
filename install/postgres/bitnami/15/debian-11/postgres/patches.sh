set -x
set -e

mkdir -p /opt/bitnami/common/include

# /opt/bitnami/common/include/google/protobuf
mkdir -p /bitnami/blacksmith-sandox/postgresql-15.5.0
mkdir -p /bitnami/blacksmith-sandox/geos-3.8.4
mkdir -p /bitnami/blacksmith-sandox/proj-6.3.2
mkdir -p /bitnami/blacksmith-sandox/gdal-3.8.2
mkdir -p /bitnami/blacksmith-sandox/json-c-0.16.20220414
mkdir -p /bitnami/blacksmith-sandox/orafce-4.9.0
mkdir -p /bitnami/blacksmith-sandox/pljava-1.6.6
mkdir -p /bitnami/blacksmith-sandox/unixodbc-2.3.12
mkdir -p /bitnami/blacksmith-sandox/psqlodbc-16.0.0
mkdir -p /bitnami/blacksmith-sandox/protobuf-3.21.12
mkdir -p /bitnami/blacksmith-sandox/protobuf-c-1.5.0
mkdir -p /bitnami/blacksmith-sandox/postgis-3.4.1
mkdir -p /bitnami/blacksmith-sandox/pgaudit-1.7.0
mkdir -p /bitnami/blacksmith-sandox/pgautofailover-2.1.0
mkdir -p /bitnami/blacksmith-sandox/pgbackrest-2.49.0
mkdir -p /bitnami/blacksmith-sandox/nss_wrapper-1.1.15

sources=/tmp/sources
mkdir -p $sources/postgresql
mkdir -p $sources/geos/
mkdir -p $sources/proj/
mkdir -p $sources/gdal
mkdir -p $sources/json-c
mkdir -p $sources/orafce
mkdir -p $sources/pljava
mkdir -p $sources/unixodbc
mkdir -p $sources/psqlodbc
mkdir -p $sources/protobuf
mkdir -p $sources/protobuf-c
mkdir -p $sources/postgis
mkdir -p $sources/pgaudit
mkdir -p $sources/pgautofailover
mkdir -p $sources/pgbackrest
mkdir -p $sources/nss_wrapper

export PATH=$PATH:/opt/bitnami/common/bin/:/opt/bitnami/postgresql/bin/


export PKG_CONFIG_PATH=/opt/bitnami/common/lib/pkgconfig:/opt/bitnami/postgresql/lib/pkgconfig

# ls /opt/bitnami/common/include/google/protobuf/compiler/command_line_interface.h

#export CFLAGS="-I/opt/bitnami/common/include -I/opt/bitnami/postgresql/include/ -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
#export CPPFLAGS="-I/opt/bitnami/common/include -I/opt/bitnami/postgresql/include/ -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
#export CXXFLAGS="-I/opt/bitnami/common/include -I/opt/bitnami/postgresql/include/ -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
#export CXXCPP="-I/opt/bitnami/common/include -I/opt/bitnami/postgresql/include/ -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"
#export LDFLAGS="-L/opt/bitnami/common/lib/ -L/opt/bitnami/postgresql/lib/ "

# Edit /opt/bitnami/postgresql/include/proj_api.h


# export LDFLAGS="-L/opt/bitnami/common/lib/ -L/opt/bitnami/postgresql/lib/ -l proj -l geos_c"
# postgis-3.4.1 build: add lib "-l proj -l geos_c"