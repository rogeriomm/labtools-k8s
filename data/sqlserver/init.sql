-- https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility?view=sql-server-ver16&tabs=go%2Cwindows&pivots=cs1-bash

select @@VERSION;

-- testdb
:r /data/db/testdb/init.sql
:r /data/db/testdb/testdb.sql
